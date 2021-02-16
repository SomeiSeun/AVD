% Master code for Fuselage

clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'rho_cruise', 'V_Cruise', 'mainLength')
%load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial')
%^ Using same materials for fuselage as the wings?

%% Anudi -- this is not the proper code, simply a breakdown of the procedure. Code in progress
%materials (sheet 1 of spreadsheet)

%fuselage materials not selected yet so using temporary values for now (values in sample spreadsheet)
E = 73000;      % N/mm^2
Poisson = 0.33;
G = E/2/(1+Poisson);
Bulk_Mod = E/3/(1-2*Poisson);
TensileYieldStress = 324;   % MPa
ShearYieldStress = TensileYieldStress/sqrt(3);

%% fuselage inertial load distributions (sheet 2 of spreadsheet)
%discretize fuselage - already done in fuselage.length from concep design
numSections = 12;
Nz = 1.5*2.5; % load case

%allocate weights of each component to discretized points along span of fuselage

%use force and moment eqm to get RS and FS reactions

%plot inertial load distributions

%plot shear force distribution - must be 0 at the end (Stringers needs to
%be done before this step)
fuselage = shear_flow_fuselage(A_s, y_s, Sy, I_xx, A_fus, r, b, N);

%plot BM distribution
fuselage = fuselage_distributions(components, Nz, numSections, W0, mainLength);

%% fuselage tail load distribution




%% landing load case 

%use values from notes as a starting point, as per the videos
StringerSpacing=convlength(7,'in','m'); %range is 6.5-9 inches
%StringerShape: Z stringers
FrameDepth=convlength(4.0, 'in','m'); %range is 3.5-4.4
FrameSpacing=convlength(20, 'in','m');
%materials to use: 2000 series for skin and 7000 series for stringer

%assume constant stringer pitch for both tensile side and compression side


%% presurisation 
% ratio of cylindrical fus thickness to hemispherical ends thickness
t_c = ((2 - poisson) / (1 - poisson)) * t_s; % t_c is cylindrical fus thickness

%% bending in fuselage
%use a datasheet to choose stringer area, as there are too many unknowns
%use a brute force method, select As and ts and then iterate twice. Three
%variables would be As, ts and pitch b. Choose the configuration that gives
%lowest weight.

% we don't have to do the design for every discretised station- simply look
% for worst case and use that to select variables. then use those same
% variables everywhere


%% light frames
%(EI)_f=(C_f*M*D^2)/L; for that particular station


%% heavy frames
%equations to code up: WISE curve equations
fuselage = wise_curves(P, R, T, Q)
%reaction shear flow around ring equation