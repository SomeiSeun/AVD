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
load('../Static Stability/tailplaneSizing.mat')
<<<<<<< HEAD
<<<<<<< HEAD
%>>>>>>> main
load('../Aerodynamics/Unknowns.mat')                                        % This is just a bunch of values I am still waiting on...
<<<<<<< HEAD
>>>>>>> main

=======
=======
=======
load('../Static Stability/stabilityAndTrim.mat')
>>>>>>> main
load('../Aerodynamics/Unknowns.mat')                                        % This is just a bunch of values I am waiting on
>>>>>>> main
load('../Structures/Fuselage/fuselageOutputs.mat')      
>>>>>>> main

%% Assumed Values

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
<<<<<<< HEAD
<<<<<<< HEAD
l=[MAC,fuselage_length,nacelle_length,H_MAC,V_MAC];
xtocmax=[xtocmax_wing,0,0,0.3,0.3];
ttoc=[Airfoil_ThicknessRatio_used,0,0,0.12,0.12];
theta_max=[Sweep_maxt,0,0,27,27];
S_wet_all=[S_wetted,606,60,0,0];
<<<<<<< HEAD
>>>>>>> main

=======
=======
l=[MAC,fuselage_length,nacelle_length,cBarHoriz,cBarVert];
xtocmax=[0.349,0,0,maxThicknessLocationHoriz,maxThicknessLocationVert];
ttoc=[Airfoil_ThicknessRatio_used,0,0,thicknessRatioHoriz,thicknessRatioVert];
theta_max=[Sweep_maxt,0,0,sweepHorizMT,sweepVertMT];
S_wet_all=[S_wetted,606,60,SHorizWetted,SVertWetted];
>>>>>>> main
=======
l=[MAC,totalLength,8,cBarHoriz,cBarVert];
xtocmax=[0.349,0,0,maxThicknessLocationHoriz,maxThicknessLocationVert];
ttoc=[Airfoil_ThicknessRatio_used,0,0,thicknessRatioHoriz,thicknessRatioVert];
theta_max=[Sweep_maxt,0,0,sweepHorizMT,sweepVertMT];
S_wet_all=[S_wetted,totalArea,90,SHorizWetted,SVertWetted];
>>>>>>> main
flapped_ratio=0.487;
chord_ratio=1.26;
Sweep_TE=20.9647;
upsweep_angle=15*(pi/180);
<<<<<<< HEAD
>>>>>>> main

=======
Cl_tail_airfoil=1.4;
>>>>>>> main
%% Optimiser loop

%Aerodynamics: Lift
[CL_a,CL_max_clean,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
[CL_a_M0]=WingLift(AspectRatio,S_exposed,Sref,d,b,0,Sweep_maxt,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,Sweep_quarterchord,Sweep_TE);
CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
[CL_ah,CL_max_h]=TailLift(ARhoriz,d,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
[maxLiftLanding,maxLiftTakeoff]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_h,SHoriz,Sref,rho_landing,V_landing,rho_takeoff,V_takeoff);

%Aerodynamics: Drag 
[CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,Sref,flapspan,b,flap_deflection_takeoff,flap_deflection_landing,Aeff,fusDiamOuter,upsweep_angle);
[CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing);
[CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,Sref,CD_0_Total,rho_landing,V_landing,AspectRatio);
[V_Stall_Landing]=StallSpeed(W0,WF1,WF2,WF3,WF4,WF5,WF6,CL_max_landing,rho_landing,Sref);

% Wing Design
% Fuselage
% Engine
% Undercarriage
Undercarriage(W0, WF6, x_cg_max, x_cg_min, y_cg, z_cg_max, z_cg_min, ...
    Length_ac, x_ng_min, x_fuse_tapers, AoA_liftoff, AoA_landing, ground_clearance, y_mg_max); % No meaningful outputs yet lol.

%% Once everything converges, populate the csv
save('AerodynamicsFINAL.mat','CL_a_Total','CL_ah','CL_a_M0','CL_max_clean','delta_alpha_takeoff','delta_alpha_landing','delta_CL_max','CL_max_takeoff','CL_max_landing','CL_max_h','zeroAlphaLCT','maxLiftLanding','maxLiftTakeoff','CD_0_Total','CD_Total','Drag_Landing','LtoDMax','CD_min','V_Stall_Landing')
% write values to csv
% for fusion

%% Evaluate how good the design is