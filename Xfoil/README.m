clear
clc
clf

NACA = 2412;
numNodes = 300;
Mach = 0.6;
RE = 1e6;
AoAmin = -5;
AoAstep = 1;
AoAmax = 10;
ITER = 300;

[AoA, CL, CM, CD] = viscXfoilAnalyse(NACA, numNodes, Mach, RE, [AoAmin, AoAstep, AoAmax], ITER);

%% Plot results
figure(1)
plot(AoA, CL)
grid minor
title('Lift Coefficient vs AoA')
ylabel('Sectional Lift Coefficient C_L')
xlabel('Angle of Attack (degrees)')
xlim([min(AoA) max(AoA)])
ylim([min(CL) max(CL)])

figure(2)
plot(AoA, CM)
grid minor
title('Moment Coefficient vs AoA')
ylabel('Sectional Moment Coefficient C_M')
xlabel('Angle of Attack (degrees)')
xlim([min(AoA) max(AoA)])
ylim([min(CM) max(CM)])

figure(3)
plot(CD, CL)
grid minor
title('Lift Coefficient vs Drag Coefficient')
xlabel('Sectional Drag Coefficient C_D')
ylabel('Sectional Lift Coefficient C_L')
ylim([min(CL) max(CL)])
xlim([min(CD) max(CD)])