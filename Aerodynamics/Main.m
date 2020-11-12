clear
clc 
close all 
% This script will bring together all functions and output key aerodynamic
% parameters: maximum lift coefficient, lift curve slope and zero lift
% angle of attack.

%load data 
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')

%Define velocities and mach no for take-off and landing
rho_takeoff=1.225;
rho_landing=1.225;
V_takeoff=65.71;
V_landing=77.66;
M_takeoff=V_takeoff/sqrt(1.4*287*288.2);
M_landing=V_landing/sqrt(1.4*287*288.2);
%% Lift Aerodynamic Analyis: 
%Lift Curve Slope for Main Wing:
%[CL_a]=LCS(AR,S_exposed,S_ref,d,b,M,sweepanglemax,Cl_am);
%Lift Curve Slope for Horizontal Tail:
%[CL_ah]=HLCS(AR,S_exposed,S_ref,d,b,M,sweepanglemax,Cl_am);
%Lift Curve Slope for Vertical Tail:
%[CL_av]=HLCS(AR,S_exposed,S_ref,M,sweepanglemax,Cl_am);
%Maximum Lift Coefficient for Clean and HLD configuration:
%[CL_max_clean_wing,delta_CL_max_wing, delta_alpha_zero_wing]=MaxLift(Cl_max,sweep_quarterchord,S_flapped,S_ref,sweep_HLD,Cl_alpha);
%Maximum Lift Coefficient for Horizontal Tail:
%[CL_max_clean_horizontal,delta_CL_max_horizontal, delta_alpha_zero_horizontal]=MaxLift(Cl_max,sweep_quarterchord,S_flapped,S_ref,sweep_HLD,Cl_alpha);
%Maximum Lift Coefficient for Vertical Tail:
%[CL_max_clean_vertical,delta_CL_max_vertical, delta_alpha_zero_vertical]=MaxLift(Cl_max,sweep_quarterchord,S_flapped,S_ref,sweep_HLD,Cl_alpha);
%% Skin Friction, Form and Interference Drag
%Determine the Parasitic Drag Component:
%[CD_Parasitic]=Parasitic(rho,v,l,nu,M,xtocmax,ttoc,theta_max,d,S_wet,Sref)
[CD_Parasitic_fuselage,Cf_fuselage,f,FF]=Parasitic(rho_cruise,V_Cruise,50.1352,0.0000144446,M_Cruise,0,0,0,5.699482,662.2702,Sref);
[CD_Parasitic_takeoff_fuselage]=Parasitic(rho_takeoff,V_takeoff,50.1352,0.0000181206,M_takeoff,0,0,0,5.699482,662.2702,Sref);
[CD_Parasitic_landing_fuselage]=Parasitic(rho_landing,V_landing,50.1352,0.0000181206,M_landing,0,0,0,5.699482,662.2702,Sref);
%Determine the Miscellaneous Drag Component: 
[C_Duc_takeoff,C_Dflaps_takeoff,C_Dwe_takeoff,C_Dfu_takeoff]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta);
[C_Duc_cruise,C_Dflaps_cruise,C_Dwe_cruise,C_Dfu_cruise]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta);
[C_Duc_landing,C_Dflaps_landing,C_Dwe_landing,C_Dfu_landing]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta);
%Determine component of drag due to leakages and protuberances:
[CD_LandP]= LandP(CD_Parasitic);
%Sum three components above to give total subsonic drag.
CD_0= CD_Parasitic+CD_Misc+CD_LandP;
%% Total Aircraft Drag
%CD_0+K[CL_a*(Alpha+wing_setting-alpha_zero_wing)]^2+eta_h*(Sh/sref)*Kh*Clh^2

%% Stall Analysis (calculates stall speed at take-off, cruise, approach and landing.) 
%[Vstall_TO]= StallAnalysis(W/S,rho,Clmax);
%[Vstall_Cruise]= StallAnalysis(W/S,rho,Clmax);
%[Vstall_Landing]= StallAnalysis(W/S,rho,Clmax);
