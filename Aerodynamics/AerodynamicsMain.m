clear
clc
close all 

%% Load Values
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')
load('tailplane_Sizing_Variable_Values.mat')
load('../Static Stability/tailplaneSizing.mat')
load('../Aerodynamics/Unknowns.mat')                                        % This is just a bunch of values I am still waiting on...
load('../Structures/Fuselage/fuselageOutputs.mat') 

%% Assumed Variables
l=[MAC,fuselage_length,nacelle_length,H_MAC,V_MAC];
xtocmax=[xtocmax_wing,0,0,0.3,0.3];
ttoc=[Airfoil_ThicknessRatio_used,0,0,0.12,0.12];
theta_max=[Sweep_maxt,0,0,27,27];
S_wet_all=[S_wetted,606,60,0,0];
flapped_ratio=0.487;
chord_ratio=1.26;
Sweep_TE=20.9647;
upsweep_angle=15*(pi/180);

%% Aerodynamic Lift Analyis 
[CL_a,CL_max_clean,CL_aflaps,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
[CL_ah,CL_max_h]=WingLift(AR_HT,S_HT_exposed,S_HT,d,b_HT,M,Sweep_maxth,Cl_am,0,Cl_tail_airfoil,0,Sweep_quarterchord_HT,0);
[CL_a_M0]=WingLift(AspectRatio,S_exposed,Sref,d,b,0,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
%% Aerodynamic Drag (Cruise Conditions)
[C_Duc_cruise,C_Dflaps_takeoff,C_Dflaps_landing,C_Dwe_cruise,C_Dfu_cruise]=MiscD(Area_ucfrontal,Sref,flapspan,b,flap_deflection_takeoff,flap_deflection_landing,Aeff,d,upsweep_angle);
[CD_Parasitic,CD_Parasitic_Total,CD_LandP,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
%% Total Aircraft Drag
%CD_0+K[CL_a*(Alpha+wing_setting-alpha_zero_wing)]^2+eta_h*(Sh/sref)*Kh*Clh^2
%% Stall Analysis (calculates stall speed at take-off, cruise, approach and landing.) 
%[Vstall_TO]= StallAnalysis(W/S,rho,Clmax);
%[Vstall_Cruise]= StallAnalysis(W/S,rho,Clmax);
%[Vstall_Landing]= StallAnalysis(W/S,rho,Clmax);
