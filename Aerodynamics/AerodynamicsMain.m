clear
clc 
close all 
% This script will bring together all functions and output key aerodynamic
% parameters: maximum lift coefficient, lift curve slope and zero lift
% angle of attack.

%load data 
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')
load('../Static Stability/tailplane_Sizing_Variable_Values.mat')
%Define velocities and mach no for take-off and landing
rho_takeoff=1.225;
rho_landing=1.225;
V_takeoff=65.71;
V_landing=77.66;
M_takeoff=V_takeoff/sqrt(1.4*287*288.2);
M_landing=V_landing/sqrt(1.4*287*288.2);
%% Lift Aerodynamic Analyis: 
%Lift Curve Slope for Main Wing:
[CL_a_cruise]=LCS(AspectRatio,S_exposed,Sref,4.175556,b,M_Cruise,26,0);
[CL_a_takeoff]=LCS(AspectRatio,S_exposed,Sref,4.175556,b,M_takeoff,26,0);
[CL_a_landing]=LCS(AspectRatio,S_exposed,Sref,4.175556,b,M_landing,26,0);
%Lift Curve Slope for Horizontal Tail:
[CL_ah_landing]=LCS(AR_HT,S_HT_exposed,S_HT,4.175556,b_HT,M_landing,0,0);
[CL_ah_takeoff]=LCS(AR_HT,S_HT_exposed,S_HT,4.175556,b_HT,M_takeoff,0,0);
[CL_ah_cruise]=LCS(AR_HT,S_HT_exposed,S_HT,4.175556,b_HT,M_Cruise,0,0);
%Lift Curve Slope for Vertical Tail:
[CL_av_landing]=LCS(AR_VT,S_VT,S_VT,4.175556,b_VT,M_landing,0,0);
[CL_av_takeoff]=LCS(AR_VT,S_VT,S_VT,4.175556,b_VT,M_takeoff,0,0);
[CL_av_cruise]=LCS(AR_VT,S_VT,S_VT,4.175556,b_VT,M_Cruise,0,0);
%Maximum Lift Coefficient for Clean and HLD configuration:
[CL_max_clean_wing]=MaxLift(1.6,27,0,0,0);
[CL_max_HT]=MaxLift(1.4,34,0,0,0);
%Maximum Lift Coefficient for Horizontal Tail:
% [CL_max_clean_horizontal,~,~]=MaxLift(1.4,0,S_flapped,S_ref,sweep_HLD,Cl_alpha);
%Maximum Lift Coefficient for Vertical Tail:
%[CL_max_clean_vertical,delta_CL_max_vertical, delta_alpha_zero_vertical]=MaxLift(Cl_max,sweep_quarterchord,S_flapped,S_ref,sweep_HLD,Cl_alpha);
%% Skin Friction, Form and Interference Drag
%Determine the Parasitic Drag Component:
%[CD_Parasitic]=Parasitic(rho,v,l,nu,M,xtocmax,ttoc,theta_max,d,S_wet,Sref)
% [CD_Parasitic_fuselage,Cf_fuselage,f,FF]=Parasitic(rho_cruise,V_Cruise,50.1352,0.0000144446,M_Cruise,0,0,0,5.699482,662.2702,Sref);
% [CD_Parasitic_takeoff_fuselage]=Parasitic(rho_takeoff,V_takeoff,50.1352,0.0000181206,M_takeoff,0,0,0,5.699482,662.2702,Sref);
% [CD_Parasitic_landing_fuselage]=Parasitic(rho_landing,V_landing,50.1352,0.0000181206,M_landing,0,0,0,5.699482,662.2702,Sref);
%Determine the Miscellaneous Drag Component: 
% [C_Duc_takeoff,C_Dflaps_takeoff,C_Dwe_takeoff,C_Dfu_takeoff]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta);
% [C_Duc_cruise,C_Dflaps_cruise,C_Dwe_cruise,C_Dfu_cruise]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta);
% [C_Duc_landing,C_Dflaps_landing,C_Dwe_landing,C_Dfu_landing]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta);
%Determine component of drag due to leakages and protuberances:
% [CD_LandP]= LandP(CD_Parasitic);
%Sum three components above to give total subsonic drag.
% CD_0= CD_Parasitic+CD_Misc+CD_LandP;
%% Total Aircraft Drag
%CD_0+K[CL_a*(Alpha+wing_setting-alpha_zero_wing)]^2+eta_h*(Sh/sref)*Kh*Clh^2

%% Stall Analysis (calculates stall speed at take-off, cruise, approach and landing.) 
%[Vstall_TO]= StallAnalysis(W/S,rho,Clmax);
%[Vstall_Cruise]= StallAnalysis(W/S,rho,Clmax);
%[Vstall_Landing]= StallAnalysis(W/S,rho,Clmax);

save('AerodynamicsMain.mat','CL_a_cruise','CL_a_takeoff','CL_a_landing','CL_ah_cruise','CL_ah_takeoff','CL_ah_landing','CL_av_cruise','CL_av_takeoff','CL_av_landing','CL_max_clean_wing','CL_max_HT')