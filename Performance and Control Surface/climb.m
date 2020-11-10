function [ROC_max, altitude] = climb(W, C_Dmin, L_Dmax, S)

% The INPUTS are: (ALL SI UNITS)
% W is the Weight of the aircraft in Newtons at start of cruise phase
% C_Dmin is minimum drag coefficient
% L_Dmax is the max lift to drag ratio for the aircraft
% S is the reference wing area in m^2

% The OUTPUTS are: (ALL SI UNITS)
% ROC_max is an array of Rate of climb values for different altitudes in
% feet per minute
% altitude is an array of altitude values in feet

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To plot the ROC curve against altitude, need to use a loop to get the
% differet ROC values at different altitudes. For this, WILL NEED AN
% EXPRESSION FOR THRUST AS A FUNCTION OF ALTITUDE, keeping the weight
% constant. The absolute ceiling is at 42000 ft AMSL. 

height = 0;          % Setting a value for altitude
i = 1;                 % Setting a value for i
while height < 10000 
    
[T, a, P, rho] = atmosisa(height);
Z = 1 + sqrt(1 + (3) / ((L_Dmax^2) * (Thrust / W)^2));
ROC_max_metres = ((Thrust / W)^1.5) * sqrt((W / S) * Z / (3 * rho * C_Dmin)) * ...
    (1 - (Z / 6) - ((3 * cos(theta) * cos(theta)) / (2 * (T / W)^2 * Z * L_Dmax^2)));
ROC_max(i) = ROC_max_metres * 3.28084 * 60; 
height = height + 100;
altitude(i) = height * 3.28084;
i = i + 1;

end

end