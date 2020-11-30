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
frontFR = 1.3;

frontLength = frontFR*fusDiamOuter;
%{
noseLength = 1.35;
noseRadius = 0.816;


cockpitLength = 2.58;

entranceLength = 1.92;

frontLength2 = noseLength + cockpitLength + entranceLength;
%}
cockpitArea = 48.777;
noseArea = 5.046;

%frontLength = 1.4*fusDiamOuter;

noseLength = 0.93;
noseRadius = 0.816;
noseArea = 3.823;

cockpitLength = 2.58;
cockpitArea = 48.996;
entranceLength = 1.92;

%frontLength2 = noseLength + cockpitLength + entranceLength;

frontArea = noseArea + cockpitArea;

% Main

mainLength = 36.506; 
mainArea = 479.325;

% Aft
aftLength = 12.60;
aftFR = aftLength/fusDiamOuter;
aftArea = 0.223 + 99.78;
aftDiameter = 0.7996;

% Total
totalLength = frontLength + aftLength + mainLength;
totalArea = frontArea + mainArea + aftArea;


save fuselageOutputs