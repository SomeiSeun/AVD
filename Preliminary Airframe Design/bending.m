clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'spanWing', 'cRootWing', 'cTipWing', 'components', 'taperWing', 'Thrustline_position')

% Discretising wing into sections
numSections = 500;
wing.chord = linspace(cTipWing, cRootWing, numSections);
wing.span = linspace(spanWing/2, 0, numSections);

% Wing Lift (assuming no tail lift)
wing.lift = 4*W0/(pi*spanWing)*sqrt(1 - (2*wing.span/spanWing).^2);

% Wing Self-weight (assumed quadratic variation)
wing.selfWeight =  6*0.5*components(1).weight/(spanWing*(taperWing^2 + taperWing + 1))*(wing.chord/cRootWing).^2;

% Wing Engine Weight
enginePylonWidth = 0.5; %m
wing.engineWeight = zeros(1, numSections);
[M1,I1] = min(abs(wing.span - Thrustline_position(2) - 0.5*enginePylonWidth));
[M2,I2] = min(abs(wing.span - Thrustline_position(2) + 0.5*enginePylonWidth));
wing.engineWeight(I1:I2) = 0.5*components(7).weight/(wing.span(I1) - wing.span(I2));

% Wing Undercarriage Weight (currently assuming u/c @ y=5m)
ucSupportWidth = 1; %m
wing.ucWeight = zeros(1, numSections);
[M1,I1] = min(abs(wing.span - 5 - 0.5*ucSupportWidth));
[M2,I2] = min(abs(wing.span - 5 + 0.5*ucSupportWidth));
wing.ucWeight(I1:I2) = 0.5*components(5).weight/(wing.span(I1) - wing.span(I2));

% Remaining Aircraft Weight (currently assuming between y=0m and y=1.5m)
fuseWingWidth = 1.5; %m
wing.fuseWeight = zeros(1, numSections);
[M1,I1] = min(abs(wing.span - fuseWingWidth));
I2 = numSections;
wing.fuseWeight(I1:I2) = 0.5*(W0 - components(1).weight - components(7).weight - components(5).weight)/(wing.span(I1) - wing.span(I2));

% Overall Wing Loading
wing.loading = wing.lift - wing.selfWeight - wing.engineWeight - wing.ucWeight - wing.fuseWeight;

% Calculating shear force and bending moment distributions
for i = 2:numSections
    wing.shearForce(i) = trapz(wing.span(1:i), wing.loading(1:i));
    wing.bendingMoment(i) = trapz(wing.span(1:i), wing.shearForce(1:i));
end

% Saving Workspace
save('WingDistributions.mat', 'wing')


% Plotting Results
figure(1)
hold on
plot(wing.span, wing.lift, '--')
plot(wing.span, -wing.selfWeight, '--')
plot(wing.span, -wing.engineWeight, '--')
plot(wing.span, -wing.ucWeight, '--')
plot(wing.span, -wing.fuseWeight, '--')
plot(wing.span, wing.loading, 'k')
legend('Lift Distribution', 'Self-weight Distribution', 'Engine Weight Distribution', 'Undercarriage Weight Distribution', 'Total Loading Distribution', 'Location', ' Southeast')
ylabel('Loading Distribution (N/m)')
xlabel('Wing Spanwise Coordinate y (m)')
title('Wing Vertical Loading Distribution')
grid minor

figure(2)
hold on
plot(wing.span, wing.shearForce)
ylabel('Shear Force (N)')
xlabel('Wing Spanwise Coordinate y (m)')
title('Wing Vertical Shear Force Distribution')
grid minor

figure(3)
hold on
plot(wing.span, wing.bendingMoment)
ylabel('Bending Moment (Nm)')
xlabel('Wing Spanwise Coordinate y (m)')
title('Wing Bending Moment Distribution')
grid minor

