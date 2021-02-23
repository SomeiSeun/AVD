clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'spanHoriz', 'cRootHoriz', 'taperHoriz', 'Thrustline_position',...
    'SHoriz', 'rho_cruise', 'V_Cruise')
load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial','LowerSkinMaterial')
load('diveTrim');

% Loading in a different coordinates txt file to plot the aerofoil
load('NACA 0012 plotting purposes.txt')
x = NACA_0012_plotting_purposes(:,1);
y = NACA_0012_plotting_purposes(:,2);

% Defining Parameters
numSections = input('How many points would you like to discrtise the tailplane into? ');
Nz = 2.5; % limit load factor
numMaterial = 1; % from Materials.mat, must be integer between 1 and 4

% Evaluating lift and weight distributions
liftReq = Nz*liftHorizDive;
horizTail =  bendingTail(Nz, numSections, liftReq, components, spanHoriz, cRootHoriz, taperHoriz);

% Defining horizontal tail box structural parameters
frontSparLocation = 0.25;
rearSparLocation = 0.75;
flexuralAxis = 0.5*(frontSparLocation + rearSparLocation);

% Evaluating basic wing box parameters
[horizTail, frontSpar, rearSpar] = analyseWingBox('NACA 0012.txt', horizTail, frontSparLocation, rearSparLocation);

K_s = 8.1;
Cm0 = 0;
cg = 0.41;

% Evaluating shear stresses and spar web thicknesses
[horizTail,frontSpar,rearSpar] = shear_flow(horizTail, frontSpar, rearSpar, K_s,...
    rho_cruise, V_Dive, SparMaterial(numMaterial).YM, frontSparLocation, rearSparLocation,...
    flexuralAxis, Cm0, cg, Thrustline_position(3));

% Evaluating spar flange dimensions
[frontSpar] = sparSizing(horizTail, SparMaterial(numMaterial), frontSpar);
[rearSpar] = sparSizing(horizTail, SparMaterial(numMaterial), rearSpar);


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

% % Plotting wingbox area variation
% figure
% plot(wing.span,wing.sparwebarea,'.b')
% grid on
% xlabel('Wing Span (m)')
% ylabel('Wingbox Area (m^2)')
% title('Wingbox Area Distribution')

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

% % Plotting the front and rear spar shear flow
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

% Plotting front and Rear Spar flange dimensions

fig7 = figure(7);
hold on
yyaxis left
plot(horizTail.span, 1000*frontSpar.b, '-r')
plot(horizTail.span, 1000*rearSpar.b, '-b')
xlabel('Horiz tail Spanwise Coordinate y (m)')
ylabel('Spar Flange Breadth b (mm)', 'Color', 'k')
yyaxis right
plot(horizTail.span, 1000*frontSpar.tf, '--r')
plot(horizTail.span, 1000*rearSpar.tf, '--b')
ylabel('Spar Flange Thickness t_f (mm)', 'Color', 'k')
legend('Front Spar Flange Breadth', 'Rear Spar Flange Breadth', 'Front Spar Flange Thickness', 'Rear Spar Flange Thickness')
title('Horiz tail Spar Flange Thickness and Breadth')
grid minor
fig7.Units = 'normalized';
fig7.Position = [0.5 0.05 0.25 0.4];

% Plotting spar areas and Ixx values
fig8 = figure(8);
hold on
yyaxis left
plot(horizTail.span, frontSpar.Area, '-r')
plot(horizTail.span, rearSpar.Area, '-b')
xlabel('Horiz tail Spanwise Coordinate y (m)')
ylabel('Spar Cross-Sectional Area (m^2)', 'Color', 'k')
yyaxis right
plot(horizTail.span, frontSpar.Ixx, '--r')
plot(horizTail.span, rearSpar.Ixx, '--b')
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
legend({'NACA 0012','Centre of gravity','Flexural Axis','Mean Aerodynamic Chord'},'Location','Northeast')
grid minor

%% Skin thickness sizing (ch3)
[N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections,horizTail,UpperSkinMaterial(numMaterial));

%% Skin Stringer Panel Sizing and Optimization
[HSSOptimum,ESkin,stringerGeometry,stringerIndex]=SSPOptimum(horizTail,N_alongSpan,UpperSkinMaterial(numMaterial));
[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,horizTail.boxLength,HSSOptimum);


% Plotting skin thickness distribution along span 
figure
x=[horizTail.span(end:-75:1)];
y=[skinThicknessDist(end:-75:1)*1000];
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