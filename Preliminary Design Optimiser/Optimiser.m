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

%load('../Initial Sizing/InitialSizing.mat')
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')
load('../Static Stability/tailplaneSizing.mat')
load('../Aerodynamics/Unknowns.mat')                                        % This is just a bunch of values I am waiting on
load('../Structures/Fuselage/fuselageOutputs.mat')      

%% Assumed values for now

%For aerodynamics analysis
l=[MAC,fuselage_length,nacelle_length,H_MAC,V_MAC];
xtocmax=[xtocmax_wing,0,0,0.3,0.3];
ttoc=[Airfoil_ThicknessRatio_used,0,0,0.12,0.12];
theta_max=[Sweep_maxt,0,0,27,27];
S_wet_all=[S_wetted,606,60,0,0];
flapped_ratio=0.487;
chord_ratio=1.26;
Sweep_TE=20.9647;
upsweep_angle=15*(pi/180);
Cl_tail_airfoil=1.4;
%% Optimiser loop
% Aerodynamic Lift- lift curve slope and clmax for clean config determined. HLD effects remain
% but as values are updated/changed, outputs below should change :)                                                    
[CL_a,CL_max_clean,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
[CL_ah,CL_max_h]=TailLift(ARhoriz,d,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
[maxLiftLanding,maxLiftTakeoff]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_h,SHoriz,Sref,rho_landing,V_landing,rho_takeoff,V_takeoff);
[CL_a_M0]=WingLift(AspectRatio,S_exposed,Sref,d,b,0,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
%Aerodynamic Drag (Cruise Conditions)
[C_Duc_cruise,C_Dflaps,C_Dwe_cruise,C_Dfu_cruise,CD_misc]=MiscD(Area_ucfrontal,Sref,flapspan,b,flap_deflection_takeoff,flap_deflection_landing,Aeff,d,upsweep_angle);
[CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
CD_Parasitic_Total=[CD_Parasitic_Total_Takeoff,CD_Parasitic_Total_Cruise,CD_Parasitic_Total_Landing];
CD_LandP_Total=[CD_LandP_Takeoff,CD_LandP_Cruise,CD_LandP_Landing];
C_D0=CD_Parasitic_Total+CD_misc+CD_LandP_Total;
[CD_i,CD_Total]=TotalDrag(AspectRatio,ARhoriz,CL_a,i_w_approx,SHoriz,Sref,C_D0);
% Wing Design
% Fuselage
% Engine
% Performance
%[] = undercarriage()

%% Once everything converges, populate the csv
save('AerodynamicsFINAL.mat','CL_a_Total','CL_ah','CL_a_M0','CL_max_clean','delta_alpha_takeoff','delta_alpha_landing','delta_CL_max','CL_max_takeoff','CL_max_landing','CL_max_h','CD_Total','zeroAlphaLCT','maxLiftLanding','maxLiftTakeoff')
% write values to csv
% for fusion

%% Evaluate how good the design is