function [BFL] = Balanced_Field_Length(W_to, S, Cl_max_takeoff,...
    T_oei, D2, BPR, CL_max_landing, T_takeoff_static)

% This function is used to find the Balanced Field Length of the aircraft.

% The inputs are: (ALL SI UNITS)
% W_to is the Take off weight in Newtons
% S is reference wing area in m^2
% Cl_max_takeoff is the max lift coefficient in take off config
% T_oei is the thrust at OEI in Newtons
% D2 is the drag (Newtons) at V2 (m/s) which is the velocity at obstacle height 
% BPR is the bypass ratio of the turbofan engine
% CL_max_landing is the max lift coefficient in landing configuration
% T_takeoff_static is the maximum static thrust in Newtons 

% The outputs are: (ALL SI UNITS)
% BFL is the Balanced Field Length in Metres

% Doing some unit covnersions
W_to_lbs = W_to * 0.224809;                         % Converting mass from kg to pound force
S_ft = S * 10.7639;                                 % Converting wing area from m^2 to ft^2
T_oei_lbf = T_oei * 0.224809;                       % Converting OEI Thrust from Newton to Pound force
T_takeoff_static_lbf = T_takeoff_static * 0.224809; % Converting Max static thrust from Newton to Pound force
D2_lbf = D2 * 0.224809;                             % Converting Drag force from Newton to Pound Force

g = 32.174;                                         % Values of gravitational acceleration in ft/m^2

h_obs = 35;                                         % This is the obstacle height in feet

rho = 0.0023768924;                                 % This is the air density at Sea Level in slugs/ft^3

gamma_2min = 0.024;                                 % Some constant for 2 engines

sqrt_sigma = 1;                                     % Ratio of densities square rooted

U = (0.01 * Cl_max_takeoff) + 0.02;                 % Just some other constant

gamma_2 = asin((T_oei_lbf - D2_lbf) / (W_to_lbs));  % Again another constant

G = gamma_2 - gamma_2min;                           % Another constant

T_bar = (0.75 * T_takeoff_static_lbf) * ((5+BPR) / (4+BPR)); % Another constant

BFL_feet = (0.863 / (1 + (2.3 * G))) * (((W_to_lbs / S_ft) / (rho * g * 0.694 * CL_max_landing))...
    + h_obs) * ((1 / ((T_bar / W_to_lbs) - U)) + 2.7) + (655 / sqrt_sigma);

% The above equation gives the Balanced Field Length in feet. So need to
% convert it which is done below

BFL = BFL_feet * 0.3048;
fprintf('The Balanced Field Length is %f m. \n',BFL);
end