function[] = GimmeTiresRaymer()
% This function will run through the entire database of tires available and
% select the ones which satisfy the load requirements and then pick the one
% with the smallest dimensions from those.
clear
clc
close all
%% Load entire database
load('Wheels_Radial.mat');
load('Wheels_Three Part.mat');
load('Wheels_Type III.mat');
load('Wheels_Type VII.mat');

LoadReq = 22000/1;

%% Find the smallest wheel that fits load requirements from each database
Radial_Index = find(Radial_RatedLoadLbs > LoadReq);
Radial_MinDiam = find(min(Radial_OutsideDiamMaxGrown(Radial_Index)));
A = Radial_Index(Radial_MinDiam);

ThreePart_Index = find(ThreePart_RatedLoadLbs > LoadReq);
ThreePart_MinDiam = find(min(ThreePart_OutsideDiameterMax(ThreePart_Index)));
B = ThreePart_Index(ThreePart_MinDiam);

Type3_Index = find(Type3_RatedLoadLbs > LoadReq);
Type3_MinDiam = find(min(Type3_OutsideDiamMax(Type3_Index)));
C = Type3_Index(Type3_MinDiam);

Type7_Index = find(Type7_RatedLoadLbs > LoadReq);
Type7_MinDiam = find(min(Type7_OutsideDiamMax(Type7_Index)));
D = Type7_Index(Type7_MinDiam);

%% Find data for each wheel
BestWheels(1) = [Radial_Size(A), Radial_RatedInflationPSI(A), Radial_OutsideDiamMaxGrown(A)];
BestWheels(2) = [ThreePart_Size(B), ThreePart_RatedInflationPSI(B), ThreePart_OutsideDiameterMax(B)];
BestWheels(3) = [Type3_Size(C), Type3_RatedInflationPSI(C), Type3_OutsideDiamMax(C)];
BestWheels(4) = [Type7_Size(D), Type7_RatedInflationPSI(D), Type7_OutsideDiamMax(D)];
BestWheels;





end