function [Stringers, Boom] = Fuselage_stringer_shear_flow(BendingMoment, diameter, T, SYS, A_fus, Sy)
% Creating a function which sizes the stringers and skin for the fuselage
% by using an iterative method

% The INPUTS are:
% BendingMoment = an array with the bending moment distribution
% diameter = diameter of the fuselage
% T = torque on the fuselage
% SYS = Shear Yield Stress
% A_fus = area of the fuselage cross section
% Sy = max shear force acting on the fuselage

% The OUTPUTS are:
% Stringers = structure with the appropriate variables
% Boom = structure with the appropriate variables

% Bending moment 
Circ = pi*diameter;
%M = max(BendingMoment);                     % Using worst bending moment as a worst case scenario
StringerSpacing = convlength(7,'in','m');   % Setting an inital guess for stringer spacing (range is 6.5-9 inches)
NumStringers = round(Circ/StringerSpacing); % Number of stringers around the fuselage

% Idealising the stringers into booms
Boom.Number = 1:NumStringers;
% Boom.Location=linspace(0,2*pi,NumStringers);
Boom.Angle = 0:(2*pi)/NumStringers: 2*pi; % Angle in radians
Boom.X = (diameter/2).*cos(Boom.Angle);   % X coordinates
Boom.Y = (diameter/2).*sin(Boom.Angle);   % Y coordinates
% Boom.Area=Boom.Y*SingleBoomArea;

% Plotting the booms
figure
scatter(Boom.X,Boom.Y)
xlabel('X')
ylabel('Y')
title('Booms around the fuselage cross-section')

SkinThickness = 0.001;                                       % Initial guess for the fuselage skin thickness
A_s = 2.4e-5;                                                % Initial guess for the area of a stringer
fuselage.q_b = zeros(1,NumStringers);
fuselage.q_0 = zeros(1,NumStringers);

for j = 1:5
TtlStringerArea = NumStringers * A_s;                        % Total area of the stringers
SkinEquivBoomArea = (SkinThickness*StringerSpacing/6)*(2+1); % Boom area from skin can also be considered as 15*t
SingleBoomArea = TtlStringerArea+SkinEquivBoomArea; 
Boom.S_x = SingleBoomArea.Y;                                 % First moment of area

Boom.I_individual = SingleBoomArea.*Y.^2;
Boom.I_xx = sum(Boom.I_individual);       % Second moment of area
%x_centroid = (sum(Boom.Area))/(SingleBoomArea*NumStringers);
%EdgeStress_max = diameter/2;              % Use the y value of highest stringer as that is the furthest from neutral axis
%sigma = M*EdgeStress_max/I/10^6;         % Max principle stress

% Doing the shear flow calculations

fuselage.stringerIxx = A_s.*Boom.Y;                        % Finding an array with the different Ixx values
fuselage.stringerIxxtotal = sum(fuselage.heavyframeIxx);   % Total Ixx value for the stringers

for i = 1:length(N)
    fuselage.q_b(i) = (-(Sy / fuselage.stringerIxxtotal) * A_s * Boom.Y(i));
    fuselage.q_0(i) = T / (2 * A_fus);
    fuselage.q(i) = fuselage.q_b(i) + fuselage.q_0(i);
    fuselage.crossectionskinthickness(i) = fuselage.q(i) / SYS;
end
SkinThickness = max(fuselage.crosssectionskinthickness);
end
% 4.Check bay area between stringers  with yield and local plate buckling stress.


%extra: not sure where this goes (AB)
% StringerShape: Z stringers
FrameDepth = convlength(4.0, 'in','m');    % Range is 3.5-4.4
FrameSpacing = convlength(20, 'in','m');

% Materials to use: 2000 series for skin and 7000 series for stringer

% Aassume constant stringer pitch for both tensile side and compression side

% Create structure of outputs
Stringers.spacing = StringerSpacing;
end