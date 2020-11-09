function [theta_max, V_x, ROC_X, V_Y, ROC_max] = climb(AR, e, W, C_Dmin, T_max, S, rho, L_Dmax)

% The INPUTS are: (ALL SI UNITS)
% AR is the Aspect Ratio
% e is the Oswald Efficiency
% W is the Weight of the aircraft in Newtons
% C_Dmin is minimum drag coefficient
% T_max is max thrust in Newtons
% S is the reference wing area
% rho is the density of air in kg/m^3
% L_Dmax is the max lift to drag ratio

% The OUTPUTS are: (ALL SI UNITS)
% theta_max is the max climb rate for a jet in degrees
% V_x is the airspeed for theta_max (Best Angle of climb speed) in m/s
% ROC_X is the Rate of Climb associated with V_x in m/s
% V_Y is the airspeed for best rate of climb of jet in m/s
% ROC_max is the maxmimum value for the rate of climb in m/s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 1 / (pi * AR * e);    % Finding out the Induced Drag Coefficient

% The below equation assumes a simplified drag model
theta_max = arcsin((T_max / W) - sqrt(4 * C_Dmin * k)); % Finding out the max climb angle for a jet
% What value for Weight to use?????
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_x = sqrt((2 / rho) * (W / S) * cos(theta_max) * sqrt(k / C_Dmin)); % Gives the airspeed for theta_max for a jet
% ? What altitudes/weight values to use??

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ROC_X = V_x * sin(theta_max);  % Rate of Climb in m/s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_Y = sqrt(((T / S) / (3 * rho * C_Dmin)) * (1 + sqrt(1 + ((3) / ((L_Dmax^2) * (T / W)^2))))); 
% This equation gives the airspeed for best rate of climb for a jet
% What value of Thrust and Weight to use??????????????
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z = 1 + sqrt(1 + (3 / ((L_Dmax^2) * ((T / W)^2)))); % Calculating the value of Z to be used in equation below

ROC_max = ((T / W)^1.5) * sqrt(((W / S) * Z) / (3 * rho * C_Dmin)) * (1 - (Z / 6) - ((3 * cos(theta))...
    / (2 * ((T / W)^2) * Z * (L_Dmax^2)))); 
% What is theta???????
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end