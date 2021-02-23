% Master code for Fuselage

clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'components', 'rho_landing',...
    'V_landing', 'mainLength', 'wingRootLE','cRootWing','fusDiamOuter','rho_cruise', 'V_Cruise', 'SHoriz', 'SWing')
load('Materials.mat', 'FuselageMaterial')
load('../Preliminary Design Optimiser/trimAnalysis.mat')
D = fusDiamOuter;
numMaterial = 1; % Needs to be 1 or 2

%% Material properties
% Setting anc calculating all the relevant materials properties needed

E = FuselageMaterial(numMaterial).YM;
Poisson = FuselageMaterial(numMaterial).Poisson;
G = FuselageMaterial(numMaterial).SM;
Bulk_Mod = FuselageMaterial(numMaterial).BM;
TensileYieldStress = 324;                      % MPa
ShearYieldStress = TensileYieldStress/sqrt(3);

numSections = input('How many points do you want to discretise the fuselage section into? ');

%% BM and SF distributions
% Load case 1 complete (AB)
n1 = 1.5*2.5;
LoadCase1 = fuselage_distributions_LC1(components, n1, numSections, W0,...
    mainLength, wingRootLE, cRootWing, CL_trimHoriz,rho_cruise, V_Cruise, CL_trimWings, etaH, SHoriz, SWing);

% Load case 4- repeat BM and SF distributions
n4 = 1; %landing load factor
LoadCase4 = fuselage_distributions_LC4(components, n4, numSections, W0, mainLength, LoadCase1.weightDistributionIN);

% Plot SF and BM
figure(1) % Shear force 
plot(LoadCase1.sections, LoadCase1.TotalSF1) % Total
xlabel('Distance along fuselage length (m)')
ylabel('Shear Force (N)')
%title('Shear Force Distribution')
hold on
% plot(LoadCase1.sections, LoadCase1.TTSF) %tail trim
% plot(LoadCase1.sections, LoadCase1.InSF) %just inertial
plot(LoadCase4.Sections, LoadCase4.SF4)
legend('Load case 1', 'Load case 4')
grid minor

figure(2) %bending moment
plot(LoadCase1.sections, LoadCase1.TotalBM1)
xlabel('Distance along fuselage length (m)')
ylabel('Bending Moment (Nm)')
%title('Bending Moment Distribution')
hold on
% plot(LoadCase1.sections, LoadCase1.TTBM) %tail trim
% plot(LoadCase1.sections, LoadCase1.InBM) %just inertial
plot(LoadCase4.Sections, LoadCase4.BM4)
legend({'Load case 1', 'Load case 4'},'Location','SouthEast')
grid minor
%{
%% Shear flow around the fuselage
% Sx = 0???
% Ixx = Iyy for the fuselage cross section???
A_fus = pi * (D / 2)^2;  % Area of the fuselage cross section
%Sy = abs(max(fuselage.shearforce_distribution));
% A_s = area of the stringer
% y_s = array of distances of the stringers from neutral axis
% x_s = array of distances of the stringers from neutral axis
% N = number of stringers

fuselage = shear_flow_fuselage(A_s, y_s, Sy, I_xx, A_fus, N, Sx, I_yy, x_s);

%% stringer sizing - in progress(AB)
% Use values from notes as a starting point, as per the videos
StringerSpacing=convlength(7,'in','m');  % Range is 6.5-9 inches

% StringerShape: Z stringers
FrameDepth=convlength(4.0, 'in','m');    % Range is 3.5-4.4
FrameSpacing=convlength(20, 'in','m');

% Materials to use: 2000 series for skin and 7000 series for stringer

% Aassume constant stringer pitch for both tensile side and compression side


%% Presurisation 
% Ratio of cylindrical fus thickness to hemispherical ends thickness
thickness_ratio = ((2 - Poisson) / (1 - Poisson));    % t_c is cylindrical fus thickness
fprintf('The thickness ratio of cylinder to the spherical cap is %f.\n',thickness_ratio)

% Finding out the thicknesses required to survive pressurisation
P = 58227.3;
fuselage.thickness_h = (P * D / (2 * TensileYieldStress));  % Thickness due to hoop stress
fuselage.thickness_l = (P * D / (4 * TensileYieldStress));  % Thickness due to longitudinal stress
fuselage.thickness_pressurisation = [fuselage.thickness_h fuselage.thickness_l];
fprintf('The extra thickness that needs to be added to the fuselage due to pressurisation is %f.\n',...
    max(fuselage.thickness_pressurisation))

%% Bending in fuselage
% Use a datasheet to choose stringer area, as there are too many unknowns
% Use a brute force method, select As and ts and then iterate twice. Three
% variables would be As, ts and pitch b. Choose the configuration that gives
% lowest weight

% We don't have to do the design for every discretised station- simply look
% for worst case and use that to select variables. Then use those same
% variables everywhere

%}
%% Light frames
L = 0.5;  % Frame spacing is chosen to be 0.5m out of convention
M = max(abs(LoadCase1.TotalBM1));
fuselage = light_frames(E, D, M, L);

% Plotting a 3D graph for thickness variation against flange width and web
% height
figure
surf(fuselage.web_height, fuselage.flange_width, fuselage.frame_t)
xlabel('Web height (m)')
ylabel('Flange width (m)')
zlabel('Frame thickness (m)')
%title('Frame thickness surface plot')
colorbar

% Plotting a 3D graph for area variation against web height and flange
% width
figure
surf(fuselage.web_height, fuselage.flange_width, fuselage.frame_area)
xlabel('Web height (m)')
ylabel('Flange width (m)')
zlabel('Frame area (m^2)')
%title('Frame area surface plot')
colorbar

fprintf('The smallest area obtained is %f m^2.\n',min(fuselage.frame_area))

%% Heavy frames
T = 0;     % Looking at the diagrams given in the notes, T should be 0 for us
R = D/2;   % Radius of the fuselage
% Q = 0; ??????
[fuselage,theta_deg] = wise_curves(P, R, T, Q);
% ^ NEED TO PERFORM THIS FUNCTION AT ONLY THE WORST POINT SO AT MAX SHEAR
% FORCE/BENDING MOMENT POINT

% Plotting the Wise curves
figure
plot(theta_deg,fuselage.tangent_m,'-r')
xlabel('Angle (Degrees)')
ylabel('Bending moment (Nm)')
title('Bending moment variation around the fuselage ring')

figure
plot(theta_deg,fuselage.tangent_n,'-r')
hold on
plot(theta_deg,fuselage.tangent_s,'-b')
xlabel('Angle (Degrees)')
ylabel('Force (N)')
title('Shear and normal force variation around the fuselage ring')
legend({'Normal','Shear'},'Location','North')

% Rreaction shear flow around ring equation