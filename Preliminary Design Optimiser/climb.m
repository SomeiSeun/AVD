function [ROC_max, altitude] = climb(W, C_Dmin, L_Dmax, S, T_dummy)

% This function gives the Rate of Climb values at different altitudes which
% needs to be plotted. Once plotted, extrapolate that line and get the rate
% of climb at 42,000 ft and also find the altitude where the Service
% Ceiling will be which happens when you have rate of climb of 500 ft/min.

% The INPUTS are: (ALL SI UNITS)
% W is the Weight of the aircraft in Newtons at start of cruise phase
% C_Dmin is minimum drag coefficient
% L_Dmax is the max lift to drag ratio for the aircraft
% S is the reference wing area in m^2
% T_dummy is the thrust at MTOW

% The OUTPUTS are: 
% ROC_max is an array of Rate of climb values for different altitudes in
% feet per minute
% altitude is an array of altitude values in feet

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0.273920 kg/m^3 is the density at 42,000 ft AMSL. 

height = 0;          % Setting a value for altitude
i = 1;               % Setting a value for i
theta = 0.05;

while height < 10000

[Temp, a, P, rho] = atmosisa(height);      % Finding out Temperature and Density at that altitude in SI Units

beta_thrust_ratio_cruise = ThrustLapseModel(0.8, height*3.28084, 0.8, 35000);
Thrust = beta_thrust_ratio_cruise * T_dummy; 

Z = 1 + sqrt(1 + (3) / ((L_Dmax^2) * (Thrust / W)^2));   % A variable used for Rate of Climb calculation

ROC_max_metres = ((Thrust / W)^1.5) * sqrt((W / S) * Z / (3 * rho * C_Dmin)) * ...
    (1 - (Z / 6) - ((3 * cos(theta) * ...
    cos(theta)) / (2 * (Thrust / W)^2 * Z * L_Dmax^2))); % Finding out Rate of Climb in m/s

ROC_max(i) = ROC_max_metres * 3.28084 * 60;         % Converting Rate of Climb to feet per minute
height = height + 100;                              % Adding 100 m to the height for next iteration
altitude(i) = height * 3.28084;                     % Converting altitude to feet
i = i + 1;

end

end