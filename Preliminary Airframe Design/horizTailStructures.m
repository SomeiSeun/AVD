clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'spanHoriz', 'cRootHoriz', 'taperHoriz', 'Thrustline_position',...
    'SHoriz', 'rho_cruise', 'V_Cruise')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial','LowerSkinMaterial')
load('diveTrim');
load('horizTailStructures.mat', 'optRibParameters')

% Loading in a different coordinates txt file to plot the aerofoil
load('NACA 0012 plotting purposes.txt')
x = NACA_0012_plotting_purposes(:,1);
y = NACA_0012_plotting_purposes(:,2);

% Defining Parameters
numSections = input('How many points would you like to discrtise the tailplane into? ');
Nz = 2.5; % limit load factor
numMaterial = 1; % from Materials.mat, must be integer between 1 and 4
fuseWidth = 1;

% Evaluating lift and weight distributions
liftReq = Nz*liftHorizDive;
horizTail =  bendingHorizTail(Nz, numSections, liftReq, components, spanHoriz, cRootHoriz, taperHoriz, fuseWidth);

% Evaluating basic wing box parameters
tcRatio = 0.1;
[horizTail, frontSpar, rearSpar] = analyseWingBox('NACA 0012.txt', horizTail, tcRatio);

K_s = 8.1;
Cm0 = 0;
cg = 0.41;

% Evaluating shear stresses and spar web thicknesses
flexuralAxis = 0.5*(frontSpar.coords(1,1) + rearSpar.coords(1,1));
[horizTail,frontSpar,rearSpar] = shear_flow(horizTail, frontSpar, rearSpar, K_s,...
    rho_cruise, V_Dive, SparMaterial(numMaterial).YM, flexuralAxis, Cm0, cg, Thrustline_position(3));

% Evaluating spar flange dimensions
bMin = 0.003;
frontSpar = sparSizing(horizTail, SparMaterial(numMaterial), frontSpar, bMin, optRibParameters.ribPositions);
rearSpar = sparSizing(horizTail, SparMaterial(numMaterial), rearSpar, bMin, optRibParameters.ribPositions);


%% Plotting Results

% Plotting Loading Distribution
fig1 = figure(1);
hold on
plot(horizTail.span, horizTail.lift, '.')
plot(horizTail.span, -horizTail.selfWeight, '.')
plot(horizTail.span, horizTail.loading, 'k-')
legend('Lift', 'Self-weight', 'Overall Loading Distribution', 'Location', ' Southeast')
ylabel('Loading Distribution (N/m)')
xlabel('Horiz tail Spanwise Coordinate y (m)')
title('Horiz tail Vertical Loading Distribution')
grid minor
fig1.Units = 'normalized';
fig1.Position = [0 0.5 0.25 0.4];

% Plotting Shear Force
fig2 = figure(2);
hold on
plot(horizTail.span, horizTail.shearForce)
ylabel('Shear Force (N)')
xlabel('Horiz tail Spanwise Coordinate y (m)')
title('Horiz tail Vertical Shear Force Distribution')
grid minor
fig2.Units = 'normalized';
fig2.Position = [0.25 0.5 0.25 0.4];

% Plotting Bending Moment
fig3 = figure(3);
hold on
plot(horizTail.span, horizTail.bendingMoment)
ylabel('Bending Moment (Nm)')
xlabel('Horiz tail Spanwise Coordinate y (m)')
title('Horiz tail Bending Moment Distribution')
grid minor
fig3.Units = 'normalized';
fig3.Position = [0.5 0.5 0.25 0.4];

% Plotting the torque distribution
fig4 = figure(4);
plot(horizTail.span, horizTail.torque)
xlabel('Horiz tail Spanwise Coordinate y (m)')
ylabel('Torque Distribution (N)')
title('Horiz tail Torque Distribution')
grid minor
fig4.Units = 'normalized';
fig4.Position = [0.75 0.5 0.25 0.4];

% Plotting the thickness variations
fig5 = figure(5);
hold on
plot(horizTail.span,1000*frontSpar.tw,'r')
plot(horizTail.span,1000*rearSpar.tw,'b')
xlabel('Horiz tail span (m)')
ylabel('Thickness (mm)')
legend({'Front spar','Rear spar'},'Location','Northeast')
title('Spar Web Thickness Distribution')
grid minor
fig5.Units = 'normalized';
fig5.Position = [0 0.05 0.25 0.4];


% Plotting front and rear spar shear stress
fig6 = figure(6);
plot(horizTail.span,frontSpar.shearstress,'r')
hold on
plot(horizTail.span,rearSpar.shearstress,'b')
xlabel('Horiz tail span (m)')
ylabel('Shear stress (N/m^2)')
legend({'Front Spar','Rear Spar'},'Location','Northeast')
title('Spar Web Shear Stress Distribution')
grid minor
fig6.Units = 'normalized';
fig6.Position = [0.25 0.05 0.25 0.4];

% Plotting front Spar flange breadth
figure
hold on
plot(horizTail.span, 1000*frontSpar.b, '-r')
plot(horizTail.span, 1000*frontSpar.bReq, '-b')
xlabel('Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)', 'Color', 'k')
legend('Actual Flange Breadth', 'Required Flange Breadth')
title('Horizontal Tail Front Spar Flange Breadth')
grid minor


% Plotting front Spar flange thickness
figure
hold on
plot(horizTail.span, 1000*frontSpar.tf, '-r')
plot(horizTail.span, 1000*frontSpar.tfReq, '-b')
xlabel('Spanwise Coordinate y (m)')
ylabel('Spar Flange Thickness t_f (mm)', 'Color', 'k')
legend('Actual Flange Thickness', 'Required Flange Thickness')
title('Horizontal Tail Front Spar Flange Thickness')
grid minor

% Plotting spar Ixx values
figure
hold on
plot(horizTail.span, frontSpar.Ixx, '-b')
plot(horizTail.span, frontSpar.IxxReq, '--b')
ylabel('Second Moment of Area I_x_x (m^4)')
xlabel('Spanwise Coordinate y (m)')
legend('Actual I_x_x', 'Required I_x_x')
title('Horizontal Tail Front Spar I_x_x Distribution');
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
[N_alongSpan,t2_alongSpan,sigma,boxHeight] = skinStringerFunction(numSections,horizTail,UpperSkinMaterial(numMaterial));

%% Skin Stringer Panel Sizing and Optimization
[HSSOptimum,ESkin,stringerGeometry,stringerIndex]=SSPOptimum(horizTail,N_alongSpan,UpperSkinMaterial);
[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,horizTail.boxLength,HSSOptimum);

[LHSSOptimum,LESkin,lowerstringerGeometry,LowerstringerIndex]=SSPOptimum(horizTail,N_alongSpan,LowerSkinMaterial(numMaterial));
[LnoStringersDist,LskinThicknessDist,lowerStringerThicknessDist]=skinStringerDistribution(N_alongSpan,horizTail.boxLength,LHSSOptimum);

[rSpacing,optRibSpacing,massHTPBox,massEffRib,massEffSS,ribThickness,minMassIndex]=ribSpacing(horizTail,HSSOptimum,boxHeight,skinThicknessDist,N_alongSpan,noStringersDist,LskinThicknessDist,LnoStringersDist,LHSSOptimum);
[optRibParameters]=RibThickness(optRibSpacing,horizTail,minMassIndex,ribThickness);

% Plotting Mass Vs Rib Spacing
figure 
plot(rSpacing,massHTPBox,'-b')
hold on 
plot(rSpacing,massEffRib,'-r')
plot(rSpacing,massEffSS)
xlabel('Rib Spacing(m)')
ylabel('Volume')
legend('Total','Ribs','Skin-Stringer')
title('Rib Spacing Optimisation')
grid minor 
hold off


figure 
plot(optRibParameters.ribPositions,optRibParameters.ribThickness*1000,'bx','Linewidth',1.3)
xlabel('Position along span(m)')
ylabel('Rib Thickness (mm)')
% title('Rib Thickness Distribution')
grid minor




figure
surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tSkin,stringerGeometry.aEffective)
xlabel('As/bt')
ylabel('Ts/t')
zlabel('Skin Thickness (m)') 
title('Skin Thickness for different Skin-Stringer Ratios')
colormap('turbo')
s=colorbar();
s.Label.String ='Total Area (m^2)';





% Plotting skin thickness distribution along span 
figure
x=[horizTail.span(end:-50:1)];
y=[skinThicknessDist(end:-50:1)*1000];
plot(horizTail.span,skinThicknessDist*1000,'-r')
hold on
stairs(x,y,'b')
xlabel('Distance along Horizontal Tailplane (m)') 
ylabel('Skin Thickness (mm)')
title('Skin Thickness Distribution')
grid minor

figure
surf(stringerGeometry.AStoBT,stringerGeometry.TStoT,stringerGeometry.tStringer,stringerGeometry.aEffective)
xlabel('As/bt')
ylabel('Ts/t')
zlabel('Stringer Thickness (m)') 
title('Stringer Thickness for different Skin-Stringer Ratios')
colormap('turbo')
s=colorbar();
s.Label.String ='Total Area (m^2)';


save('horizTailStructures.mat')
