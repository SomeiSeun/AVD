function [Stringers, Boom] = FusStringerSizing(BendingMoment, diameter)
% Use a datasheet to choose stringer area, as there are too many unknowns
% Use a brute force method, select As and ts and then iterate twice. Three
% variables would be As, ts and pitch b. Choose the configuration that gives
% lowest weight

% We don't have to do the design for every discretised station- simply look
% for worst case and use that to select variables. Then use those same
% variables everywhere
%% bending
Circ=pi*diameter;
M=max(BendingMoment); %use worst bending moment for sizing stringers
StringerSpacing=convlength(7,'in','m');  % Use value from notes as a starting point; range is 6.5-9 inches
NumStringers=round(Circ/StringerSpacing); 

%idealise into booms
Boom.Number=1:NumStringers;
% Boom.Location=linspace(0,2*pi,NumStringers);
Boom.Angle=0:(2*pi)/NumStringers: 2*pi; %in radians
Boom.X= (diameter/2).*cos(Boom.Angle); %boom x coordinate
Boom.Y=(diameter/2).*sin(Boom.Angle);%boom y coordinate
% Boom.Area=Boom.Y*SingleBoomArea;
figure() %plot booms 
scatter(Boom.X,Boom.Y) 
xlabel('X')
ylabel('Y')
title('Booms around the fuselage cross-section')

SkinThickness= %t_f; %initial guess - based on literature review
A_s= %initial guess - based on literature review
TtlStringerArea= NumStringers*A_s;
SkinEquivBoomArea=(SkinThickness*StringerSpacing/6)*(2+1); %Boom area from skin can also be considered as 15*t
SingleBoomArea=TtlStringerArea+SkinEquivBoomArea; 
Boom.S_x =SingleBoomArea.Y; %first moment of area

Boom.I_individual=SingleBoomArea.*Y.^2;
Boom.I_xx=sum(Boom.I_individual); %second moment of area
x_centroid=(sum(Boom.Area))/(SingleBoomArea*NumStringers);
EdgeStress_max=  %use the y value of highest stringer as that is the
% furthest from neutral axis
sigma= M*EdgeStress_max/I/10^6; %max principle stress

%now use these values in shear flow code, and get a skin thickness. Iterate
%again and compare total weight of the two loops
%% check stringer stress with yield and Euler buckling

%% 4.Check bay area between stringers  with yield and local plate buckling stress.


%%extra: not sure where this goes (AB)
% StringerShape: Z stringers
FrameDepth=convlength(4.0, 'in','m');    % Range is 3.5-4.4
FrameSpacing=convlength(20, 'in','m');

% Materials to use: 2000 series for skin and 7000 series for stringer

% Aassume constant stringer pitch for both tensile side and compression side


%create structure of outputs
Stringers.spacing=StringerSpacing;
end