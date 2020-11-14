function [E, R, FC] = Range(W_ini, rho, V, S, C_Dmin, c_t, AR, W_fin, e)

% This function can be used to give the Range, Endurance and Fuel
% Consumption for the aircraft, only in the Cruise phase. 

% The INPUTS are: (ALL SI UNITS)
% W_ini is the weight of aircraft at start of cruise phase in Newtons
% rho is the density of air at the altitude of the cruise phase in kg/m^3
% V is the airspeed at that cruise phase in m/s
% S is the reference wing area in m^2
% C_Dmin is the minimum drag coefficient
% c_t is the thrust specific fuel consumption at that cruise phase in 1/s
% AR is the Aspect Ratio
% e is the Oswald Efficiency
% W_fin is the weight of the aircraft at the end of the cruise phase in Newtons

% The OUTPUTS are: (ALL SI UNITS)
% E is the Endurance in hours
% R is the Range in kilometres
% FC is the fuel consumption without any units

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 1 / (pi * AR * e);

E_seconds = (1 / (c_t * sqrt(k * C_Dmin))) * (arctan((2 * sqrt(k) * W_ini) / (rho * V^2 * S * sqrt(C_Dmin)))...
    - arctan((2 * sqrt(k) * W_fin) / (rho * V^2 * S * sqrt(C_Dmin))));    % This equation gives the Endurance in seconds

E = E_seconds/3600;  % This equation gives the Endurance in hours

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R_metres = E_seconds * V;   % Gives the range in metres
R = R_metres * 0.001;       % Gives the range in km

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FC = (R * c_t * sqrt(k * C_Dmin)) / V; % This equation gives the Fuel Consumption

end