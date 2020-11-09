function [C_lp, C_l_delta_a, p] = aileron_sizing(b, S, c, c_f, def_angle, C_lalpha, C_d0, V, c_l_delta_a)

% The INPUTS are:
% b is the wing span (m)
% S is the wing area (m^2)
% c is the wing chord (m)
% c_f is the chord size of the aileron (Take this as about 0.25 of the wing
% cross section)
% def_angle is the max deflection angle of the aileron in degrees
% C_lalpha is the Lift curve slope
% C_d0 is the Zero AOA drag coefficient
% V is the airspeed in m/s
% c_l_delta_a is the change in lift coefficient with aileron deflection
% ??? HOW WOULD WE INSERT THE VARIATION OF CHORD WITH RESPECT TO VARIABLE Y
% IN THIS FUNCTION????

% The OUTPUTS are:
% C_lp is the Rolling Moment Coefficient
% C_l_delta_p is the Aileron Authority Derivative
% p is the steady state roll rate in radians/second

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun = @(y) y.^2 * c(y);                           % Defining the function here to be integrated
q = integral(fun,0,b/2);                          % Doing the integration here between 0 and half span
C_lp = (-4 * (C_lalpha + C_d0) / (S * b^2))*q;    % Finding the Rolling moment coefficient here due to roll rate p

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b1 = 0.5*b/2;              % Defining the start of the aileron
b2 = 0.9*b/2;              % Defining the end of the aileron. These 2 values can be changed to size it appropriately
fun1 = @(y) y * c(y);                             % Defining the function here to be integrated
q1 = integral(fun1,b1,b2);                        % Doing the integration between b1 and b2
C_l_delta_a = ((2 * c_l_delta_a) /(S * b)) * q1;  % Finding the Aileron Authority Derivative

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

def_angle_rad = def_angle*pi/180;   % Converting the deflection angle from degrees to radians
p = (-C_l_delta_a * def_angle_rad * 2 * V) / (C_lp * b);  % Finding the steady state roll rate



end