%function[] = WingShape()
% This function provides important characteristics of the wing based on
% inputs taken from the wing code.
clear
clc
close all

% Inputs
fuselage_radius = 4.7/2;
root_chord = 7.4505;
root_setting_angle = 2.2;
dist_along_wing = 3;
sweep_angle = 20;

% Placing the reference wing root with respect to fuselage centreline
x.wing.referenceRoot = 36; % from weight and balance
z.wing.referenceRoot = - fuselage_radius + (0.75*root_chord*sind(root_setting_angle));

% Placing undercarriage assuming straight wing
x.ucJoint = x.wing.referenceRoot;
y.ucJoint = dist_along_wing; % Along the wing
z.ucJoint = z.wing.referenceRoot;

% Accounting for sweepback
x.ucJoint = x.ucJoint + dist_along_wing*sind(sweep_angle);
y.ucJoint = 












%end