%% Undercarriage v2

%{
This code is an improved version which solves the issues that the previous
one left unnoticed. It should again be able to take inputs regarding
various different geometries and output (or warn the impossibility of) an
undercarriage that passes each constraint applied on it.
%}

%% Housekeeping
clear
clc
close all

%% Request inputs

% Initial sizing code
load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF6')

% Wing design / aerodynamics
x.wingroot = 30;
z.wingroot = -2;
theta.sweepRearSpar = 25;
theta.dihedral = 5;
theta.setting = 2.2;
