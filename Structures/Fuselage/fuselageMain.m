%% Chai-liner Fuselage design code
% Written by Tanmay Ubgade | 201109
%% Housekeeping
clear all
clc

%% Values from CAD, All values in SI unless specified otherwise

% Diameters 
wallThicknessIn = 8; % in inches
wallThickness = wallThicknessIn*2.54/100;
fusDiamOuterfeet = 13.7; % in feet
fusDiamOuter = fusDiamOuterfeet*12*2.54/100; % in m
fusDiamInner = fusDiamOuter-wallThickness;

% Front
frontFR = 1.4;
frontLength = 1.4*fusDiamOuter;

noseLength = 1.35;
noseRadius = 0.816;
noseArea = 5.046;

cockpitLength = 2.58;
cockpitArea = 48.777;
entranceLength = 1.92;

%frontLength2 = noseLength + cockpitLength + entranceLength;
frontArea = noseArea + cockpitArea;



% Main
mainLength = 35.538; 
mainArea = 479.325;

% Aft
aftFR = 2;
aftLength = aftFR*fusDiamOuter;
aftArea = 0.589 + 81.371;

% Total
totalLength = frontLength + aftLength + mainLength;
totalArea = noseArea + mainArea + aftArea;

save fuselageOutputs