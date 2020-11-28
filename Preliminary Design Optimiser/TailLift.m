function [CL_a,CL_max_clean]=TailLift(AR_HT,d,b,M,sweepanglemax,Cl_am,Cl_max,sweep_quarterchord)
beta=sqrt(1-(M).^2);% to account for compressibility effects;
F=1.07*(1+(d/b))^2;
% fuselage spillover lift factor
etah=0.95 %airfoil efficiency factor
a=2*pi*AR_HT*1;
B=((AR_HT.*beta)/etah).^2;
c=(1+(tand(sweepanglemax)./beta).^2);
CL_a=a./(2+sqrt(4+(B.*c)));

CL_max_clean=0.9.*Cl_max.*cosd(sweep_quarterchord);                        % Determine CL max for clean configuration

end 