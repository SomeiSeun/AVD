clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'spanWing', 'cRootWing', 'cTipWing', 'components', 'taperWing')

numSections = 500;

wing.chord = linspace(cTipWing, cRootWing, numSections);
wing.span = linspace(spanWing/2, 0, numSections);

L0 = 4*W0/(pi*spanWing);
wing.lift = L0*sqrt(1 - (2*wing.span/spanWing).^2);
wing.selfWeight =  6*0.5*components(1).weight/(spanWing*(taperWing^2 + taperWing + 1))*(wing.chord/cRootWing).^2;

wing.loading = wing.lift - wing.selfWeight;

for i = 2:numSections
    wing.shearForce(i) = trapz(wing.span(1:i), wing.loading(1:i));
    wing.bendingMoment(i) = trapz(wing.span(1:i), wing.shearForce(1:i));
end

save('WingDistributions.mat', 'wing')

figure(1)
hold on
plot(wing.span, wing.lift)
plot(wing.span, -wing.selfWeight)
plot(wing.span, wing.loading)
legend('Lift Distribution', 'Self-weight Distribution', 'Total Loading Distribution', 'Location', ' Northeast')
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

