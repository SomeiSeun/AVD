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
load('../Aerodynamics/Unknowns.mat') 
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')
load('../Static Stability/tailplaneSizing.mat')
load('../Static Stability/stabilityAndTrim.mat')
                                                                                % This is just a bunch of values I am waiting on
load('../Structures/Fuselage/fuselageOutputs.mat')      

%% Assumed Values

%For aerodynamics analysis
l=[MAC,totalLength,8,cBarHoriz,cBarVert];
xtocmax=[0.349,0,0,maxThicknessLocationHoriz,maxThicknessLocationVert];
ttoc=[Airfoil_ThicknessRatio_used,0,0,thicknessRatioHoriz,thicknessRatioVert];
theta_max=[Sweep_maxt,0,0,sweepHorizMT,sweepVertMT];
S_wet_all=[S_wetted,totalArea,90,SHorizWetted,SVertWetted];
Aeff=0;
Area_ucfrontal=0;
nacelle_length=8;
nacelle_diameter=4;
flapped_ratio=0.487;
Cl_tail_airfoil=1.4;
%% Optimiser loop

%Aerodynamics: Lift
[CL_a,CL_max_clean,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
[CL_a_M0]=WingLift(AspectRatio,S_exposed,Sref,d,b,0,Sweep_maxt,Cl_am,flap_deflection,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
[CL_ah,CL_max_h]=TailLift(ARhoriz,d,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
[maxLiftLanding,maxLiftTakeoff,AoA_Stall_Wing_Clean,AoA_Stall_Tail_Clean]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_clean,CL_a,CL_ah,CL_max_h,SHoriz,Sref,rho_landing,V_landing,rho_takeoff,V_takeoff);

%Aerodynamics: Drag 
[CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,Sref,flapspan,b,flap_deflection_takeoff,flap_deflection_landing,Aeff,fusDiamOuter,upsweep_angle);
[CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing);
[CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,Sref,CD_0_Total,rho_landing,V_landing,AspectRatio);
[V_Stall_Landing]=StallSpeed(W0,WF1,WF2,WF3,WF4,WF5,WF6,CL_max_landing,rho_landing,Sref);

% Wing Design


% Fuselage
% Engine
% Performance
%[] = undercarriage()

%% Once everything converges, populate the csv
save('AerodynamicsFINAL.mat','CL_a_Total','CL_ah','CL_a_M0','CL_max_clean','delta_alpha_takeoff','delta_alpha_landing','delta_CL_max','CL_max_takeoff','CL_max_landing','CL_max_h','zeroAlphaLCT','maxLiftLanding','maxLiftTakeoff','CD_0_Total','CD_Total','Drag_Landing','LtoDMax','CD_min','V_Stall_Landing')
% write values to csv
% for fusion

%% Evaluate how good the design is