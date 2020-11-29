%this script analyses the aerofoil for the horizontal and vertical stabilisers
clear
clc
clf

addpath('../Xfoil')

NACA = '0012';
numNodes = 500;
Mach = [0 : 0.1 : 0.8];
RE = 1e6;
AoAmin = 0;
AoAstep = 1;
AoAmax = 3;
ITER = 300;

for i = 1:length(Mach)
    [AoA{i}, CL{i}, CM{i}, CD{i}] = viscXfoilAnalyse(NACA, numNodes, Mach(i), RE, [AoAmin, AoAstep, AoAmax], ITER);
    CLalpha(i) = 180/pi*(CL{i}(4) - CL{i}(1))/(AoA{i}(4) - AoA{i}(1));
end

save('tailplaneAerofoil.mat')

figure(1)
hold on
for i = 1:length(Mach)
    plot(AoA{i}, CL{i}, 'DisplayName', ['Mach ' num2str(Mach(i))])
end
title(['Lift Coefficient vs AoA for NACA ' NACA])
xlabel('AoA (degrees)')
ylabel('Coefficient of Lift C_L')
grid minor
legend('Location', 'Northwest')
hold off


figure(2)
hold on
plot(Mach, CLalpha, 'bo--')
title(['Lift Curve Slope vs Mach for NACA ' NACA])
xlabel('Mach Number')
ylabel('Lift Curve Slope C_L_\alpha (1/rad)')
grid minor
hold off
