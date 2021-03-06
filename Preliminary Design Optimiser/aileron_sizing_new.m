function [t, Max_ail_def, y1, y2, aileron_area] = aileron_sizing_new(b, S, AR, lamda,...
    C_L_aw, Vs, Ixx, S_w, S_ht, S_vt, starting_position, ending_position, root_chord)

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
% starting_position is the point at which the aileron starts (Must be in decimal)
% ending_position is the point at which the aileron ends (Must be in decimal)
% root_chord is the root chord of the main wing

% The OUTPUTS are: (ALL SI UNITS)
% t is the time taken by the aircraft to achieve bank angle in seconds
% Max_ail_def is the maximum aileron deflection in degrees
% y1 is the starting position of the aileron
% y2 is the ending position of the aileron
% aileron_area gives the total area of the aileron in m^2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rho = 1.225;                       % Density of air at sea level in kg/m^3
tau = 0.4;                         % Aileron effectiveness parameter 
y1 = starting_position * b / 2;    % Setting the starting position for the aileron
y2 = ending_position * b / 2;      % Setting the ending position for the aileron

chord_distribution = linspace(starting_position,ending_position,201); % Chord distribution
area = zeros(1,201);
for i = 1 : length(chord_distribution)
    area(i) = ((ending_position - starting_position) * b * 0.5 *...
        0.2 * chord_distribution(i) * 0.38 * root_chord) / 201;   
    i = i + 1;
end

aileron_area = sum(area) * 2;     % Finding the total area for the 2 ailerons
fprintf('The area of the aileron is %f m^2. \n',aileron_area);

C_r = root_chord;   % Root chord value

C_l_delta_A = ((2 * C_L_aw * tau * C_r) / (S * b)) *... 
    ((((y2^2) / 2) + 2 * y2^3 * (lamda - 1) / (3 * b)) - ((y1^2) / 2) + 2 * (y1^3) * (lamda - 1) / (3 * b)); 
% ^ Finding out the Aileron Rolling Moment Coefficient

delta_A = 0.75 * 20 * pi / 180;  % Max deflection angle is 20 deg for aileron, then multiplied by 0.75 since Control systems cannot stretch so much
Max_ail_def = delta_A * 180 / pi;
C_l = C_l_delta_A * delta_A;     % Finding out the Aircraft Rolling Moment Coefficient

V_app = 1.3 * Vs;                           % Approach velocity during landing
L_A = 0.5 * rho * (V_app^2) * S * C_l * b;  % Gives the Aircraft Rolling moment when aileron has maximum deflection

C_DR = 0.9;          % Average value of 0.9 is selected for horizontal wing, vertical tail and tail rolling drag coefficient
y_D = (0.4 * b) / 2; % Drag moment arm is assumed to be 40% of wing span

P_ss = sqrt((2 * L_A) / (rho * (S_w + S_ht + S_vt) * C_DR * (y_D^3))); % Finding out the Steady-state roll rate in rad/sec

bank_angle = (Ixx / (rho * (y_D^3) * (S_w + S_ht + S_vt) * C_DR)) * log(P_ss^2); % Gives the bank angle at which aircraft achieves steady roll rate

P_dot = (P_ss^2) / (2 * bank_angle); % Finding out the aircraft rate of roll 

angle_rad = 40 * pi /180;  % The rotation angle required

t = sqrt((2 * angle_rad) / P_dot); % Finding out the time taken for the aircraft to achieve the time to bank.
fprintf('The time taken for the aircraft to rotate 40 degrees is %f s. \n',t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end