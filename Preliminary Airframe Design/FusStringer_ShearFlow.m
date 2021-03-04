function [Stringers, Boom, Fus, fuselageShear,iteratedSkinThickness] = FusStringer_ShearFlow(BendingMoment, diameter, T, SYS, A_fus, Sy)
%%function for first iteration

% Use a datasheet to choose stringer area, as there are too many unknowns
% Use a brute force method: select As, b and ts and then iterate twice and choose the configuration that gives
% lowest weight. 
% 
% We don't have to do the design for every discretised station- simply look
% for worst case and use that to select variables. Then use those same
% variables everywhere

% StringerShape: Z stringers
% Assume constant stringer pitch for both tensile side and compression side
YM_stringer= 78e9; %Pa 
% %  1. Bending
Circ=pi*diameter;
M=max(-BendingMoment); %use worst bending moment for sizing stringers
StringerSpacing=convlength(7,'in','m');  % Use value from notes as a starting point; range is 6.5-9 inches
SkinThickness= 0.0025;%t_f; %initial guess - based on literature review
% initial guesses for stringer profile parameters - based on literature review
L=15e-3; %flange width
t_s=2e-3; %stringer thickness
h=30e-3; %height
A_s=L*t_s*2+(h-2*t_s)*t_s;
As_bt=A_s/(StringerSpacing*SkinThickness);
ts_t=t_s/SkinThickness;
% from Farrar diagram, with F=0.6--> 
t_s=0.375*SkinThickness;
NumStringers=round(Circ/StringerSpacing); 
TtlStringerArea= NumStringers*A_s;
SkinEquivBoomArea=(SkinThickness*StringerSpacing/6)*(2+1); %Boom area from skin can also be considered as 15*t
SingleBoomArea=A_s+SkinEquivBoomArea; %i think it needs to be A_s and not TtlStringerArea
% idealise into booms
Boom.Number=1:NumStringers;
Boom.Angle=0:(2*pi)/NumStringers: 2*pi; %in radians
Boom.X= (diameter/2).*cos(Boom.Angle); %boom x coordinate
Boom.Y=(diameter/2).*sin(Boom.Angle);%boom y coordinate
y_coordinates = Boom.Y;

% figure() %plot booms 
% scatter(Boom.X,Boom.Y) 
% xlabel('Fuselage cross section x coordinate')
% ylabel('Fuselage cross section y coordinate')
% title('Booms around the fuselage cross-section')

Boom.S_x =SingleBoomArea.*Boom.Y; %first moment of area
x_centroid=(sum(Boom.S_x))/(SingleBoomArea*NumStringers);
Boom.I_individual=SingleBoomArea.*(Boom.Y.^2);

I_xx=sum(Boom.I_individual); %second moment of area
Edge_maxStress=max(Boom.Y); %use the y value of highest stringer as that is the furthest from neutral axis
sigma= M*Edge_maxStress/I_xx/10^6; %max principle stress

% plot of direct stress at each stringer
Stringer_stress=zeros(1,NumStringers); 
for i = 1:length(Boom.Number)
        Stringer_stress(i) = (Boom.Y(i)*M)/I_xx; %calculates the stress at each stringer
end

% figure()
% quiver3(Boom.X,Boom.Y,zeros(1,NumStringers+1),zeros(1,NumStringers+1),zeros(1,NumStringers+1),[Stringer_stress, Stringer_stress(1)])
% hold on
% axis tight
% grid on
% grid minor
% xlabel('X coordinate along fuselage cross section (m)')
% ylabel('Y coordinate along fuselage cross section (m)')
% zlabel('Direct Stress (GPa)')
% plot3(Boom.X,Boom.Y,zeros(1,NumStringers+1),'LineWidth',2.5)
% legend('Direct Stress at each Stringer', 'Fuselage Cross Section')
% hold off
%% 2. Shear flow
% max shear force is Sy
% torque --> doubt it can be zero, when the whole objective of this is to
% size for worst case scenario??? (AB)
% 
TtlSectionArea=SingleBoomArea*NumStringers;
ShearFlow_Shear=Sy/pi/diameter/2;
ShearFlow_Torque=T/2/(pi*diameter^2/4);
Tau_max= (ShearFlow_Shear+ShearFlow_Torque)/SkinThickness/10^6; %max shear stress


fuselageShear.q_b = zeros(1,NumStringers);
fuselageShear.q_0 = zeros(1,NumStringers);

for i = 1:NumStringers
    fuselageShear.q_b(i) = -(Sy / I_xx) * A_s * y_coordinates(i);
    fuselageShear.q_0(i) = T / (2 * A_fus);
    fuselageShear.q(i) = fuselageShear.q_b(i) + fuselageShear.q_0(i);
end
maxshearstress = max(fuselageShear.q) / SkinThickness;
iteratedSkinThickness = max(fuselageShear.q) / SYS/10^6;
sigma_crit_buckling_shear = 5 * YM_stringer * (iteratedSkinThickness/StringerSpacing)^2;

if sigma_crit_buckling_shear > maxshearstress
    disp('The maximum shear stress is below the critical buckling load.')
else
    disp('The maximum shear stress is above the critical buckling load. So change variable values.')
end

%% deboom areas into skin and stringer -CLUELESS HERE
% from size of stringer (geometry) work out contribution of stringers to boom area

% skin contribution - 15*t (from notes)
Skin_deboom=15*SkinThickness;
A_s_deboom=SingleBoomArea-Skin_deboom;

% design stringer shape to match area
h_deboom=h ;%stringer height
L_deboom=L ;%stringer flange
% A_s_deboom=L*t_s*2+(h-2*t_s)*t_s;
t_s_deboom=A_s_deboom/(h_deboom+2*L_deboom);

%plot stringer geometry


%% check stringer stress 
%yield
TensileYield=525e6; %Pa
if max(Stringer_stress)>TensileYield
    TY=0;
else
    TY=1;
end 


%% Check bay area between stringers  with yield and local plate buckling stress - NOT DONE!
%yield
% initial buckling of skin-stringer panel
for i=1:length(BendingMoment)
    N=BendingMoment(i)/(A_fus);
end
t_e=SkinThickness+A_s/StringerSpacing; %effective thickness
% BoxWidth=
% StringerPitch=BoxWidth/(NumStringers+1);

%local plate buckling
%%  outputs
% create structure of outputs
Stringers.spacing=StringerSpacing;
Stringers.TotalArea=TtlStringerArea;
Stringers.Area=A_s;
Stringers.As_bt=As_bt;
Stringers.ts_t=ts_t;
Stringers.TY_check=TY;
% Stringers.EulerBuckling_check=Euler_buckling;
Stringers.Stress=Stringer_stress;
Fus.x_centroid=x_centroid;
Fus.Ixx=I_xx;
Fus.maxBM=M;
Fus.principleStress=sigma;
fuselageShear.Tau_max=maxshearstress;

end