function [S_L] = Landing_distance(Cl0, V_S1, W_L, VS0, T_L, L_over_D, S, AR, e, CD0)

% This function is used to find the Landing distance for the aircraft. 

% The INPUTS are: (ALL SI UNITS)
% Cl0 is the lift coefficient at 0 AOA
% V_S1 is the stall speed in clean config in m/s
% W_L is the weight of aircraft at start of landing approach in Newtons
% VS0 is the stall speed in landing config in m/s
% T_L is the thrust at start of landing approach in Newtons
% L_over_D is the Lift to drag ratio at start of landing approach
% S is the wing reference area in m^2
% AR is the Aspect Ratio
% e is the Oswald Efficiency
% CD0 is the Zero Lift Drag Coefficient

% The OUTPUTS are: (ALL SI UNITS)
% S_L is the landing distance in metres

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_obs = 50*0.3048;                                 % Obstacle height according to FAR 25 being converted to metres
g = 9.81;                                          % Gravitational Acceleration
n = 1.2;                                           % Load factor during landing approximately
R = (1.15^2 * VS0^2) / ((n - 1)*g);                % Gives the radius of rotation
%theta_approach = asin((1/L_over_D) - (T_L/W_L))   % Gives the theta approach angle. Also initially can be assumed to be 3 deg 
theta_approach = 3 * pi / 180; 
h_f = R * (1 - cos(theta_approach));               % Gives the flare height

S_a = (h_obs - h_f) / (tan(theta_approach));       % This gives the approach distance
fprintf('The Approach Distance is %f m. \n',S_a);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_F = R * sin(theta_approach);       % This gives the Flare distance
fprintf('The Flare Distance is %f m. \n',S_F);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_FR = 3 * 1.1 * VS0;                % This gives the free roll distance
fprintf('The Free Roll Distance is %f m. \n',S_FR);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho = 1.225;                         % Density of air in kg/m^3
V2 = 0;                              % Velocity when the plane has stopped
V1 = 1.1 * VS0;                      % Touchdown velocity
mu = 0.05;                           % Friction coefficient of tarmac
K_T = (T_L / W_L) - mu;              % A constant
C_LTO = Cl0;                         % Lift coefficient during Landing
K_A = (rho / (2*W_L/S)) * ((mu * C_LTO) - CD0 - ((C_LTO)^2 / (pi * AR * e)));

S_B = abs((1 / (2 * g * K_A)) * log((K_T + (K_A * V2^2)) / (K_T + (K_A * V1^2)))); % This gives the braking distance
fprintf('The Braking Distance is %f m. \n',S_B);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_L = 1.666 * (S_a + S_F + S_FR + S_B);     % Gives the Total Landing Distance in metres
fprintf('The Total Landing Distance is %f m. \n',S_L);
end