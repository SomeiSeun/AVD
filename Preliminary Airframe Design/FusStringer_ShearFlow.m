function [Stringers, Boom, Fus, fuselageShear] = FusStringer_ShearFlow(BendingMoment,...
    diameter, T, SYS, A_fus, Sy, E, T2, Sy2)
% Use a datasheet to choose stringer area, as there are too many unknowns
% Use a brute force method: select As, b and ts and then iterate twice and choose the configuration that gives
% lowest weight. 

% We don't have to do the design for every discretised station- simply look
% for worst case and use that to select variables. Then use those same
% variables everywhere

% StringerShape: Z stringers
% Assume constant stringer pitch for both tensile side and compression side

%%  1. Bending
Circ=pi*diameter;
M=max(-BendingMoment); %use worst bending moment for sizing stringers

StringerSpacing=convlength(7,'in','m');  % Use value from notes as a starting point; range is 6.5-9 inches
SkinThickness= 0.0005;%t_f; %initial guess - based on literature review
%initial guesses for stringer profile parameters - based on literature review
L=15e-3; %flange width
t_s=2e-3; %stringer thickness
h=30e-3; %height
A_s=L*t_s*2+(h-2*t_s)*t_s;
As_bt=A_s/(StringerSpacing*SkinThickness);
ts_t=t_s/SkinThickness;
%from Farrar diagram, with F=0.6--> 
t_s=0.375*SkinThickness;
NumStringers=round(Circ/StringerSpacing); 
TtlStringerArea= NumStringers*A_s;
SkinEquivBoomArea=(SkinThickness*StringerSpacing/6)*(2+1); %Boom area from skin can also be considered as 15*t
SingleBoomArea=TtlStringerArea+SkinEquivBoomArea; 
%idealise into booms
Boom.Number=1:NumStringers;
Boom.Angle=0:(2*pi)/NumStringers: 2*pi; %in radians
Boom.X= (diameter/2).*cos(Boom.Angle); %boom x coordinate
Boom.Y=(diameter/2).*sin(Boom.Angle);%boom y coordinate
y_coordinates = Boom.Y;

figure() %plot booms 
scatter(Boom.X,Boom.Y) 
xlabel('Fuselage cross section x coordinate')
ylabel('Fuselage cross section y coordinate')
title('Booms around the fuselage cross-section')

Boom.S_x =SingleBoomArea.*Boom.Y; %first moment of area
x_centroid=(sum(Boom.S_x))/(SingleBoomArea*NumStringers);
Boom.I_individual=SingleBoomArea.*(Boom.Y.^2);

I_xx=sum(Boom.I_individual); %second moment of area
Edge_maxStress=max(Boom.Y); %use the y value of highest stringer as that is the furthest from neutral axis
sigma= M*Edge_maxStress/I_xx/10^6; %max principle stress

%plot of direct stress at each stringer
Stringer_stress=zeros(1,NumStringers); 
for i = 1:length(Boom.Number)
        Stringer_stress(i) = (Boom.Y(i)*M)/I_xx; %calculates the stress at each stringer
end

figure()
quiver3(Boom.X,Boom.Y,zeros(1,NumStringers+1),zeros(1,NumStringers+1),zeros(1,NumStringers+1),[Stringer_stress, Stringer_stress(1)])
hold on
axis tight
grid on
grid minor
xlabel('X coordinate along fuselage cross section (m)')
ylabel('Y coordinate along fuselage cross section (m)')
zlabel('Direct Stress (GPa)')
plot3(Boom.X,Boom.Y,zeros(1,NumStringers+1),'LineWidth',2.5)
legend('Direct Stress at each Stringer', 'Fuselage Cross Section')
hold off
%% 2. Shear flow
%max shear force is Sy
%torque --> doubt it can be zero, when the whole objective of this is to
%size for worst case scenario??? (AB)

% TtlSectionArea=SingleBoomArea*NumStringers;
% ShearFlow_Shear=Sy/pi/diameter/2;
% ShearFlow_Torque=T/2/(pi*diameter^2/4);
% Tau_max= (ShearFlow_Shear+ShearFlow_Torque)/SkinThickness/10^6; %max shear stress

% Shear flow analysis for Load Case 1
fuselageShear.q_b = zeros(1,NumStringers);
fuselageShear.q_0 = zeros(1,NumStringers);

for i = 1:NumStringers
    fuselageShear.q_b(i) = -(Sy / I_xx) * A_s * y_coordinates(i);
    fuselageShear.q_0(i) = T / (2 * A_fus);
    fuselageShear.q(i) = fuselageShear.q_b(i) + fuselageShear.q_0(i);
end
maxshearstress = max(fuselageShear.q) / SkinThickness;
iteratedSkinThickness = max(fuselageShear.q) / SYS;
sigma_crit_buckling_shear = 5 * E * (iteratedSkinThickness/StringerSpacing)^2;

if sigma_crit_buckling_shear > maxshearstress
    disp('The maximum shear stress is below the critical buckling load.')
else
    disp('The maximum shear stress is above the critical buckling load. So change variable values.')
end

% Shear flow analysis for Load Case 2
fuselageShear.q_b2 = zeros(1,NumStringers);
fuselageShear.q_02 = zeros(1,NumStringers);

for i = 1:NumStringers
    fuselageShear.q_b2(i) = -(Sy2 / I_xx) * A_s * y_coordinates(i);
    fuselageShear.q_02(i) = T2 / (2 * A_fus);
    fuselageShear.q2(i) = fuselageShear.q_b(i) + fuselageShear.q_0(i);
end

%
%deboom areas into skin and stringer 
%from size of stringer (geometry) work out contribution of stringers to boom area

% skin contribution - 15*t (from notes)
SkinArea_deboom=15*SkinThickness;
StrArea_deboom=SingleBoomArea-SkinArea_deboom;


%design stringer shape to match area
t_s= ;%stringer thickness
h= ;%stringer height
L= ;%stringer flange
A_s_check=L*t_s*2+(h-2*t_s)*t_s;

if A_s==A_s_check
    disp('stringer areas match')
end 

%plot stringer geometry


%% 3. check against yielding and buckling - NOT DONE!
%check stringer stress with yield 
TensileYield=525e6; %Pa
if max(Stringer_stress)>TensileYield
    TY=0;
else
    TY=1;
end 

%stringers - Euler buckling

%%  4.Check bay area between stringers  with yield and local plate buckling stress - NOT DONE!
%initial buckling of skin-stringer panel
t_e=SkinThickness+A_s/StringerSpacing; %effective thickness
BoxWidth=
StringerPitch=BoxWidth/(NumStringers+1);
%}
%%  outputs
%create structure of outputs
Stringers.spacing=StringerSpacing;
Stringers.TotalArea=TtlStringerArea;
Stringers.Area=A_s;
Stringers.As_bt=As_bt;
Stringers.ts_t=ts_t;
Stringers.TY_check=TY;
Stringers.Stress=Stringer_stress;
Fus.x_centroid=x_centroid;
Fus.Ixx=I_xx;
Fus.maxBM=M;
Fus.principleStress=sigma;
fuselageShear.Tau_max=maxshearstress;
end