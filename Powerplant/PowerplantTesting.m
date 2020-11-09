%% Powerplant sizing

% This script would be used to size the powerplant and can later be
% converted into a function in order to be used when merged with the main
% script.

%% Housekeeping

clear
clc

%% Get data from initial sizing and sizing to constraints

W0 = 155585*9.81;
TW_0_Required = 0.36;

%% Do the thing
Thrust_Required = TW_0_Required * W0;
disp(['The required thrust (assuming no losses) is: ', num2str(round(Thrust_Required)), ' N'])