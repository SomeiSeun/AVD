function [S_to] = Take_off_distance(V_stall_takeoff, V_S1, T, W_to, Cd0_takeoff, AR, e, Cl0, L_over_D, S)

% This function can be used to find the Take off distance for the aircraft.

% The INPUTS are: (ALL IN SI UNITS)
% V_stall_takeoff is the stall velocity in take off config in m/s
% V_S1 is the stall speed in clean config in m/s
% T is the thrust at V_TR which is the velocity at end of transition phase in Newtons
% W_to is the weight of aircraft at start of flight in Newtons
% Cd0_takeoff is the Zero lift drag coefficient in take off config
% AR is Aspect Ratio
% e is Oswald Efficiency
% Cl0 is lift coefficient at 0 AOA
% L_over_D is the lift to drag ratio at 1.15*V_S1 (V_TR)
% S is the wing reference area in m^2

% OUTPUT is: (SI UNITS)
% S_to which is the Take-off distance in metres

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_LOF = 1.1 * V_stall_takeoff;     % Finding the Liftoff velocity

S_R = 3 * V_LOF;                   % This gives the Rotation distance in metres
fprintf('The Rotation Distance is %f m. \n',S_R);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g = 9.81;                                             % Gravitational Acceleration
n = 1.2;                                              % Load factor during take-off approximately
h_obs = 35 * 0.3048;                                  % This is the obstacle height in metres
theta_climb = asin((T/W_to) - (1/(L_over_D)));        % This gives the Climb angle theta
R = ((1.15^2) * (V_stall_takeoff^2)) / (g * (n-1));   % Radius of the climb
h_TR = R * (1 - cos(theta_climb));                    % Transition height

if h_obs >= h_TR
    S_C = (h_obs - h_TR) / (tan(theta_climb));        % This is the Climb distance in metres
    S_TR = 0.2156 * (V_stall_takeoff^2) ...
        * ((T/W_to) - (1/(L_over_D)));                % This gives the Transition distance in metres
else
    S_C = 0;                                          % Climb distance in alternate scenario in metres
    S_TR = sqrt(R^2 - (R^2 - h_obs^2));               % Transition distance in alternate scenario in metres
end
fprintf('The Climb Distance is %f m. \n',S_C);
fprintf('The Transition Distance is %f m. \n',S_TR);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho = 1.225;                                % Air density in kg/m^3
V_1 = 0;                                    % This is the starting velocity which is 0 m/s
V_2 = V_LOF;                                % Lift off velocity
mu = 0.05;                                  % Friction coefficient of tarmac
K_T = (T/W_to) - mu;                        % A constant
C_LTO = Cl0;                                % Lift coefficient during take-off
K_A = (rho/(2 * W_to/S)) * ((mu * C_LTO) - Cd0_takeoff - ((C_LTO)^2/(pi * AR * e))); 

S_G = (1/(2*g*K_A))*log((K_T + K_A*(V_2)^2)/(K_T + K_A*(V_1)^2));  % This is the Ground distance in metres
fprintf('The Ground Distance is %f m. \n',S_G);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_to = 1.15*(S_R + S_G + S_C + S_TR);  % This gives the final take-off distance in metres
fprintf('The total Takeoff Distance is %f m. \n',S_to);
end