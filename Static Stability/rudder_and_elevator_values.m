% Creating a script with all the selected values for the elevator and rudder

clear
clc

% Importing the correct .mat file
load('tailplaneSizing.mat', 'cBarHoriz', 'spanHoriz', 'cBarVert', 'heightVert');
load('../Aerodynamics/wingDesign.mat', 'root_chord', 'b');

% Assigning those values to variables below

elevator_avg_chord = 0.2 * cBarHoriz;                       % Average Elevator chord in m 
elevator_span = 0.9 * spanHoriz * 0.5;                      % Elevator half span in m
elevator_max_def = 15;                                      % In degrees
elevator_area = elevator_span * elevator_avg_chord * 2;     % Total area of the elevator

rudder_avg_chord = 0.2 * cBarVert;                          % Average Rudder chord in m      
rudder_span = 0.9 * heightVert;                             % Rudder half span in m
rudder_max_def = 18.75;                                     % In degrees
rudder_area = rudder_span * rudder_avg_chord * 2;           % Total area of the rudder

% Finding out the area for the aileron
y1 = 0.6 * b * 0.5;  % Starting position for the aileron
y2 = 0.9 * b * 0.5;  % Ending position for the aileron
n = 201;
chord_distribution = linspace(0.6,0.9,n); % Chord distribution array of values

area = zeros(1,n);   % Setting up the array for area

for i = 1 : n
    area(i) = (0.3 * b * 0.5 *...
        0.2 * chord_distribution(i) * 0.38 * root_chord) / 201;
end
aileron_area = sum(area) * 2;     % Finding the total area for the 2 ailerons in m^2

filename = 'rudder_and_elevator_values.mat' ;
save(filename, 'elevator_avg_chord', 'elevator_span', 'elevator_max_def',...
    'rudder_avg_chord', 'rudder_span', 'rudder_max_def', 'aileron_area', 'rudder_area',...
    'elevator_area');
