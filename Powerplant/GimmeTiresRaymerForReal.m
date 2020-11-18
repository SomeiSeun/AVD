function[BestWheelType, BestWheelReferenceNumber, BestWheelRatedInflationPSI] = GimmeTiresRaymerForReal(LoadReq, OptimiseFor)
% Example: [BestWheelType, BestWheelReferenceNumber,
% BestWheelRatedInflationPSI] = GimmeTiresRaymerForReal(LoadReq,
% OptimiseFor) where:
    % LoadReq is the load required for that single wheel
    % OptimiseFor = 1 to find wheel with smallest diameter
    % OptimiseFor = 2 to find wheel with smallest width
% This function would sort tires that work for requested load and find the
% one with the smallest diameter. Can upgrade the code to find one with the
% smallest width instead using a simple boolean functionality.

%% Housekeeping (remove at the end)
clear
clc
close all

%% Hard coded for now
LoadReq = 45000;
OptimiseFor = 1; % 1 = Minimum diameter, 2 = minimum width

%% Load entire wheel database
load('Wheels_All.mat')

%% Find the wheels that fit load requirements
Index1 = find(RatedLoadLBS > LoadReq);

%% Based on optimising requirement, find wheel with smallest width or diam
if OptimiseFor == 1
    MinDiam = min(InflatedOuterDiamMaxINCH(Index1));
    Index2 = find(InflatedOuterDiamMaxINCH(Index1) == MinDiam);
    A = Index1(Index2);
    BestWheelReferenceNumber = ReferenceNumber(A);
    BestWheelRatedInflationPSI = RatedInflationPSI(A); 
    BestWheelType = TypeOfTire(A);
elseif OptimiseFor ==2
    MinWidth = min(InflatedSectionWidthMaxINCH(Index1));
    Index2 = find(InflatedSectionWidthMaxINCH(Index1) == MinWidth);
    A = Index1(Index2);
    BestWheelReferenceNumber = ReferenceNumber(A);
    BestWheelRatedInflationPSI = RatedInflationPSI(A);  
    BestWheelType = TypeOfTire(A);
end

end