clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'components', 'spanWing', 'cRootWing', 'taperWing', 'Thrustline_position',...
    'rho_cruise', 'V_Cruise')
load('Materials.mat', 'SparMaterial')

% Loading Parameters
numSections = 100;
Nz = 1.5*2.5;
fuelInTank = 1;

% Evaluating weight and lift distributions, shear force, and bending
% moments along the wing
wing = bending(Nz, fuelInTank, numSections, W0, components, spanWing, cRootWing, taperWing, Thrustline_position);

% Defining wing structural parameters
frontSparLocation = 0.25;
rearSparLocation = 0.7;
flexuralAxis = 0.5*(frontSparLocation + rearSparLocation);

frontSparHeight = 0.12;     % as a fraction of chord
rearSparHeight = 0.07;      % as a fraction of chord

K_s = 8.1;
E = 73*10^9;
Cm0 = -0.2;
cg = 0.6;

<<<<<<< HEAD
[frontSpar,rearSpar] = shear_flow(K_s, rho_cruise, V_Cruise, E, frontSparLocation, rearSparLocation, flexuralAxis, Cm0, cg);

neutralAxisLocation = 0.01; % above airfoil chord-line datum

% [frontSpar, rearSpar] = sparSizing('NACA 64125.txt', wing, SparMaterial, frontSparLocation, rearSparLocation,...
%     neutralAxisLocation, frontSpar, rearSpar);
=======
[frontSpar,rearSpar] = shear_flow(wing, K_s, rho_cruise, V_Cruise, E, frontSparLocation, rearSparLocation, flexuralAxis, Cm0, cg);

[frontSpar, Ixx, Area] = sparSizing(wing, SparMaterial(1), frontSpar);
>>>>>>> main

figure(7)
plot(wing.span, frontSpar.b)
figure(8)
plot(wing.span, frontSpar.tf)
% Plotting Results
% fig1 = figure(1);
% hold on
% plot(wing.span, wing.lift, '--')
% plot(wing.span, -wing.selfWeight, '--')
% plot(wing.span, -wing.engineWeight, '-')
% plot(wing.span, -wing.ucWeight, '-')
% plot(wing.span, -wing.fuseWeight, '-')
% plot(wing.span, -wing.fuelWeight, '-')
% plot(wing.span, wing.loading, 'k-.')
% legend('Lift', 'Self-weight', 'Engine Weight', 'Undercarriage Weight', 'Aircraft Weight',...
%     'Fuel Weight', 'Overall Loading Distribution', 'Location', ' Southeast')
% ylabel('Loading Distribution (N/m)')
% xlabel('Wing Spanwise Coordinate y (m)')
% title('Wing Vertical Loading Distribution')
% grid minor
% fig1.Units = 'normalized';
% fig1.Position = [0 0.3 1/3 0.5];
% 
% 
% fig2 = figure(2);
% hold on
% plot(wing.span, wing.shearForce)
% ylabel('Shear Force (N)')
% xlabel('Wing Spanwise Coordinate y (m)')
% title('Wing Vertical Shear Force Distribution')
% grid minor
% fig2.Units = 'normalized';
% fig2.Position = [1/3 0.3 1/3 0.5];
% 
% fig3 = figure(3);
% hold on
% plot(wing.span, wing.bendingMoment)
% ylabel('Bending Moment (Nm)')
% xlabel('Wing Spanwise Coordinate y (m)')
% title('Wing Bending Moment Distribution')
% grid minor
% fig3.Units = 'normalized';
% fig3.Position = [2/3 0.3 1/3 0.5];
