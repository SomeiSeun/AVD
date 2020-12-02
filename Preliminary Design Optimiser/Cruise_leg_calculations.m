function [L_over_D_max, Vs, V_LDmax, V_max_mach, V_min_mach] = Cruise_leg_calculations(C_Dmin, C_LminD, AR, e, rho, W, S, C_Lmax, n, T)

% This function is used to find some values such as Stall speed, max Lift to Drag ratio, for the aircraft during the
% cruise phase.

% The INPUTS are: (ALL SI UNITS)
% C_Dmin is the Minimum Drag Coefficient
% C_LminD is the Lift Coefficient at Minimum Drag
% AR is the Aspect Ratio
% e is the Oswald Efficiency
% rho is the density of air in kg/m^3
% W is the Weight of the aircraft in Newtons at that phase of the flight
% S is the wing reference area in m^2
% C_Lmax is the Max Lift Coefficient
% n is the load factor
% T is the thrust in Newtons at that phase of the flight

% The OUTPUT is: (ALL SI UNITS)
% L_over_D_max is the max Lift to Drag ratio
% Vs is the stall speed at load factor n in m/s
% V_LDmax is the velocity at max L/D in m/s
% V_max_mach is the Maximum Level airspeed in Mach
% V_min_mach is the Minimum Level airspeed in Mach

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 1/(pi * AR * e);                                                        % Finding out the Induced drag coefficient
L_over_D_max = 1 / (sqrt((4*C_Dmin*k) + (2*k*C_LminD)^2) - (2*k*C_LminD));  % This equation gives the max Lift to Drag ratio
fprintf('The max L/D ratio is %f. \n',L_over_D_max);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vs = sqrt((2 * n * W) / (rho * S * C_Lmax));                    % This equation gives the stall speed at a load factor n
fprintf('The stalling speed is %f m/s. \n',Vs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_LDmax = sqrt(((2 * W)/(rho * S)) * sqrt(k / (C_Dmin + k*(C_LminD^2)))); % This equation gives the Velocity at max L/D ratio 
fprintf('The velocity at max L/D ratio is %f m/s. \n',V_LDmax);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_max = sqrt((T + 2*W*k*C_LminD) + sqrt(((T + 2*W*k*C_LminD)^2) - 4*(W^2)*k*(C_Dmin + k*(C_LminD^2))) ...
    /(rho*S*(C_Dmin + k*(C_LminD^2))));                         % This equation gives the Maximum Level Airspeed in m/s
Temp_cruise_1 = 218.808;                                        % Temperature at 35000 ft in Kelvin 
V_max_mach = V_max / sqrt(1.4 * 287 * Temp_cruise_1);

fprintf('The max velocity of the aircraft is %f mach. \n',V_max_mach);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_min = sqrt((T + 2*W*k*C_LminD) - sqrt(((T + 2*W*k*C_LminD)^2) - 4*(W^2)*k*(C_Dmin + k*(C_LminD^2))) ...
    /(rho*S*(C_Dmin + k*(C_LminD^2))));                         % This equation gives the Minimum Level Airspeed in m/s
V_min_mach = V_min / sqrt(1.4 * 287 * Temp_cruise_1);

fprintf('The Minimum level airspeed is %f mach. \n',V_min_mach);
end