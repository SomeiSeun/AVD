% Test script for new tire selection method

% Housekeeping
clear
clc
close all

% Load data
load('Wheels_All_Table.mat')
minLoad = 80000;
maxDiam = 50;
maxPSI = 200;

% Remove all wheels that don't meet minimum load criteria
toRemove = WheelsAll.RatedLoadLBS < minLoad;
WheelsAll(toRemove, :) = [];

% Remove all wheels that have too high a tire pressure
toRemove = WheelsAll.RatedInflationPSI > maxPSI;
WheelsAll(toRemove, :) = [];

% Remove all wheels that are too big
toRemove = WheelsAll.InflatedOuterDiamMaxINCH > maxDiam;
WheelsAll(toRemove, :) = [];

% Check if any wheels still satisfy the requirements
if size(WheelsAll) == [0 23]
    
    % Which means no wheels available
    Wheel = 0;
    
else
    
    % Sort successful wheels by diameter
    sortrows(WheelsAll, 9);

    % Pick the first wheel
    Wheel = WheelsAll(1,:);

end