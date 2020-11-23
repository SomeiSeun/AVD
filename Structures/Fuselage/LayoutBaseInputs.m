% Tanmay Uvgade 201120
% housekeeping
clear
clc

% Values decided by ourselves

% All data is in inches unless stated otherwise

% Seating 
seatWidth = 17.5;
seatPitch = 31;
seatHeight = 42;
row2Seater = 41;
row3Seater = 60.5;
aisleWidth = 18;
aisleHeight = 80;
systemsSpaceTop = 10; % in cm
headroom = 66;
lavSize = 1; % in m

% Main body dimensions
fusDiamOuter = 13.7*12; 
fusDiamInner = 13.7*12 - 8;
wallThickness = 4;
floorThickness = 0.05*fusDiamOuter;

% Front and Aft body
frontFR = 1.3;
aftFR = 2; 

save FuselageInput