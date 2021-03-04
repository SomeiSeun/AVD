clear
clc
close all

load('ConceptualDesign.mat', 'W0', 'V_Cruise', 'rho_cruise', 'SWing');

numPoints = 200;
CL_max = 1.4213;
V_D = V_Cruise*0.82/0.8;

V = linspace(0, V_D, numPoints);

%upper curve
Nz = (1.225*SWing*CL_max/(2*W0))*V.^2;
Nz(Nz > 2.5) = 2.5;

%lower curve
Nz(numPoints+1 : 2*numPoints) = -(1.225*SWing*CL_max/(2*W0))*flip(V).^2;
Nz(Nz < -1) = -1;

figure(1)
hold on
plot([V, flip(V)], Nz)
xlabel('Equivalent Airspeed V (m/s)')
ylabel('Limit Load Factor n')
%title('Chailiner n-V Diagram')
axis([0, V_D*1.1, -1.5 3])
grid minor
text(V_D,2.5,str,'Color','red','FontSize',8)
