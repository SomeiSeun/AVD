function [S_L] = Landing_distance(Cl0, Cl_alpha, V_S1, W_L, VS0, T_L, L_over_D, S, AR, e)

% This function is used to find the Landing distance for the aircraft. 

% The INPUTS are: (ALL SI UNITS)
% Cl0 is the lift coefficient at 0 AOA
% Cl_alpha is the 3D lift curve slope
% V_S1 is the stall speed in clean config in m/s
% W_L is the weight of aircraft at start of landing approach in Newtons
% VS0 is the stall speed in landing config in m/s
% T_L is the thrust at start of landing approach in Newtons
% L_over_D is the Lift to drag ratio at start of landing approach
% S is the wing reference are in m^2
% AR is the Aspect Ratio
% e is the Oswald Efficiency

% The OUTPUTS are: (ALL SI UNITS)
% S_L is the landing distance in metres

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h_obs = 50*0.3048;                                 % Obstacle height according to FAR 25 being converted to metres
g = 9.81;                                          % Gravitational Acceleration
n = 1.2;                                           % Load factor during landing approximately
R = (1.15^2 * V_S1^2) / ((n - 1)*g);               % Gives the radius of rotation
theta_approach = arcsin((1/L_over_D) - (T_L/W_L)); % Gives the theta approach angle. Also initially can be assumed to be 3 deg
h_f = R * (1 - cos(theta_approach));               % Gives the flare height

S_a = (h_obs - h_f) / (tan(theta_approach));       % This gives the approach distance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_F = R * sin(theta_approach);       % This gives the Flare distance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_FR = 3 * 1.1*VS0;                  % This gives the free roll distance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
rho = 1.225;                         % Density of air in kg/m^3
V2 = 0;                              % Velocity when the plane has stopped
V1 = 1.1 * VS0;                      % Touchdown velocity
mu = 0.05;                           % Friction coefficient of tarmac
K_T = (T_L / W_L) - mu;              % A constant
C_LTO = Cl0 + Cl_alpha * alpha_T0;   % Lift coefficient during take-off
K_A = (rho / (2*W_L/S)) * ((mu * C_LTO) - Cd0 - ((C_LTO)^2 / (pi * AR * e))); 

S_B = (1 / (2 * g * K_A)) * ln((K_T + (K_A * V2^2)) / (K_T + (K_A * V1^2)));  % This gives the braking distance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_L = 1.666 * (S_a + S_F + S_FR + S_B);     % Gives the Total Landing Distance in metres

end