% Creating a script with all the selected values for the elevator and rudder

clear
clc

% Importing the correct .mat file
load('tailplaneSizing.mat', 'cBarHoriz', 'spanHoriz', 'cBarVert', 'heightVert');

% Assigning those values to variables below

elevator_avg_chord = 0.2 * cBarHoriz; % Average Elevator chord in m 
elevator_span = 0.9 * spanHoriz * 0.5;    % Elevator half span in m
elevator_max_def = 15;               % In degrees

rudder_avg_chord = 0.2 * cBarVert;   % Average Rudder chord in m      
rudder_span = 0.9 * heightVert;      % Rudder half span in m
rudder_max_def = 18.75;              % In degrees

filename = 'rudder_and_elevator_values.mat' ;
save(filename, 'elevator_avg_chord', 'elevator_span', 'elevator_max_def',...
    'rudder_avg_chord', 'rudder_span', 'rudder_max_def');