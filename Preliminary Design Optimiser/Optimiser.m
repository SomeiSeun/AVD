%% Optimiser code

% This code would call on each individual member's codes and populate the
% .csv file based on results produced by each.

%% Housekeeping
clear
clc
close all

%% Get data

% This section would include all data required from initial sizing, etc as
% whole for multiple. E.g:

load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF6')


%% Assumed values for now

% Wing
% Fuselage
% Undercarriage
x_cg_max = 32;
x_cg_min = 30;
y_cg = 0;
z_cg_max = 3; 
z_cg_min = 2;
Length_ac = 60;
x_ng_min = 5;
x_fuse_tapers = 50;
AoA_liftoff = 15;
AoA_landing = 14;
ground_clearance = 1.5;
y_mg_max = 3;


%% Optimiser loop
% Aerodynamics
% Wing Design
% Fuselage
% Engine
% Undercarriage
Undercarriage(W0, WF6, x_cg_max, x_cg_min, y_cg, z_cg_max, z_cg_min, ...
    Length_ac, x_ng_min, x_fuse_tapers, AoA_liftoff, AoA_landing, ground_clearance, y_mg_max); % No meaningful outputs yet lol.

%% Once everything converges, populate the csv
% write values to csv
% for fusion

%% Evaluate how good the design is