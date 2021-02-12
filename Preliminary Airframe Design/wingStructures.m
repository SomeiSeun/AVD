clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'spanWing', 'cRootWing', 'taperWing', 'Thrustline_position',...
    'rho_cruise', 'V_Cruise')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial')
load('skinStringerpanel.mat')

% Defining Parameters
numSections = 1e3;
Nz = 1.5*2.5; % ultimate load factor
fuelInTank = 0; % value between 0 and 1
numMaterial = 1; % from Materials.mat, must be integer between 1 and 4

% Evaluating dift and deight distributions
wing = bendingWing(Nz, fuelInTank, numSections, W0, components, spanWing, cRootWing, taperWing, Thrustline_position);

% Defining wing structural parameters
frontSparLocation = 0.25;
rearSparLocation = 0.7;
flexuralAxis = 0.5*(frontSparLocation + rearSparLocation);

% Evaluating basic wing box parameters
[wing, frontSpar, rearSpar] = analyseWingBox('NACA 64215.txt', wing, frontSparLocation, rearSparLocation);

K_s = 8.1;
Cm0 = -0.2;
cg = 0.4;

% Evaluating shear stresses and spar web thicknesses
[wing,frontSpar,rearSpar] = shear_flow(wing, frontSpar, rearSpar, K_s, rho_cruise, V_Cruise, SparMaterial(numMaterial).YM, frontSparLocation, rearSparLocation, flexuralAxis, Cm0, cg);

% Evaluating spar flange dimensions
[frontSpar] = sparSizing(wing, SparMaterial(numMaterial), frontSpar);
[rearSpar] = sparSizing(wing, SparMaterial(numMaterial), rearSpar);


% [c_alongSpan,N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections, wing.chord,wing.bendingMoment,UpperSkinMaterial(numMaterial));
% 
%  % Skin Stringer Panel Sizing 
% [Optimum]=SSPOptimum(c_alongSpan,N_alongSpan,b2);

% Plotting Results

% Plotting Loading Distribution
fig1 = figure(1);
hold on
plot(wing.span, wing.lift, '.')
plot(wing.span, -wing.selfWeight, '.')
plot(wing.span, -wing.engineWeight, '.')
plot(wing.span, -wing.ucWeight, '.')
plot(wing.span, -wing.fuseWeight, '.')
plot(wing.span, -wing.fuelWeight, '.')
plot(wing.span, wing.loading, 'k-')
legend('Lift', 'Self-weight', 'Engine Weight', 'Undercarriage Weight', 'Aircraft Weight',...
    'Fuel Weight', 'Overall Loading Distribution', 'Location', ' Southeast')
ylabel('Loading Distribution (N/m)')
xlabel('Wing Spanwise Coordinate y (m)')
title('Wing Vertical Loading Distribution')
grid minor
fig1.Units = 'normalized';
fig1.Position = [0 0.5 0.25 0.4];

% Plotting Shear Force
fig2 = figure(2);
hold on
plot(wing.span, wing.shearForce)
ylabel('Shear Force (N)')
xlabel('Wing Spanwise Coordinate y (m)')
title('Wing Vertical Shear Force Distribution')
grid minor
fig2.Units = 'normalized';
fig2.Position = [0.25 0.5 0.25 0.4];

% Plotting Bending Moment
fig3 = figure(3);
hold on
plot(wing.span, wing.bendingMoment)
ylabel('Bending Moment (Nm)')
xlabel('Wing Spanwise Coordinate y (m)')
title('Wing Bending Moment Distribution')
grid minor
fig3.Units = 'normalized';
fig3.Position = [0.5 0.5 0.25 0.4];

% Plotting the torque distribution
fig4 = figure(4);
plot(wing.span, wing.torque)
xlabel('Wing Spanwise Coordinate y (m)')
ylabel('Torque Distribution (N)')
title('Wing Torque Distribution')
grid minor
fig4.Units = 'normalized';
fig4.Position = [0.75 0.5 0.25 0.4];

% Plotting wingbox area variation
% figure
% plot(wing.span,wing.boxArea,'.b')
% grid on
% xlabel('Wing Span (m)')
% ylabel('Wingbox Area (m^2)')
% title('Wingbox Area Distribution')

% Plotting the thickness variations
fig5 = figure(5);
hold on
plot(wing.span,1000*frontSpar.tw,'r')
plot(wing.span,1000*rearSpar.tw,'b')
xlabel('Wing span (m)')
ylabel('Thickness (mm)')
legend({'Front spar','Rear spar'},'Location','Northeast')
title('Spar Web Thickness Distribution')
grid minor
fig5.Units = 'normalized';
fig5.Position = [0 0.05 0.25 0.4];

% Plotting the front and rear spar shear flow
% figure
% plot(wing.span,frontSpar.qweb,'.r')
% hold on
% plot(wing.span,rearSpar.qweb,'.b')
% grid on
% xlabel('Wing span (m)')
% ylabel('Shear flow (N/m)')
% legend({'Front spar','Rear spar'},'Location','Northeast')
% title('Sparhear flow spanwise distribution')

% Plotting front and rear spar shear stress
fig6 = figure(6);
plot(wing.span,frontSpar.shearstress,'r')
hold on
plot(wing.span,rearSpar.shearstress,'b')
xlabel('Wing span (m)')
ylabel('Shear stress (N/m^2)')
legend({'Front Spar','Rear Spar'},'Location','Northeast')
title('Spar Web Shear Stress Distribution')
grid minor
fig6.Units = 'normalized';
fig6.Position = [0.25 0.05 0.25 0.4];

% Plotting front and Rear Spar flange dimensions
fig7 = figure(7);
hold on
yyaxis left
plot(wing.span, 1000*frontSpar.b, '-r')
plot(wing.span, 1000*rearSpar.b, '-b')
xlabel('Wing Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)', 'Color', 'k')
yyaxis right
plot(wing.span, 1000*frontSpar.tf, '--r')
plot(wing.span, 1000*rearSpar.tf, '--b')
ylabel('Spar Flange Thickness t_f (mm)', 'Color', 'k')
legend('Front Spar Flange Breadth', 'Rear Spar Flange Breadth', 'Front Spar Flange Thickness', 'Rear Spar Flange Thickness')
title('Wing Spar Flange Thickness and Breadth')
grid minor
fig7.Units = 'normalized';
fig7.Position = [0.5 0.05 0.25 0.4];

% Plotting spar areas and Ixx values
fig8 = figure(8);
hold on
yyaxis left
plot(wing.span, frontSpar.Area, '-r')
plot(wing.span, rearSpar.Area, '-b')
xlabel('Wing Spanwise Coordinate y (m)')
ylabel('Spar Cross-Sectional Area (m^2)', 'Color', 'k')
yyaxis right
plot(wing.span, frontSpar.Ixx, '--r')
plot(wing.span, rearSpar.Ixx, '--b')
ylabel('Second Moment of Area I_x_x (m^4)', 'Color', 'k')
legend('Front Spar Area', 'Rear Spar Area', 'Front Spar Ixx', 'Rear Spar Ixx')
grid minor
fig8.Units = 'normalized';
fig8.Position = [0.75 0.05 0.25 0.4];

figure
hold on
plot(wing.span, rearSpar.Ixx)
plot(wing.span, rearSpar.IxxMax)
legend('Ixx', 'Ixx Max')


%% Skin thickness sizing (ch3)
[N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections, wing,UpperSkinMaterial(numMaterial));

%% Skin Stringer Panel Sizing and Optimization
[Optimum]=SSPOptimum(wing.boxLength,N_alongSpan,b2);
[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,wing.boxLength,Optimum);
