clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'heightVert', 'cRootVert', 'taperVert', 'Thrustline_position',...
    'SVert', 'rho_takeoff', 'V_takeoff', 'CG_all', 'vertAC', 'beta_Cruise', 'Engine_SeaLevelThrust')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial')

% Loading in a different coordinates txt file to plot the aerofoil
load('NACA 0012 plotting purposes.txt')
x = NACA_0012_plotting_purposes(:,1);
y = NACA_0012_plotting_purposes(:,2);

% Defining Parameters
numSections = input('How many sections do you want to discretise the vertical tailplane into? ');
Nz = 1;             % Limit load factor
numMaterial = 1;    % From Materials.mat, must be integer between 1 and 4

% Evaluating lift and weight distributions
liftReq = Engine_SeaLevelThrust*Thrustline_position(2)/(vertAC(1) - CG_all(1,1));
vertTail =  bendingVertTail(Nz, numSections, liftReq, components, 2*heightVert, cRootVert, taperVert, 0);
vertTail.engineWeight = zeros(1,numSections);
vertTail.ucWeight = zeros(1,numSections);
vertTail.fuseWeight = zeros(1,numSections);
vertTail.fuelWeight = zeros(1,numSections);

% Defining vertical tail box structural parameters
tcRatio = 0.1;
[vertTail, frontSpar, rearSpar] = analyseWingBox('NACA 0012.txt', vertTail, tcRatio);

K_s = 8.1;
Cm0 = 0;
cg = 0.41;

% Evaluating shear stresses and spar web thicknesses
flexuralAxis = 0.5*(frontSpar.coords(1,1) + rearSpar.coords(1,1));
[vertTail,frontSpar,rearSpar] = shear_flow(vertTail, frontSpar, rearSpar, K_s, rho_takeoff, V_takeoff,...
    SparMaterial(numMaterial).YM, flexuralAxis, Cm0, cg, Thrustline_position(3));

% Evaluating spar flange dimensions
IxxCutoff = 0.001;
[frontSpar] = sparSizing(vertTail, SparMaterial(numMaterial), frontSpar, IxxCutoff);
[rearSpar] = sparSizing(vertTail, SparMaterial(numMaterial), rearSpar, IxxCutoff);

%% Plotting Results
% Plotting Loading Distribution
fig1 = figure(1);
hold on

plot(vertTail.span, vertTail.loading, 'k-')
legend('Overall Loading Distribution', 'Location', ' Southeast')
ylabel('Loading Distribution (N/m)')
xlabel('Vert Tail Spanwise Coordinate y (m)')
title('Vert Tail Vertical Loading Distribution')
grid minor
fig1.Units = 'normalized';
fig1.Position = [0 0.5 0.25 0.4];

% Plotting Shear Force
fig2 = figure(2);
hold on
plot(vertTail.span, vertTail.shearForce)
ylabel('Shear Force (N)')
xlabel('Vert Tail Spanwise Coordinate y (m)')
title('Vert Tail Vertical Shear Force Distribution')
grid minor
fig2.Units = 'normalized';
fig2.Position = [0.25 0.5 0.25 0.4];

% Plotting Bending Moment
fig3 = figure(3);
hold on
plot(vertTail.span, vertTail.bendingMoment)
ylabel('Bending Moment (Nm)')
xlabel('Vert Tail Spanwise Coordinate y (m)')
title('Vert Tail Bending Moment Distribution')
grid minor
fig3.Units = 'normalized';
fig3.Position = [0.5 0.5 0.25 0.4];

% Plotting the torque distribution
fig4 = figure(4);
plot(vertTail.span, vertTail.torque)
xlabel('Vert Tail Spanwise Coordinate y (m)')
ylabel('Torque Distribution (N)')
title('Vert Tail Torque Distribution')
grid minor
fig4.Units = 'normalized';
fig4.Position = [0.75 0.5 0.25 0.4];

% Plotting the thickness variations
fig5 = figure(5);
hold on
plot(vertTail.span,1000*frontSpar.tw,'r')
plot(vertTail.span,1000*rearSpar.tw,'b')
xlabel('Vert Tail span (m)')
ylabel('Thickness (mm)')
legend({'Front spar','Rear spar'},'Location','Northeast')
title('Spar Web Thickness Distribution')
grid minor
fig5.Units = 'normalized';
fig5.Position = [0 0.05 0.25 0.4];

% Plotting front and rear spar shear stress
fig6 = figure(6);
plot(vertTail.span,frontSpar.shearstress,'r')
hold on
plot(vertTail.span,rearSpar.shearstress,'b')
xlabel('Vert Tail span (m)')
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
plot(vertTail.span, 1000*frontSpar.b, '-r')
plot(vertTail.span, 1000*rearSpar.b, '-b')
xlabel('Vert Tail Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)', 'Color', 'k')
yyaxis right
plot(vertTail.span, 1000*frontSpar.tf, '--r')
plot(vertTail.span, 1000*rearSpar.tf, '--b')
ylabel('Spar Flange Thickness t_f (mm)', 'Color', 'k')
legend('Front Spar Flange Breadth', 'Rear Spar Flange Breadth', 'Front Spar Flange Thickness', 'Rear Spar Flange Thickness')
title('Vert Tail Spar Flange Thickness and Breadth')
grid minor
fig7.Units = 'normalized';
fig7.Position = [0.5 0.05 0.25 0.4];

% Plotting spar areas and Ixx values
fig8 = figure(8);
hold on
yyaxis left
plot(vertTail.span, frontSpar.Area, '-r')
plot(vertTail.span, rearSpar.Area, '-b')
xlabel('Vert Tail Spanwise Coordinate y (m)')
ylabel('Spar Cross-Sectional Area (m^2)', 'Color', 'k')
yyaxis right
plot(vertTail.span, frontSpar.Ixx, '--r')
plot(vertTail.span, rearSpar.Ixx, '--b')
ylabel('Second Moment of Area I_x_x (m^4)', 'Color', 'k')
legend('Front Spar Area', 'Rear Spar Area', 'Front Spar Ixx', 'Rear Spar Ixx')
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
plot(0.25,0,'xc','MarkerSize',10,'LineWidth',1.5)
plot(frontSpar.coords(1,:),frontSpar.coords(2,:),'LineWidth',1.5)
plot(rearSpar.coords(1,:),rearSpar.coords(2,:),'LineWidth',1.5)
legend({'NACA 0012','Centre of gravity','Flexural Axis','Aerodynamic Centre', 'Front Spar', 'Rear Spar'},'Location','Northeast')
grid minor

%% Skin thickness sizing (ch3)
[N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections,vertTail,UpperSkinMaterial(numMaterial));

%% Skin Stringer Panel Sizing and Optimization
[Optimum]=SSPOptimum(vertTail,N_alongSpan);
[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,vertTail.boxLength,Optimum);