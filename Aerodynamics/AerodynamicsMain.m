load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat')
load('../Static Stability/tailplaneSizing.mat')
load('../Static Stability/stabilityAndTrim.mat')
load('../Aerodynamics/Unknowns.mat')                                        % This is just a bunch of values I am waiting on
load('../Structures/Fuselage/fuselageOutputs.mat')      

%% Assumed Values
nacelle_length=5.5;
%For aerodynamics analysis
l=[MAC,totalLength,nacelle_length,cBarHoriz,cBarVert];
xtocmax=[0.349,0,0,maxThicknessLocationHoriz,maxThicknessLocationVert];
ttoc=[Airfoil_ThicknessRatio_used,0,0,thicknessRatioHoriz,thicknessRatioVert];
theta_max=[Sweep_maxt,0,0,sweepHorizMT,sweepVertMT];
S_wet_all=[S_wetted,totalArea,75,SHorizWetted,SVertWetted];
upsweep_angle=15*(pi/180);
Cl_tail_airfoil=1.4;
%% Optimiser loop

%Aerodynamics: Lift
[CL_a,CL_max_clean,alpha_zero_takeoff,alpha_zero_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(AspectRatio,S_exposed,Sref,fusDiamOuter,b,M,Sweep_maxt,Cl_am,flap_deflection,Cl_wing_airfoil,Sflapped_over_Sref,Sweep_quarterchord,Sweep_TE);
[CL_a_M0]=WingLift(AspectRatio,S_exposed,Sref,fusDiamOuter,b,0,Sweep_maxt,Cl_am,flap_deflection,Cl_wing_airfoil,Sflapped_over_Sref,Sweep_quarterchord,Sweep_TE);
CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
[CL_ah,CL_max_h]=TailLift(ARhoriz,d,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
[maxLiftLanding,maxLiftTakeoff,AoA_Stall_Wing,AoA_Stall_Tail]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_clean,CL_a_Total,CL_ah,CL_max_h,SHoriz,Sref,rho_landing,V_landing,rho_takeoff,V_takeoff,alpha_zero_takeoff,alpha_zero_landing);

%Aerodynamics: Drag 
[CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
[CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,Sref,flapspan,b,flap_deflection_takeoff,flap_deflection_landing,Aeff,fusDiamOuter,upsweep_angle);
[CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing);
[CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,Sref,CD_0_Total,rho_landing,V_landing,AspectRatio);
[V_Stall_Landing]=StallSpeed(W0,WF1,WF2,WF3,WF4,WF5,WF6,CL_max_landing,rho_landing,Sref);







% [CL_a,CL_max_clean,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(AspectRatio,S_exposed,Sref,fusDiamOuter,b,M,Sweep_maxt,Cl_am,flap_deflection,Cl_wing_airfoil,Sflapped_over_Sref,Sweep_quarterchord,Sweep_TE);
% [CL_a_M0]=WingLift(AspectRatio,S_exposed,Sref,fusDiamOuter,b,0,Sweep_maxt,Cl_am,flap_deflection,Cl_wing_airfoil,Sflapped_over_Sref,Sweep_quarterchord,Sweep_TE);
% CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
% [CL_ah,CL_max_h]=TailLift(ARhoriz,d,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
% [maxLiftLanding,maxLiftTakeoff,AoA_Stall_Wing_Clean,AoA_Stall_Tail_Clean]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_clean,CL_a,CL_ah,CL_max_h,SHoriz,Sref,rho_landing,V_landing,rho_takeoff,V_takeoff);
% 
% %Aerodynamics: Drag 
% [CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
% [CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
% [CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,Sref);
% [CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,Sref,flapspan,b,flap_deflection_takeoff,flap_deflection_landing,Aeff,fusDiamOuter,upsweep_angle);
% [CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing);
% [CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,Sref,CD_0_Total,rho_landing,V_landing,AspectRatio);
% [V_Stall_Landing]=StallSpeed(W0,WF1,WF2,WF3,WF4,WF5,WF6,CL_max_landing,rho_landing,Sref);
save('AerodynamicsFINAL.mat','CL_a_Total','CL_ah','CL_a_M0','CL_max_clean','delta_alpha_takeoff','delta_alpha_landing','delta_CL_max','CL_max_takeoff','CL_max_landing','CL_max_h','zeroAlphaLCT','maxLiftLanding','maxLiftTakeoff','CD_0_Total','CD_Total','Drag_Landing','LtoDMax','CD_min','V_Stall_Landing')
