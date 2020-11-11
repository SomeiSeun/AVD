clear
clc
clf

NACA = 0010;
numNodes = 300;
Mach = 0.4;
RE = 1e6;
AoAmin = 0;
AoAstep = 1;
AoAmax = 22;
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
plot(CL, CD)

grid minor
title('Drag Coefficient vs Lift Coefficient')
ylabel('Sectional Drag Coefficient C_D')
xlabel('Sectional Lift Coefficient C_L')
xlim([min(CL) max(CL)])
ylim([min(CD) max(CD)])