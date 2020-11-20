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

<<<<<<< HEAD
load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF6')
=======
%load('../Initial Sizing/InitialSizing.mat')
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')
load('../Static Stability/tailplane_Sizing_Variable_Values.mat')
load('../Aerodynamics/Unknowns.mat')                                        % This is just a bunch of values I am still waiting on...
>>>>>>> main


%% Assumed values for now

<<<<<<< HEAD
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
=======
%For aerodynamics analysis
l=[MAC,fuselage_length,nacelle_length,H_MAC,V_MAC];
xtocmax=[xtocmax,0,0,0.3,0.3];
ttoc=[Airfoil_ThicknessRatio_used,0,0,0.12,0.12];
theta_max=[Sweep_maxt,0,0,27,27];
S_wet_all=[S_wetted,606,60,0,0];
>>>>>>> main


%% Optimiser loop
% Aerodynamic Lift- lift curve slope and clmax for clean config determined. HLD effects remain
% but as values are updated/changed, outputs below should change :)
[CL_a,CL_max_clean,CL_aflaps,delta_alpha_zero,delta_CL_max]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,Sflapped,Sweep_quarterchord,sweep_HLD,delta_alpha_zeroairfoil);
%Aerodynamic Drag (Cruise Conditions)
[C_Duc_cruise,C_Dflaps_cruise,C_Dwe_cruise,C_Dfu_cruise]=MiscD(Area_ucfrontal,Sref,flapspan,b,flapdeflection,Aeff,d,upsweep_angle);
[CD_Parasitic,CD_Parasitic_Total,CD_LandP,Re,Cfc]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
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