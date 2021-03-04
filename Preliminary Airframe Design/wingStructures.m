clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'spanWing', 'cRootWing', 'taperWing', 'Thrustline_position',...
    'rho_cruise', 'V_Cruise','beta_Cruise','Engine_SeaLevelThrust')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial','LowerSkinMaterial')
load('skinStringerpanel.mat')
load('wingStructures.mat', 'optRibParameters')

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
bMin = 0.003;
[frontSpar] = sparSizing(wing, SparMaterial(numMaterial), frontSpar, bMin, optRibParameters.ribPositions(1:2:end));
[rearSpar] = sparSizing(wing, SparMaterial(numMaterial), rearSpar, bMin, optRibParameters.ribPositions(1:2:end));

% [c_alongSpan,N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections, wing.chord,wing.bendingMoment,UpperSkinMaterial(numMaterial));
% 
%  % Skin Stringer Panel Sizing 5
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
ylabel('Torque Distribution (Nm)')
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

% Plotting front Spar flange breadth
figure
hold on
plot(wing.span, 1000*frontSpar.b, '-r')
plot(wing.span, 1000*frontSpar.bReq, '-b')
xlabel('Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)', 'Color', 'k')
legend('Actual Flange Breadth', 'Required Flange Breadth')
title('Wing Front Spar Flange Breadth')
grid minor


% Plotting front Spar flange thickness
figure
hold on
plot(wing.span, 1000*frontSpar.tf, '-r')
plot(wing.span, 1000*frontSpar.tfReq, '-b')
xlabel('Spanwise Coordinate y (m)')
ylabel('Spar Flange Thickness t_f (mm)', 'Color', 'k')
legend('Actual Flange Thickness', 'Required Flange Thickness')
title('Wing Front Spar Flange Thickness')
grid minor

% Plotting spar Ixx values
figure
hold on
plot(wing.span, frontSpar.Ixx, '-b')
plot(wing.span, frontSpar.IxxReq, '--b')
ylabel('Second Moment of Area I_x_x (m^4)')
xlabel('Wing Spanwise Coordinate y (m)')
legend('Actual I_x_x', 'Required I_x_x')
title('Wing Front Spar I_x_x Distribution');
grid minor

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

[LWSSOptimum,LESkin,lowerstringerGeometry,LowerstringerIndex]=SSPOptimum(wing,N_alongSpan,LowerSkinMaterial(numMaterial));
[LnoStringersDist,LskinThicknessDist,lowerStringerThicknessDist]=skinStringerDistribution(N_alongSpan,wing.boxLength,LWSSOptimum);



%% Rib Spacing and Rib Thickness Optimisation
[rSpacing,optRibSpacing,massWingBox,massEffRib,massEffSS,ribThickness,minMassIndex]=ribSpacing(wing,WSSOptimum,boxHeight,skinThicknessDist,N_alongSpan,noStringersDist,LskinThicknessDist,LnoStringersDist,LWSSOptimum);
[optRibParameters]=RibThickness(optRibSpacing,wing,minMassIndex,ribThickness);

for i=1:length(wing.span)
    skinStep(i)=wing.span(1)-wing.span(i);
end 
[val,idx]=min(abs(skinStep-optRibSpacing));
minVal=skinStep(idx);

figure
x=[wing.span(end-idx:-2*idx:1)];
y=[skinThicknessDist(end-idx:-2*idx:1)*1000];
plot(wing.span,skinThicknessDist*1000,'r')
hold on
stairs(x,y,'b')
xlabel('Distance along wing (m)') 
ylabel('Skin Thickness (mm)')
legend('Optimum','Altered for Manufacturing')
% title('Skin Thickness Distribution')
grid minor


% Plotting Mass Vs Rib Spacing
figure 
plot(rSpacing,massWingBox,'-b')
hold on 
plot(rSpacing,massEffRib,'-r')
plot(rSpacing,massEffSS)
xlabel('Rib Spacing (m)')
ylabel('Volume')
legend('Total','Ribs','Skin-Stringer')
% title('Rib Spacing Optimisation')
grid minor 
hold off

% Plot Rib Thickness at each station 

figure 
plot(optRibParameters.ribPositions,optRibParameters.ribThickness*1000,'bx','Linewidth',1.3)
xlabel('Position along span (m)')
ylabel('Rib Thickness (mm)')
% title('Rib Thickness Distribution')
grid minor




figure
surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tSkin,stringerGeometry.aEffective)
xlabel('As/bt')
ylabel('Ts/t')
zlabel('Skin Thickness (m)') 
% title('Skin Thickness for different Skin-Stringer Ratios')
colormap('turbo')
s=colorbar();
s.Label.String ='Total Area (m^2)';


figure
surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tStringer,stringerGeometry.aEffective)
xlabel('As/bt')
ylabel('Ts/t')
zlabel('Stringer Thickness (m)') 
% title('Stringer Thickness for different Skin-Stringer Ratios')
colormap('turbo')
s=colorbar();
s.Label.String ='Total Area (m^2)';

% Saving the workspace for other programmes
save('wingStructures.mat')