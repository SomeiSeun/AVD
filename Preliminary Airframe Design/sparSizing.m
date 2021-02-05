function [frontSpar, rearSpar] = sparSizing(NACA, wing, SparMaterial, frontSparLocation, rearSparLocation,...
    neutralAxisLocation, frontSpar, rearSpar)


% loading material parameters and wing momment distribution
numSections = length(wing.span);
E = [SparMaterial.YM]';
TYS = [SparMaterial.TYS]';

% loading NACA aerofoil for visualisation
fileID = fopen(NACA, 'r');
NACA = fscanf(fileID, '%f %f', [2 Inf]);

% Determining required Ixx values for front and rear spars for each spar
% material TYS available
frontSpar.Ixx = wing.bendingMoment.*frontSpar.height./(2*TYS);
frontSpar.Ixx = wing.bendingMoment.*frontSpar.height./(2*TYS);




% Plotting figures
fig1 = figure(1);
hold on
plot(NACA(1,1:26), NACA(2,1:26), 'b')
plot(NACA(1,27:end), NACA(2,27:end), 'b')
plot([frontSparLocation frontSparLocation], [neutralAxisLocation + frontSparHeight/2, neutralAxisLocation - frontSparHeight/2])
plot([rearSparLocation rearSparLocation], [neutralAxisLocation + rearSparHeight/2, neutralAxisLocation - rearSparHeight/2])
axis equal
grid minor
