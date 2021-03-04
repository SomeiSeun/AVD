% Master code for Fuselage

clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'components', 'rho_landing',...
    'V_landing', 'mainLength', 'wingRootLE','cRootWing','fusDiamOuter','rho_cruise', 'V_Cruise', 'SHoriz', 'SWing')
load('Materials.mat', 'FuselageMaterial')
load('../Preliminary Design Optimiser/trimAnalysis.mat')
load('wingStructures.mat','wing')
D = fusDiamOuter;
numMaterial = 2; % Needs to be 1 or 2

%% Material properties
% Setting anc calculating all the relevant materials properties needed
% Al2024-T6: 363 MPa Tensile Yield Stress
% Al7175-T6: 489.5 MPa Tensile Yield Stress

SYS = [363*10^6, 489.5*10^6];
E = FuselageMaterial(numMaterial).YM;
Poisson = FuselageMaterial(numMaterial).Poisson;
G = FuselageMaterial(numMaterial).SM;
Bulk_Mod = FuselageMaterial(numMaterial).BM;
TensileYieldStress = SYS(numMaterial);
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


%
%% Stringer sizing and shear flow around the fuselage
A_fus = pi * (D / 2)^2;              % Area of the fuselage cross section
Sy = abs(max(LoadCase1.TotalSF1));   % Absolute value of maximum shear force in the fuselage
T = 0;                               % Torque acting on the fuselage 

% [Stringers, Boom, FusProperties] = Fuselage_stringer_shear_flow(LoadCase1.TotalBM1, D, T, SYS, A_fus, Sy);
 [FusStringers, FusBoom, FusProperties, FusShear] = FusStringer_ShearFlow(LoadCase1.TotalBM1, D, T, E, A_fus, Sy);

% Displaying the maximum thickness of the fuselage cross section
% fprintf('The maximum thickness of the fuselage cross section is %f m.\n',max(fuselage.crosssectionthickness))
%^this line displays an error message so commented out
 
% iterate! - NOT DONE!
%now use the skin thickness output and iterate; compare total weight of the two loops


%% Presurisation 
% Ratio of cylindrical fus thickness to hemispherical ends thickness
thickness_ratio = ((2 - Poisson) / (1 - Poisson));    % t_c is cylindrical fus thickness
fprintf('The thickness ratio of cylinder to the spherical cap is %f.\n',thickness_ratio)

% Finding out the thicknesses required to survive pressurisation
P = 58227.3;
fuselage.thickness_h = (P * D / (2 * TensileYieldStress));  % Thickness due to hoop stress
fuselage.thickness_l = (P * D / (4 * TensileYieldStress));  % Thickness due to longitudinal stress
fuselage.thickness_pressurisation = [fuselage.thickness_h fuselage.thickness_l];
fprintf('The extra thickness that needs to be added to the fuselage due to pressurisation is %f m.\n',...
    max(fuselage.thickness_pressurisation))


%% Light frames
L = 0.5;  % Frame spacing is chosen to be 0.5m out of convention
M = max(abs(LoadCase1.TotalBM1));
fuselage = light_frames(E, D, M, L, fuselage);

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
T = 0;                                               % Torque in the fuselage
R = D/2;                                             % Radius of the fuselage
heavy_theta = 55;                                    % Setting the angle between the fuselage and the wing
%Q = (max(wing.lift) - max(wing.selfWeight) - max(wing.ucWeight))*sind(heavy_theta);
%P = (max(wing.lift) - max(wing.selfWeight) - max(wing.ucWeight))*cosd(heavy_theta);
Q = (max(wing.lift)*max(wing.span)/numSections)*sind(heavy_theta);
P = (max(wing.lift)*max(wing.span)/numSections)*cosd(heavy_theta);
[fuselage,theta_deg] = wise_curves(P, R, T, Q, fuselage);

min_area_shear = fuselage.heavyframe_shearforce_max / ShearYieldStress;
min_area_normal = fuselage.heavyframe_normalforce_max / TensileYieldStress;
second_moment_of_area = fuselage.heavyframe_bendingmoment_max / TensileYieldStress;
fprintf('The minimum area required for the heavy frame cross section is %f m^2.\n',max(min_area_shear,min_area_normal))
fprintf('The second moment of area required for the heavy frame cross section is %f m^4.\n',second_moment_of_area)
H = linspace(0.1,0.2,100);
B = linspace(0.1,0.2,100);
[fuselage,solutions] = heavy_frame_Ixx_area_calc(H, B, second_moment_of_area,...
    max(min_area_shear,min_area_normal), fuselage);

%{
heavy_theta = linspace(0,90,90);

max_bendingmoment = zeros(1,length(heavy_theta));
max_normalforce = zeros(1,length(heavy_theta));
max_shearforce = zeros(1,length(heavy_theta));

for i = 1:length(heavy_theta)
    Q = max(wing.lift)*sind(heavy_theta(i));
    P = max(wing.lift)*cosd(heavy_theta(i));
    [fuselage,theta_deg] = wise_curves(P, R, T, Q);
    max_bendingmoment(i) = fuselage.heavyframe_bendingmoment_max;
    max_shearforce(i) = fuselage.heavyframe_shearforce_max;
    max_normalforce(i) = fuselage.heavyframe_normalforce_max;
end

figure
plot(heavy_theta,max_bendingmoment,'xr')
xlabel('Angle (Degrees)')
ylabel('Bending moment (Nm)')
grid minor
str = {'AP'};
text(55,40000,str,'Color','green','FontSize',8)

figure
plot(heavy_theta,max_shearforce,'xr')
hold on
plot(heavy_theta,max_normalforce,'*g')
xlabel('Angle (Degrees)')
ylabel('Force (N)')
grid minor
legend({'Shear force','Normal force'},'Location','South')

figure
plot(heavy_theta,max_shearforce+max_normalforce)
xlabel('Angle (Degrees)')
ylabel('Force (N)')
grid minor
str = {'AP'};
text(55,107000,str,'Color','green','FontSize',8)
%}
    
    
    
%{ 
displays an error so commented out - AB
    
    
% Plotting the Wise curves
figure
plot(theta_deg,fuselage.heavyframe_bendingmoment,'-r')
xlabel('Angle (Degrees)')
ylabel('Bending moment (Nm)')
%title('Bending moment variation around the fuselage ring')
grid minor

figure
plot(theta_deg,fuselage.heavyframe_normalforce,'-r')
hold on
plot(theta_deg,fuselage.heavyframe_shearforce,'-b')
xlabel('Angle (Degrees)')
ylabel('Force (N)')
%title('Shear and normal force variation around the fuselage ring')
legend({'Normal','Shear'},'Location','North')
grid minor
%}