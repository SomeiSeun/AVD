clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'heightVert', 'cRootVert', 'taperVert', 'Thrustline_position',...
    'SVert', 'rho_takeoff', 'V_takeoff', 'CG_all', 'vertAC', 'beta_Cruise', 'Engine_SeaLevelThrust')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial','LowerSkinMaterial')
load('vertTailStructures.mat', 'optRibParameters')

% Loading in a different coordinates txt file to plot the aerofoil
load('NACA 0012 plotting purposes.txt')
x = NACA_0012_plotting_purposes(:,1);
y = NACA_0012_plotting_purposes(:,2);

% Defining Parameters
numSections = input('How many sections do you want to discretise the vertical tailplane into? ');
Nz = 1.5;             % Limit load factor
numMaterial=1;    % From Materials.mat, must be integer between 1 and 4

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
bMin = 0.0015;
[frontSpar] = sparSizing(vertTail, SparMaterial(numMaterial), frontSpar, bMin, optRibParameters.ribPositions);
[rearSpar] = sparSizing(vertTail, SparMaterial(numMaterial), rearSpar, bMin, optRibParameters.ribPositions);

%% Plotting Results
% Plotting Loading Distribution
fig1 = figure(1);
hold on

plot(vertTail.span, vertTail.loading, 'k-')
legend('Overall Loading Distribution', 'Location', ' Southeast')
ylabel('Loading Distribution (N/m)')
xlabel('Spanwise Coordinate y (m)')
% title('Vert Tail Vertical Loading Distribution')
grid minor
fig1.Units = 'normalized';
fig1.Position = [0 0.5 0.25 0.4];

% Plotting Shear Force
fig2 = figure(2);
hold on
plot(vertTail.span, vertTail.shearForce)
ylabel('Shear Force (N)')
xlabel('Spanwise Coordinate y (m)')
% title('Vert Tail Vertical Shear Force Distribution')
grid minor
fig2.Units = 'normalized';
fig2.Position = [0.25 0.5 0.25 0.4];

% Plotting Bending Moment
fig3 = figure(3);
hold on
plot(vertTail.span, vertTail.bendingMoment)
ylabel('Bending Moment (Nm)')
xlabel('Spanwise Coordinate y (m)')
% title('Vert Tail Bending Moment Distribution')
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

% Plotting front Spar flange breadth
figure
hold on
plot(vertTail.span, 1000*frontSpar.b, '-r')
plot(vertTail.span, 1000*frontSpar.bReq, '-b')
xlabel('Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)', 'Color', 'k')
legend('Actual Flange Breadth', 'Required Flange Breadth')
% title('Vertical Tail Front Spar Flange Breadth')
grid minor


% 1 front Spar flange thickness
figure
hold on
plot(vertTail.span, 1000*frontSpar.tf, '-r')
plot(vertTail.span, 1000*frontSpar.tfReq, '-b')
xlabel('Spanwise Coordinate y (m)')
ylabel('Spar Flange Thickness t_f (mm)', 'Color', 'k')
legend('Actual Flange Thickness', 'Required Flange Thickness')
% title('Vertical Tail Front Spar Flange Thickness')
grid minor

% Plotting spar Ixx values
figure
hold on
plot(vertTail.span, frontSpar.Ixx, '-b')
plot(vertTail.span, frontSpar.IxxReq, '--b')
ylabel('Second Moment of Area I_x_x (m^4)')
xlabel('Spanwise Coordinate y (m)')
legend('Actual I_x_x', 'Required I_x_x')
% title('Vertical Tail Front Spar I_x_x Distribution');
grid minor

figure
hold on
plot(vertTail.span, frontSpar.Ixx, '-b')
plot(vertTail.span, frontSpar.IxxReq, '--b')
ylabel('Cross-sectional Area (m^2)')
xlabel('Spanwise Coordinate y (m)')
legend('Actual Area', 'Required Area')
% title('Vertical Tail Front Spar I_x_x Distribution');
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
plot(0.25,0,'xc','MarkerSize',10,'LineWidth',1.5)
plot(frontSpar.coords(1,:),frontSpar.coords(2,:),'LineWidth',1.5)
plot(rearSpar.coords(1,:),rearSpar.coords(2,:),'LineWidth',1.5)
legend({'NACA 0012','Centre of gravity','Flexural Axis','Aerodynamic Centre', 'Front Spar', 'Rear Spar'},'Location','Northeast')
grid minor

%% Skin thickness sizing (ch3)
[N_alongSpan,t2_alongSpan,sigma,boxHeight] = skinStringerFunction(numSections,vertTail,UpperSkinMaterial(numMaterial));

%% Skin Stringer Panel Sizing and Optimization
%% Skin Stringer Panel Sizing and Optimization


[VSSOptimum,ESkin,stringerGeometry,stringerIndex]=SSPOptimum(vertTail,N_alongSpan,UpperSkinMaterial);
[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,vertTail.boxLength,VSSOptimum);

[LVSSOptimum,LESkin,lowerstringerGeometry,LowerstringerIndex]=SSPOptimum(vertTail,N_alongSpan,LowerSkinMaterial(numMaterial));
[LnoStringersDist,LskinThicknessDist,lowerStringerThicknessDist]=skinStringerDistribution(N_alongSpan,vertTail.boxLength,LVSSOptimum);


%% Rib Spacing and Rib Thickness Optimisation
[rSpacing,optRibSpacing,massVTPBox,massEffRib,massEffSS,ribThickness,minMassIndex]=ribSpacing(vertTail,VSSOptimum,boxHeight,skinThicknessDist,N_alongSpan,noStringersDist,LskinThicknessDist,LnoStringersDist,LVSSOptimum);
[optRibParameters]=RibThickness(optRibSpacing,vertTail,minMassIndex,ribThickness);

for i=1:length(vertTail.span)
    skinStep(i)=vertTail.span(1)-vertTail.span(i);
end 
[val,idx]=min(abs(skinStep-optRibParameters.ribSpacing));
minVal=skinStep(idx);


% Upper Skin Thickness Distribution 
figure
x=[vertTail.span(end:-idx:1)];
y=[skinThicknessDist(end:-idx:1)*1000];
plot(vertTail.span,skinThicknessDist*1000,'r')
hold on
stairs(x,y,'b')
xlabel('Distance along Vertical Tailplane(m)') 
ylabel('Skin Thickness (mm)')
legend('Required Skin Thickness','Actual Skin Thickness')
% title('Skin Thickness Distribution')
grid minor

% Lower Skin Thickness Distribution 
figure
x=[vertTail.span(end:-idx:1)];
y=[LskinThicknessDist(end:-idx:1)*1000];
plot(vertTail.span,LskinThicknessDist*1000,'r')
hold on
stairs(x,y,'b')
xlabel('Distance along Vertical Tailplane(m)') 
ylabel('Skin Thickness (mm)')
legend('Required Skin Thickness','Actual Skin Thickness')
%title('Lower Skin Thickness Distribution')
grid minor


% figure
% surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tSkin,stringerGeometry.aEffective)
% xlabel('As/bt')
% ylabel('Ts/t')
% zlabel('Skin Thickness (m)') 
% title('Skin Thickness for different Skin-Stringer Ratios')
% colormap('turbo')
% s=colorbar();
% s.Label.String ='Total Area (m^2)';


% figure
% surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tStringer,stringerGeometry.aEffective)
% xlabel('As/bt')
% ylabel('Ts/t')
% zlabel('Stringer Thickness (m)') 
% title('Stringer Thickness for different Skin-Stringer Ratios')
% colormap('turbo')
% s=colorbar();
% s.Label.String ='Total Area (m^2)';

% Saving the workspace for other programmes
save('vertTailStructures.mat')