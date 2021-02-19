clear
clc
close all

addpath('../Aerodynamics/', '../Initial Sizing/', '../Powerplant/', '../Static Stability/',...
    '../Static Stability/Weight and Balance/', '../Structures', '../Structures/Fuselage/',...
    '../Undercarriage/')

load('ConceptualDesign.mat')

%% Aerodynamic Analysis

[~,a_Cruise,~,rho_cruise]= atmosisa(distdim(35000,'ft','m'));
M(2) = 0.82;
V_Cruise = M(2)*a_Cruise;

%Aerodynamics: Lift
[CL_a,CL_max_clean,alpha_zero_takeoff,alpha_zero_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(ARwing,S_exposed,SWing,fusDiamOuter,spanWing,M,sweepWingMT,flap_deflection,Cl_wing_airfoil,Sflapped_over_Sref,sweepWingQC,sweepWingTE);
[CL_a_M0]=WingLift(ARwing,S_exposed,SWing,fusDiamOuter,spanWing,0,sweepWingMT,flap_deflection,Cl_wing_airfoil,Sflapped_over_Sref,sweepWingQC,sweepWingTE);
CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
[CL_ah,CL_max_h]=TailLift(ARhoriz,fusDiamOuter,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
[maxLiftLanding,maxLiftTakeoff,AoA_Stall_Wing,AoA_Stall_Tail]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_clean,CL_a_Total,CL_ah,CL_max_h,SHoriz,SWing,rho_landing,V_landing,rho_takeoff,V_takeoff,alpha_zero_takeoff,alpha_zero_landing);

%Aerodynamics: Drag 
[CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,lengthNacelle,widthNacelle,S_wet_all,SWing);
[CD_Parasitic_Cruise2,CD_Parasitic_Total_Cruise2,CD_LandP_Cruise2]=Parasitic(0.849,140.622,l,0.0000169,0.5,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,lengthNacelle,widthNacelle,S_wet_all,SWing);
CD_0_Cruise2=CD_Parasitic_Total_Cruise2+0.0066;
[CD_Parasitic_Loiter,CD_Parasitic_Total_Loiter,CD_LandP_Loiter]=Parasitic(0.849,95.3,l,0.0000176219,0.3,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,lengthNacelle,widthNacelle,S_wet_all,SWing);
CD_0_Loiter=CD_Parasitic_Total_Loiter+0.0066;
[CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,lengthNacelle,widthNacelle,S_wet_all,SWing);
[CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,totalLength,fusDiamOuter,lengthNacelle,widthNacelle,S_wet_all,SWing);
[CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,SWing,flapspan,spanWing,flap_deflection_takeoff,flap_deflection_landing,Aeff,fusDiamOuter,upsweep_angle);
[CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing);
[V_Stall_Landing]=StallSpeed(W0,WF1,WF2,WF3,WF4,WF5,WF6,CL_max_landing,rho_landing,SWing);
%[CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax,CLmD]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,SWing,CD_0_Total,rho_landing,V_landing,ARwing);
[CL_Target,CD_Total,LtoDMax,CLmD,Drag_Landing]=TotalDragFinal(W0,WF1,WF2,WF3,WF4,WF5,WF6,WF7,WF8,WF9,WF10,rho_takeoff,rho_cruise,rho_landing,V_Cruise,V_Stall_Landing,SWing,CD_0_Total,ARwing);



%% TRIM ANALYSIS

%wing aerofoil parameters
CMoAerofoilW = -0.03; %Sforza and -0.04 according to airfoiltools (xfoil)
alpha0W = [alpha_zero_takeoff, -1.8, alpha_zero_landing]; %degrees

%wing zero-lift pitching moment coefficient
CMoW = zeroLiftPitchingMoment(CMoAerofoilW, ARwing, sweepWingQC, twistWing, CL_a_Total, CL_a_M0);

%finding thrust coefficients for takeoff and landing

thrustTakeoff = 2*Engine_SeaLevelThrust*ThrustLapseModel(1.2*sqrt((2 * W0) / (1.225 * SWing* CL_max_takeoff))/340.2941, 0, 0.8, 35000);
thrustLanding = 0.25*2*Engine_SeaLevelThrust*ThrustLapseModel(1.3*V_Stall_Landing/340.2941, 0, 0.8, 35000);

CTtakeoff = thrustTakeoff/(SWing*0.5*1.225*(1.2*sqrt((2 * W0) / (1.225 * SWing* CL_max_takeoff)))^2);
CTlanding = thrustLanding/(SWing*0.5*1.225*(1.3*V_Stall_Landing)^2);

clear downwash
Downwash = downwash(lHoriz, hHoriz, spanWing, sweepWingQC, ARwing, taperWing, CL_a_Total, CL_a_M0);

CL_Target(2) = (W0)/(0.5*rho_cruise*(V_Cruise)^2*SWing);

%determine iH, AoA, AoA_h, AoA_w, CL_w, and CL_h for trimmed flight
[iH_trim, iW_trim, AoA_trim, AoA_trimWings, AoA_trimHoriz, CL_trimWings, CL_trimHoriz] =...
   trimAnalysis(CG_all, wingAC, horizAC, Thrustline_position, y_MAC, spanWing, cBarWing, SWing, SHoriz, CMoW, CMalphaF,...
   CL_Target, [CTtakeoff, CD_Total(2), CTlanding], CL_a_Total, CL_ah, twistWing, alpha0W, alpha0H, Downwash, etaH);

liftWingDive = 0.5*rho_cruise*CL_trimWings(2)*SWing*V_Cruise^2;
liftHorizDive = 0.5*etaH*rho_cruise*CL_trimHoriz(2)*SHoriz*V_Cruise^2;

V_Dive = V_Cruise;
V_Cruise = 0.8*a_Cruise;
M_Dive = M(2);

save('diveTrim.mat', 'V_Dive', 'M_Dive', 'liftWingDive', 'liftHorizDive')