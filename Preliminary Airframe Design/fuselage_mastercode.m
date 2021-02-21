% Master code for Fuselage

clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'components', 'rho_landing',...
    'V_landing', 'mainLength', 'wingRootLE','cRootWing','fusDiamOuter')
load('Materials.mat', 'FuselageMaterial')
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

numSections=1000;

%% BM and SF distribution- load case 1 complete (AB)
%load case 1 
% [fuselageSF, fuselageBM] = fuselage_distributions(components, Nz, numSections, W0, mainLength);
n1=1.5*2.5;
LoadCase1 = fuselage_distributions(components, n1, numSections, W0, mainLength, wingRootLE, cRootWing);

%plot
figure(1)
plot(LoadCase1.sections, LoadCase1.SF)
xlabel('Distance along fuselage length (m)')
ylabel('Shear Force (N)')
title('Shear Force Distribution')

%plot BM distribution
figure(2)
plot(LoadCase1.sections, LoadCase1.BM)
xlabel('Distance along fuselage length (m)')
ylabel('Bending Moment (Nm)')
title('Bending Moment Distribution')


% EVERYTHING BELOW THIS IS STILL IN PROGRESS- WILL CONVERT INTO FUNCTIONS WHEN DONE (AB)
%% tail trim load superimposition
%calculate tail trim load - it must balance the 2.5g pitching moment of the
%wing
TT_Load=(2.5*9.81*(sum(Reactions))*x_cg(1))/x_cg(2);

%now superimpose tail load case onto weightdistributions
WtDisTT=zeros(1,numSections); %zero inertial load assumed here

%calculate new reactions at spars for this tail load case
C_TT=[ sum(WtDisTT); TT_Load*x_cg(2)]; 
Reactions_TT=A\C_TT;

%aero loads, acting upwards
[~,I4] = min(abs(fusSections_x -x_cg(2)));
WtDisTT(I4)=-TT_Load; WtDisTT(I1)=-Reactions_TT(1); WtDisTT(I3)=-Reactions_TT(2);

SF_TT=zeros(1,numSections);
for i=2:numSections
    SF_TT(i)=SF_TT(i-1)+WtDisTT(i);
end

SF_TT=-SF_TT;
dBM_TT=zeros(1,numSections);BM_TT=zeros(1,numSections);
for i=2:numSections
    dBM_TT(i)=SF_TT(i-1)*(fusSections_x(i)-fusSections_x(i-1))+(SF_TT(i)+SF_TT(i-1))*...
        (fusSections_x(i)-fusSections_x(i-1))/2;
    BM_TT(i)=BM_TT(i-1)+dBM_TT(i);
end

%symm flight+ TT load
SF_Total_LC1=SF+SF_TT;
BM_Total_LC1=BM+BM_TT;

% plot shear force distribution - must be 0 at the end
figure(1)
plot(fusSections_x, SF) %just symm flight
xlabel('Distance along fuselage length (m)')
ylabel('Shear Force (N)')
title('Shear Force Distribution')
hold on
plot(fusSections_x, SF_TT) %just tail load
plot(fusSections_x, SF_Total_LC1) %symm+tail load

%plot BM distribution
figure(2)
plot(fusSections_x, BM)
xlabel('Distance along fuselage length (m)')
ylabel('Bending Moment (Nm)')
title('Bending Moment Distribution')
hold on
plot(fusSections_x, BM_TT)
plot(fusSections_x, BM_Total_LC1)


%% landing load case - repeat BM and SF distributions
gear_cg=x_cg(5);
weightDistributions3=weightDistributions; %inertial load distribution is the same

%WHAT NEEDS TO BE DONE- FIND GEAR LOAD AND TAIL LOAD DISTRIBUTION IN THE
%WEIGHTS ARRAY

%calculate gear load reactions
C3=[ ; ];
Reactions3=A\C3; %reactions are now at gear and tail (NOT FS AND RS!!!!)

[~,I5] = min(abs(fusSections_x -x_cg(5)));
% weightSum3(I4)=-Reactions3(??); %TAIL LOAD
% weightSum3(I5)=-Reactions3(??); %GEAR LOAD

SF3=zeros(1,numSections);
for i=2:numSections
    SF3(i)=SF3(i-1)+weightSum3(i);
end
SF3=-SF3;
dBM3=zeros(1,numSections);BM3=zeros(1,numSections);
for i=2:numSections
    dBM3(i)=SF3(i-1)*(fusSections_x(i)-fusSections_x(i-1))+(SF3(i)+SF3(i-1))*(fusSections_x(i)-fusSections_x(i-1))/2;
    BM3(i)=BM3(i-1)+dBM3(i);
end

%plot
figure(1)
% plot(fusSections_x, SF3)
legend('Load case 1','with TT', 'Load case 3')
figure(2)
% plot(fusSections_x, BM3)
legend('Load case 1','just tail load''symm+ TT', 'Load case 3')
%load case 3
% n3=?
% LoadCase3 = fuselage_distributions(components, n3, numSections, W0, mainLength, wingRootLE, cRootWing)

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


%% Light frames
L = 0.5;  % Frame spacing is chosen to be 0.5m out of convention
% M = max(fuselage.bendingmoments);
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