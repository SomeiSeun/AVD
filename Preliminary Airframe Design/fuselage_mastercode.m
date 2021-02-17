% Master code for Fuselage

clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'components', 'rho_landing', 'V_landing', 'mainLength', 'fusDiamOuter')
%load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial')
%^ Using same materials for fuselage as the wings?

D = fusDiamOuter;

%% Anudi -- this is not the proper code, simply a breakdown of the procedure. Code in progress
% Materials (sheet 1 of spreadsheet)

% Fuselage materials not selected yet so using temporary values for now (values in sample spreadsheet)
E = 73000;                   % N/mm^2
Poisson = 0.33;
G = E/2/(1+Poisson);
Bulk_Mod = E/3/(1-2*Poisson);
TensileYieldStress = 324;    % MPa
ShearYieldStress = TensileYieldStress/sqrt(3);


%% fuselage inertial load distributions (sheet 2 of spreadsheet)
%discretize fuselage - already done in fuselage.length from concep design
numSections = 100;
Nz = 1.5*2.5; % load case
%load case 1
%allocate weights of each component to discretized points along span of fuselage

%% Fuselage inertial load distributions (sheet 2 of spreadsheet)
% Discretize fuselage - already done in fuselage.length from concep design
numSections = 12;  % MIGHT BE BETTER TO HAVE MORE DISCRETISATIONS? 12 SEEMS TOO LITTLE (US)
Nz = 1.5*2.5;      % Load case

% Allocate weights of each component to discretized points along span of fuselage


% Use force and moment eqm to get RS and FS reactions

% Plot inertial load distributions

% Plot shear force distribution - must be 0 at the end (Stringers needs to
% be done before this step)
fuselage = shear_flow_fuselage(A_s, y_s, Sy, I_xx, A_fus, r, b, N);

% Plot BM distribution
fuselage = fuselage_distributions(components, Nz, numSections, W0, mainLength);


%% landing load case 

%use values from notes as a starting point, as per the videos
StringerSpacing=convlength(7,'in','m'); %range is 6.5-9 inches
%StringerShape: Z stringers
FrameDepth=convlength(4.0, 'in','m'); %range is 3.5-4.4



%% Landing load case 

% Use values from notes as a starting point, as per the videos
StringerSpacing=convlength(7,'in','m');  % Range is 6.5-9 inches

% StringerShape: Z stringers
FrameDepth=convlength(4.0, 'in','m');    % Range is 3.5-4.4
FrameSpacing=convlength(20, 'in','m');

% Materials to use: 2000 series for skin and 7000 series for stringer

% Aassume constant stringer pitch for both tensile side and compression side


%% Presurisation 
% Ratio of cylindrical fus thickness to hemispherical ends thickness
t_c = ((2 - poisson) / (1 - poisson)) * t_s;    % t_c is cylindrical fus thickness

% Finding out the thicknesses required to survive pressurisation
% P is pressure 
% d is fuselage diameter
fuselage.thickness_h = (P * D / (2 * TensileYieldStress));  % Thickness due to hoop stress
fuselage.thickness_l = (P * D / (4 * TensileYieldStress));  % Thickness due to longitudinal stress
% ^ The thickness value which is larger is chosen and added to the skin
% thickness 

%% Bending in fuselage
% Use a datasheet to choose stringer area, as there are too many unknowns
% Use a brute force method, select As and ts and then iterate twice. Three
% variables would be As, ts and pitch b. Choose the configuration that gives
% lowest weight.

% We don't have to do the design for every discretised station- simply look
% for worst case and use that to select variables. Then use those same
% variables everywhere


%% Light frames
fuselage = light_frames(E, D, M, L);

% Plotting a 3D graph for thickness variation against flange width and web
% height
figure
surf(fuselage.web_height, fuselage.flange_width, fuselage.frame_t)
xlabel('Web height (m)')
ylabel('Flange width (m)')
zlabel('Frame thickness (m)')
title('Frame thickness surface plot')
colorbar

% Plotting a 3D graph for area variation against web height and flange
% width
figure
surf(fuselage.web_height, fuselage.flange_width, fuselage.frame_area)
xlabel('Web height (m)')
ylabel('Flange width (m)')
zlabel('Frame area (m^2)')
title('Frame area surface plot')
colorbar

%% Heavy frames
[fuselage,theta_deg] = wise_curves(P, R, T, Q);

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