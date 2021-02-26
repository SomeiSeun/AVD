clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'spanWing', 'cRootWing', 'taperWing', 'Thrustline_position',...
    'rho_cruise', 'V_Cruise','beta_Cruise','Engine_SeaLevelThrust')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial')
load('skinStringerpanel.mat')

% Loading in a different coordinates txt file to plot the aerofoil
load('NACA 64215 plotting purposes.txt')
x = NACA_64215_plotting_purposes(:,1);
y = NACA_64215_plotting_purposes(:,2);

%% Defining Parameters
numSections = input('How many points do you want to discretise the wing into? ');
Nz = 1.5*2.5;    % Ultimate load factor
fuelInTank = 0;  % Value between 0 and 1
numMaterial = 1; % From Materials.mat, must be integer between 1 and 4

% Evaluating dift and deight distributions
wing = bendingWing(Nz, fuelInTank, numSections, W0, components, spanWing, cRootWing, taperWing, Thrustline_position);

% Adding Engine thrust values
wing.Thrust = zeros(1, numSections);
wing.Thrust(wing.engineWeight ~= 0) = beta_Cruise * Engine_SeaLevelThrust;

% Evaluating basic wing box parameters
tcRatio = 0.1;
[wing, frontSpar, rearSpar] = analyseWingBox('NACA 64215.txt', wing, tcRatio);

K_s = 8.1;
Cm0 = -0.2;
cg = 0.4;

% Evaluating shear stresses and spar web thicknesses
flexuralAxis = 0.5*(frontSpar.coords(1,1) + rearSpar.coords(1,1));
[wing,frontSpar,rearSpar] = shear_flow(wing, frontSpar, rearSpar, K_s, rho_cruise, V_Cruise,...
    SparMaterial(numMaterial).YM, flexuralAxis, Cm0, cg, Thrustline_position(3));

% Evaluating spar flange dimensions
IxxCutoff = 0.126;
[frontSpar] = sparSizing(wing, SparMaterial(numMaterial), frontSpar, IxxCutoff);
[rearSpar] = sparSizing(wing, SparMaterial(numMaterial), rearSpar, IxxCutoff);

% [c_alongSpan,N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections, wing.chord,wing.bendingMoment,UpperSkinMaterial(numMaterial));
% 
%  % Skin Stringer Panel Sizing 
% [Optimum]=SSPOptimum(c_alongSpan,N_alongSpan,b2);

%% Plotting Results

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

% Plotting front Spar flange dimensions
fig7 = figure(7);
hold on
yyaxis left
plot(wing.span, 1000*frontSpar.b, '-b')
xlabel('Wing Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)')
yyaxis right
plot(wing.span, 1000*frontSpar.tf, '--r')
ylabel('Spar Flange Thickness t_f (mm)')
legend('Spar Flange Breadth','Spar Flange Thickness')
title('Wing Front Spar Flange Thickness and Breadth')
grid minor
fig7.Units = 'normalized';
fig7.Position = [0.5 0.05 0.25 0.4];

% Plotting spar areas and Ixx values
fig8 = figure(8);
hold on
yyaxis left
plot(wing.span, frontSpar.Area, '-b')
xlabel('Wing Spanwise Coordinate y (m)')
ylabel('Spar Cross-Sectional Area (m^2)')
yyaxis right
plot(wing.span, frontSpar.Ixx, '--r')
ylabel('Second Moment of Area I_x_x (m^4)')
legend('Spar Area', 'Spar Ixx')
title('Wing Front Spar Ixx and Area');
grid minor
fig8.Units = 'normalized';
fig8.Position = [0.75 0.05 0.25 0.4];

% Plotting the aerofoil with points of interest
figure
plot(x,y,'k','LineWidth',1.5)
hold on
axis equal
xlabel('x/c')
ylabel('y/c')
plot(cg,0,'xb','MarkerSize',10,'LineWidth',1.5)
plot(flexuralAxis,0,'xm','MarkerSize',10,'LineWidth',1.5)
plot(frontSpar.coords(1,:),frontSpar.coords(2,:),'LineWidth',1.5)
plot(rearSpar.coords(1,:),rearSpar.coords(2,:),'LineWidth',1.5)
plot(0.25,0,'x','MarkerSize',10,'LineWidth',1.5)
legend({'NACA 64215','Centre of gravity','Flexural Axis','Front Spar', 'Rear Spar', 'Aerodynamic Centre'},'Location','Northeast')
grid minor

%% Skin thickness sizing (ch3)
[N_alongSpan,t2_alongSpan,sigma,boxHeight] = skinStringerFunction(numSections, wing,UpperSkinMaterial(numMaterial));

%% Skin Stringer Panel Sizing and Optimization
[WSSOptimum,ESkin,stringerGeometry,stringerIndex]=SSPOptimum(wing,N_alongSpan,UpperSkinMaterial);
[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,wing.boxLength,WSSOptimum);

% Plotting skin thickness distribution along span 
figure
x=[wing.span(end:-50:1)];
y=[skinThicknessDist(end:-50:1)*1000];
plot(wing.span(end:-50:1),skinThicknessDist(end:-50:1)*1000,'.-r')
hold on
stairs(x,y,'b')
xlabel('Distance along wing (m)') 
ylabel('Skin Thickness (mm)')
title('Skin Thickness Distribution')
grid minor


%% Rib Spacing and Rib Thickness Optimisation
[rSpacing,optRibSpacing,massWingBox,massEffRib,massEffSS,ribThickness,minMassIndex]=ribSpacing(wing,WSSOptimum,boxHeight,skinThicknessDist,N_alongSpan);
[optRibParameters]=RibThickness(optRibSpacing,wing,minMassIndex,ribThickness);

% % Plotting Mass Vs Rib Spacing
% figure 
% plot(rSpacing,massWingBox,'-b')
% hold on 
% plot(rSpacing,massEffRib,'-r')
% plot(rSpacing,massEffSS)
% xlabel('Rib Spacing (m)')
% ylabel('Mass')
% legend('Total','Ribs','Skin-Stringer')
% title('Rib Spacing Optimisation')
% grid minor 
% hold off


figure
surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tSkin,stringerGeometry.aEffective)
xlabel('As/bt')
ylabel('Ts/t')
zlabel('Skin Thickness (m)') 
title('Skin Thickness for different Skin-Stringer Ratios')
colormap('turbo')
s=colorbar();
s.Label.String ='Total Area (m^2)';


figure
surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tStringer,stringerGeometry.aEffective)
xlabel('As/bt')
ylabel('Ts/t')
zlabel('Stringer Thickness (m)') 
title('Stringer Thickness for different Skin-Stringer Ratios')
colormap('turbo')
s=colorbar();
s.Label.String ='Total Area (m^2)';

