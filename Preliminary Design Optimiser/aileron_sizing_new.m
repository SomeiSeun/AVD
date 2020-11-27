function [t, Max_ail_def] = aileron_sizing_new(b, S, AR, lamda, C_L_aw, Vs, Ixx, S_w, S_ht, S_vt)

% This function is used to size the aileron. 

% The INPUTS are: (ALL SI UNITS)
% b is the wing span in m
% S is the wing reference area in m^2
% AR is the Aspect Ratio
% lamda is the Taper Ratio
% C_L_aw is lift curve slope for the wing
% Vs is the stall speed during landing approach in m/s
% Ixx is the second moment of area of the aircraft in m^4
% S_w is the wing planform area in m^2
% S_ht is the horizontal tail planform area in m^2
% S_vt is the vertical tail planform area in m^2 

% The OUTPUTS are: (ALL SI UNITS)
% t is the time taken by the aircraft to achieve bank angle in seconds
% Max_ail_def is the maximum aileron deflection in degrees

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho = 1.225;         % Density of air at sea level in kg/m^3
tau = 0.4;           % Aileron effectiveness parameter (Depends on the chord ratio of aileron to wing. In Control surface word document)
y1 = 0.6 * b / 2;    % Setting the starting position for the aileron
y2 = 0.9 * b / 2;    % Setting the ending position for the aileron
C_bar = b / AR;      % Finding out the variable to be used in line below

C_r = 1.5 * C_bar * ((1 + lamda) / (1 + lamda + lamda^2));    % Finding out variable Cr to be used in equation below

C_l_delta_A = ((2 * C_L_aw * tau * C_r) / (S * b)) *... 
    ((((y2^2) / 2) + 2 * y2^3 * (lamda - 1) / (3 * b)) - ((y1^2) / 2) + 2 * (y1^3) * (lamda - 1) / (3 * b)); 
% ^ Finding out the Aileron Rolling Moment Coefficient

delta_A = 0.75 * 20 * pi / 180;  % Max deflection angle is 20 deg for aileron, then multiplied by 0.75 since Control systems cannot stretch so much
Max_ail_def = delta_A * 180 / pi;
C_l = C_l_delta_A * delta_A;     % Finding out the Aircraft Rolling Moment Coefficient

V_app = 1.3 * Vs;                           % Approach velocity during landing
L_A = 0.5 * rho * (V_app^2) * S * C_l * b;  % Gives the Aircraft Rolling moment when aileron has maximum deflection

C_DR = 0.9;          % Average value of 0.9 is selected for horizontal wing, vertical tail and tail rolling drag coefficient
y_D = (0.4 * b) / 2; % Drag moment arm is assumed to be 40% of wing span  ??????? FIND OUT ABOUT THIS

P_ss = sqrt((2 * L_A) / (rho * (S_w + S_ht + S_vt) * C_DR * (y_D^3))); % Finding out the Steady-state roll rate in rad/sec

bank_angle = (Ixx / (rho * (y_D^3) * (S_w + S_ht + S_vt) * C_DR)) * ln(P_ss^2); % Gives the bank angle at which aircraft achieves steady roll rate

P_dot = (P_ss^2) / (2 * bank_angle); % Finding out the aircraft rate of roll 

t = sqrt((2 * 30) / P_dot); % Finding out the time taken for the aircraft to achieve the time to bank.
% This value decided if the aileron size needs to be changed or not
% So this value of t must be less than 2.5 seconds in the case of this
% aircraft

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end