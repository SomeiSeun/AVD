function [T_over_w, wo] = Take_off_constraint(runway_length, Clmax_takeoff,sigma)

% inputs:
% runway_length in m
% Clmax_takeoff 

% output
% an array of T_over_W for different W/S

% Converting the runway length in metres to feet
runway_length_ft = runway_length*1250/381;

% Finding out the Take off parameter in pounds per feet squared
TOP = runway_length_ft/37.5;

% Finding out the Take off parameter in N per metre squared
TOP_N_over_m_squared = TOP*9.81*4.88243;

% Creating an array for Wo/Sref (PLEASE CHANGE THIS IF YOU HAVE A BETTER METHOD)
wo = [0:10:12500];

T_over_w = wo./(Clmax_takeoff*TOP_N_over_m_squared*sigma);
end
