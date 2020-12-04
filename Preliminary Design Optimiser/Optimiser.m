%% Optimiser code

% This code would call on each individual member's codes and populate the
% .csv file based on results produced by each.

clear
clc
close all

addpath('../Aerodynamics/', '../Initial Sizing/', '../Powerplant/', '../Static Stability/',...
    '../Static Stability/Weight and Balance/', '../Structures', '../Structures/Fuselage/',...
    '../Undercarriage/')

load('AerodynamicsInputs.mat')

%% INITIAL SIZING
tic
% Inputs
% Update values, specially SwetSref!
load("DesignBriefTargets.mat") 
Mass_Person = 75; 
Mass_Luggage = 31; 
C_Cruise = 14.1 * 0.035316;
C_Divert = 11.55 * 0.035316;
C_Loiter = 11.3 * 0.035316;
K_LD = 15.5;
ARwing = 10.5;
SWet_SRef = 6;
TrappedFuelFactor = 0.02;
H_Divert = 12000;

% Functions
% Updated weight fractions, sanity check with team!
[W_Payload, W_Crew] = payloadAndCrewWeights(N_Pilots, N_Crew, N_Pax, Mass_Person, Mass_Luggage);
L_DMax = LiftToDragRatio(K_LD, ARwing, SWet_SRef);
WF1 = WFLeg1();                                                                         % Engine start-up and warm-up
WF2 = WFLeg2();                                                                         % Taxi
WF3 = WFLeg3();                                                                         % Take off
WF4 = WFLeg4();                                                                         % Climb and ascent from 0 ft to 35k ft
[WF5, V_Cruise, V_MaxVelocity] = WFLeg5(R_Cruise, C_Cruise, H_Cruise, M_Cruise, L_DMax);               % Cruise
VimD = VimDCalculator(H_Cruise, M_Cruise);  
WF6 = WFLeg6();                                                                         % Descent from 35k ft to 0 ft
WF7 = WFLeg7(WF4,H_Divert,H_Cruise);                                                    % Climb from 0 ft to 12k ft
[WF8, V_Divert] = WFLeg8(R_Divert, C_Divert, H_Divert, L_DMax, VimD, WF5*WF6*WF7);      % Diversion cruise
[WF9, V_Loiter] = WFLeg9(E_Loiter, C_Loiter, L_DMax, VimD, WF5*WF6*WF7*WF8, H_Loiter);  % Loiter at 5k ft
WF10 = WFLeg10(WF6, H_Loiter, H_Cruise);                                                % Descent from 5k ft to 0 ft
WF11 = WFLeg11();                                                                       % Landing, taxi and shutdown
ProductWFs = WF1*WF2*WF3*WF4*WF5*WF6*WF7*WF8*WF9*WF10*WF11;
W0 = RoskamGimmeMTOW(ProductWFs, W_Payload, W_Crew, TrappedFuelFactor);

% Outputs
disp(['The mass of the aircraft is: ', num2str(round(W0/9.81)), ' kg (aka ', num2str(round(W0)), ' N)'])

%% SIZING TO CONSTRAINTS

% Inputs
% Check values!
beta_Cruise = 0.2; e_Cruise = 0.85; C_D0_Cruise = 0.02;             % Cruise
beta_Divert = 0.5; e_Divert = 0.85; C_D0_Divert = 0.02;             % Divert
beta_Loiter = 0.8; e_Loiter = 0.75; C_D0_Loiter = 0.02;             % Loiter
[~,~,~,rho_ConsVT] = atmosisa(H_Loiter);                            % Constant turns
alpha_AbsC = WF1*WF2*WF3*WF4; beta_AbsC = 0.14; C_D0_AbsC = 0.02; e_AbsC = 0.85;   % Absolute ceiling   UPDATE!
TODA = 2200; CL_TakeOff = 1.7;                                      % Takeoff
NumberOfEngines = 2; ClimbGradient = 0.024;                         % One engine inoperative
C_LMaxLanding = 2.2;                                                % Landing

% Functions
% Walk team through functions!
[Const_WS_Cruise, Const_TW_Cruise] = SEP(H_Cruise, V_Cruise, 0, 0, WF1*WF2*WF3*WF4, beta_Cruise, 1, ARwing, e_Cruise, C_D0_Cruise);
[Const_WS_Divert, Const_TW_Divert] = SEP(H_Divert, V_Divert, 0, 0, WF1*WF2*WF3*WF4*WF5*WF6*WF7, beta_Divert, 1, ARwing, e_Divert, C_D0_Divert);
[Const_WS_Loiter, Const_TW_Loiter] = SEP(H_Loiter, V_Loiter, 0, 0, WF1*WF2*WF3*WF4*WF5*WF6*WF7*WF8, beta_Loiter, 1, ARwing, e_Loiter, C_D0_Loiter);
[Const_WS_MaxSpeed, Const_TW_MaxSpeed] = SEP(H_Cruise, V_MaxVelocity, 0, 0, WF1*WF2*WF3*WF4, beta_Cruise, 1, ARwing, e_Cruise, C_D0_Cruise);
[Const_WS_ConsVT, Const_TW_ConsVT] = ConsVT(rho_ConsVT, 30, V_Loiter);
[Const_WS_AbsCeil, Const_TW_AbsCeil, TargetMatchX, TargetMatchY] = Absolute_Ceiling(H_Absolute, 1, alpha_AbsC, beta_AbsC, L_DMax, C_D0_AbsC, ARwing, e_AbsC);
[Const_TW_TakeOff, Const_WS_TakeOff] = Take_off_constraint(TODA, CL_TakeOff, 1);
[Const_WS_OEI, Const_TW_OEI] = OEI_takeoff(NumberOfEngines, L_DMax, ClimbGradient);
[Const_WS_LandingTrev, Const_TW_LandingTrev] = Landing(C_LMaxLanding, 0.66, WF1*WF2*WF3*WF4*WF5*WF6*WF7);
[Const_WS_LandingNoTrev, Const_TW_LandingNoTrev] = Landing(C_LMaxLanding, 1, WF1*WF2*WF3*WF4*WF5*WF6*WF7);

% "Reading" design point off of the constraints diagram. This is not the
% most robust method for reading it, but for reasonable values taken in
% initial sizing, it should work. Make sure to double check with the
% constraints diagram!
WingLoading = TargetMatchX;
ThrustToWeightTakeOff = Const_TW_TakeOff(Const_WS_TakeOff == TargetMatchX);
if ThrustToWeightTakeOff > TargetMatchY
    ThrustToWeight = ThrustToWeightTakeOff;
elseif ThrustToWeightTakeOff < TargetMatchY
    ThrustToWeight = TargetMatchY;
else
    ThrustToWeight = TargetMatchY;
end

% % Outputs
% % Sanity check graph!
% figure(1)
% plot(Const_WS_Cruise, Const_TW_Cruise, '--', 'LineWidth', 1.5)
% hold on
% plot(Const_WS_Divert, Const_TW_Divert, '--', 'LineWidth', 1.5)
% plot(Const_WS_Loiter, Const_TW_Loiter, '--', 'LineWidth', 1.5)
% plot(Const_WS_MaxSpeed, Const_TW_MaxSpeed, 'LineWidth', 1.5)
% plot(Const_WS_ConsVT, Const_TW_ConsVT, '--', 'LineWidth', 1.5)
% plot(Const_WS_AbsCeil, Const_TW_AbsCeil, '--', 'LineWidth', 1.5)
% plot(Const_WS_TakeOff, Const_TW_TakeOff, 'LineWidth', 1.5)
% plot(Const_WS_OEI, Const_TW_OEI, '--', 'LineWidth', 1.5)
% plot(Const_WS_LandingTrev, Const_TW_LandingTrev, '--', 'LineWidth', 1.5)
% plot(Const_WS_LandingNoTrev, Const_TW_LandingNoTrev, 'LineWidth', 1.5)
% plot(TargetMatchX, TargetMatchY, 'x', 'LineWidth', 1.5)
% plot(WingLoading, ThrustToWeight, 'o', 'LineWidth', 1.5)
% ylim([0 1])
% xlim([0 12500])
% grid on
% legend('Cruise', 'Diversion', 'Loiter', 'Maximum velocity', 'Constant Velocity 30 deg Turns', 'Absolute Ceiling', 'Take-off', 'OEI', 'Landing with trev', 'Landing w/o trev', 'VimD optimiser', 'Selected Design Point')
% hold off
% saveas(figure(1), 'Constraints Diagram', 'png') 
% disp(['The design point selected gives a wing loading of ', num2str(WingLoading), ' N/m^2 and a thrust to weight ratio of ', num2str(ThrustToWeight), '.'])

%% FUSELAGE DESIGN

wallThicknessIn = 8; % in inches
wallThickness = wallThicknessIn*2.54/100;
fusDiamOuterfeet = 13.7; % in feet
fusDiamOuter = fusDiamOuterfeet*12*2.54/100; % in m
fusDiamInner = fusDiamOuter-wallThickness;

frontFR = 1.3;
frontLength = frontFR*fusDiamOuter;

cockpitArea = 48.777;
noseArea = 5.046;

noseLength = 0.93;
noseRadius = 0.816;
noseArea = 3.823;

cockpitLength = 2.58;
cockpitArea = 48.996;
entranceLength = 1.92;

frontArea = noseArea + cockpitArea;

mainLength = 36.506; 
mainArea = 479.325;

upsweep = 15.7;
aftLength = 12.60;
aftFR = aftLength/fusDiamOuter;
aftArea = 0.17 + 96.546;
aftDiameter = fusDiamOuter - aftLength*tand(upsweep);

totalLength = frontLength + aftLength + mainLength;
totalArea = frontArea + mainArea + aftArea;
totalFR = totalLength/fusDiamOuter;

PressVol = 36.181 + 247.97 + 103.205 + 58.316; % Front + main deck + cargo + aft
PressVolFt3 = PressVol*unitsratio('ft', 'm')^3; 

%% WING DESIGN

%calculate design Cl (sectional)
[~,~,~,rho_cruise]= atmosisa(distdim(35000,'ft','m'));
q_cruise=0.5*rho_cruise*V_Cruise^2;
Cl_design_sectional = WingLoading/q_cruise;

%airfoil
Airfoil_ThicknessRatio_Required=0.138; %from historical trend line in Raymer- initial approximation to shortlist airfoils
thicknessRatioWing =0.15; %depends on the airfoil selected. For NACA 64215 t/c=0.15

%planform
SWing=W0/WingLoading;
spanWing=sqrt(SWing*ARwing);

%wing geometry
taperWing= 0.38;       %from Raymer's graph
sweepWingLE= 29;           %degrees 
sweepWingQC= sweepConverter(sweepWingLE, 0, 0.25, ARwing, taperWing);
sweepWingTE= sweepConverter(sweepWingLE,0,1 ,ARwing, taperWing);
sweepWingMT= sweepConverter(sweepWingLE,0,0.349 ,ARwing, taperWing);
dihedralWing=5;             %degrees --> between 3 and 7; 5 chosen (midpoint)
twistWing=-3;                %use historical data 

%planform coordinates
y_root=0;
y_tip=spanWing/2;
 
cRootWing=(2*SWing)/(spanWing*(1+taperWing));
cTipWing=cRootWing*taperWing;

cBarWing= (2/3)*cRootWing*(1+taperWing+taperWing^2)/(1+taperWing);
y_MAC=(spanWing/6)*(1+2*taperWing)/(1+taperWing);
x_AC=y_MAC*tand(sweepWingQC)+0.25*cBarWing;

%various wing areas
c_fuselage = cRootWing - fusDiamOuter*( tand(sweepWingLE) - tand(sweepWingTE));
WingArea_fuselage=0.5*fusDiamOuter*(cRootWing+c_fuselage);
S_exposed= SWing-WingArea_fuselage;

S_wetted= S_exposed*(1.997+0.52*thicknessRatioWing);            %check--> depends on t/c of airfoil

%Structure (Palash just added another sweepConverter output)
frontSparPercent = 0.25;    % Between 12-18 percent
rearSparPercent = 0.70;     % Between 55-70 percent
UCSparPercent = 0.8;
Sweep_UCspar = sweepConverter(sweepWingLE, 0, UCSparPercent, ARwing, taperWing);
Sweep_rearSpar = sweepConverter(sweepWingLE, 0, rearSparPercent, ARwing, taperWing);

%wing incidence
i_w_root=2.3;
i_w_tip=i_w_root+twistWing;

%HLDs
CLmax_required=2.2;
CLmax_clean=1.283;
Delta_CLmax=0.9170;

%using double slotted flaps at TE
Sflapped_over_Sref=0.487; %confirmed for new aileron span
Sweep_hingeline_TE= sweepWingTE;
flap_deflection= Delta_CLmax/(1.6*Sflapped_over_Sref*cosd(Sweep_hingeline_TE));
flapspan= 15.0; %in metres 

%Wing Fuel tanks
volumeWingCAD = 71.882; % m^3 for one wing
volumeWingTotal = volumeWingCAD*2;

% Empirical Relation
volumeWetWing = 0.54*((SWing^2)/(spanWing))*thicknessRatioWing*(1+taperWing+taperWing)/(1+taperWing)^2; % Volume in ft^3
volumeWetWingUsable = 0.95*volumeWetWing; % 5% unusable due to engine
volumeWingTotalGal = volumeWetWingUsable*264;

volumeFuelReqGal = 19361.75238;
volumeFuelReq = 73.65065391; % Volume in m^3
wingCapacityFuel = volumeFuelReq/volumeWetWingUsable;
wingCapacityFuelWorst = volumeFuelReq/(volumeWetWingUsable*0.9);
wingCapacityFuelBest = volumeFuelReq/(volumeWetWingUsable*1.1);

%% TAILPLANE DESIGN

%defining tailplane parameters
%horizontal and vertical stabiliser parameters
etaH = 0.9; %crude approximation for jet planes
twistHoriz = 0;
twistVert = 0;
dihedralHoriz = 3;
dihedralVert = 0;

%aerofoil choice and characteristics
thicknessRatioHoriz = 0.12;
thicknessRatioVert = 0.12;
maxThicknessLocationHoriz = 0.3;
maxThicknessLocationVert = 0.3;
alpha0H = 0;

%tailplane parameters to optimse8
ARhoriz = 3.1; %typically 3-5 where AR = b^2/Sh and b is the tail span 
ARvert = 1.5; %typically 1.3-2 where AR = h^2/Sv and h is the tail height 
taperHoriz = 0.5; %typically 0.3 - 0.5 
taperVert = 0.5; %typically 0.3 - 0.5 

%CALCULATING TAILPLANE GEOMETRY BASED ON PARAMETERS ABOVE

%calculating tailplane sweep angles based on wing sweep...
%...for horizongtal tailplane
sweepHorizLE = 35;
sweepHorizQC = sweepConverter(sweepHorizLE, 0, 0.25, ARhoriz, taperHoriz);
sweepHorizMT = sweepConverter(sweepHorizLE, 0, maxThicknessLocationHoriz, ARhoriz, taperHoriz);
sweepHorizTE = sweepConverter(sweepHorizLE, 0, 1, ARhoriz, taperHoriz);

%...for vertical tailplane
sweepVertLE = 40;
sweepVertQC = sweepConverter(sweepVertLE, 0, 0.25, 2*ARvert, taperVert);
sweepVertMT = sweepConverter(sweepVertLE, 0, maxThicknessLocationVert, 2*ARhoriz, taperVert);
sweepVertTE = sweepConverter(sweepVertLE, 0, 1, 2*ARvert, taperVert);

%target volume coefficients
VbarH_target = 0.7; %horizontal volume coefficient estimates based off Raymer's historical data  % 0.7-1.2 
VbarV_target = 0.07; %vertical volume coefficient estimates based off Raymer's historical data % 0.07-0.12 

%initialising loop
SHoriz = 1;
SVert = 1;
VbarH = 0.01;
VbarV = 0.01;
count = 0;

while abs(VbarH_target - VbarH) > 1e-6 || abs(VbarV_target - VbarV) > 1e-6
    SHoriz = SHoriz*VbarH_target/VbarH;
    SVert = SVert*VbarV_target/VbarV;
    
    %calculating tailplane span/height and chords
    [spanHoriz, cRootHoriz, cTipHoriz, cBarHoriz] = tailplaneSizing(SHoriz, ARhoriz, taperHoriz);
    [heightVert, cRootVert, cTipVert, cBarVert] = tailplaneSizing(SVert, ARvert, taperVert);

    %wing and tail placement

    %root chord root chord leading edge positions [x-coord, y-coord, z-coord]
    wingRootLE = [0.3*totalLength; 0; -0.8*fusDiamOuter/2]; 
    horizRootLE = [totalLength - 1.3*cRootHoriz; 0; 0.8*fusDiamOuter/2]; 
    vertRootLE = [horizRootLE(1) - 0.77*cRootVert; 0; fusDiamOuter/2]; 

    %aerodynamic centre positions (1/4-chord of MAC) of wing and horizontal tailplane
    wingAC = wingRootLE + aerodynamicCentre(cBarWing, spanWing, taperWing, sweepWingLE, dihedralWing);
    horizAC = horizRootLE + aerodynamicCentre(cBarHoriz, spanHoriz, taperHoriz, sweepHorizLE, dihedralHoriz);

    temp = aerodynamicCentre(cBarVert, 2*heightVert, taperVert, sweepVertLE, dihedralVert);
    temp([2 3]) = temp([3 2]); %switching y and z coordinate for vertical tailplane
    vertAC = vertRootLE + temp;
    clear temp

    %tailplane moment arms
    lHoriz = horizAC(1) - wingAC(1);
    lVert = vertAC(1) - wingAC(1);
    hHoriz = horizRootLE(3) - wingRootLE(3);

    %tailplane volume coefficients
    VbarH = lHoriz*SHoriz/(cBarWing*SWing);
    VbarV = lVert*SVert/(spanWing*SWing);
    
    count = count + 1;
end
clear VbarH_target VbarV_target

%exposed and wetted areas
SHorizExposed = SHoriz - 7; %approximation
SHorizWetted = SHorizExposed*(1.977 + 0.52*thicknessRatioHoriz);
SVertExposed = SVert;
SVertWetted = SVertExposed*(1.977 + 0.52*thicknessRatioVert);
%fuselage width at horizontal tailplane intersection in m
fuseWidthHoriz = 2;


%% ELEVEATOR AND RUDDER DESIGN

% Assigning those values to variables below
elevator_avg_chord = 0.2 * cBarHoriz;                       % Average Elevator chord in m 
elevator_span = 0.9 * spanHoriz * 0.5;                      % Elevator half span in m
elevator_max_def = 15;                                      % In degrees
elevator_area = elevator_span * elevator_avg_chord * 2;     % Total area of the elevator

rudder_avg_chord = 0.2 * cBarVert;                          % Average Rudder chord in m      
rudder_span = 0.9 * heightVert;                             % Rudder half span in m
rudder_max_def = 18.75;                                     % In degrees
rudder_area = rudder_span * rudder_avg_chord * 2;           % Total area of the rudder


%% ENGINE DESIGN

y_engine_ref = 10; %DO NOT go below 8

[engine_uninstalled_length, D_f, Capture_radius, Engine_SeaLevelThrust, Engine_TSFC, Thrustline_position, Engine_Weight,...
    Engine_BPR, lengthNacelle, nacelleRadius, SnacelleWetted, y_engine_strike, z_engine_strike, Engine_CG, Nacelle_CG] = ...
    EngineFunction(ThrustToWeight, W0, wingRootLE(1) + 0.25*cRootWing, wingRootLE(3), cRootWing, i_w_root, sweepWingLE,...
    dihedralWing, y_engine_ref);

%% AERODYNAMIC ANALYSIS

M = [0.1931, 0.8, 0.2282];

%Assumed Values
widthNacelle=nacelleRadius*2;
Aeff = pi*nacelleRadius^2;
upsweep_angle=upsweep*(pi/180);
Cl_tail_airfoil=1.4;

%For aerodynamics analysis
l=[cBarWing,totalLength,lengthNacelle,cBarHoriz,cBarVert];
xtocmax=[0.349,0,0,maxThicknessLocationHoriz,maxThicknessLocationVert];
ttoc=[thicknessRatioWing,0,0,thicknessRatioHoriz,thicknessRatioVert];
theta_max=[sweepWingMT,0,0,sweepHorizMT,sweepVertMT];
S_wet_all=[S_wetted,totalArea,SnacelleWetted,SHorizWetted,SVertWetted];
Area_ucfrontal =6;
A_eff=1.7;
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
%% AILERON DESIGN

Ixx = 8.716e6;
aileron_starting_position = 0.61;
aileron_ending_position = 0.89;

[t, Max_ail_def, y1, y2, aileron_area] = aileron_sizing_new(spanWing, SWing, ARwing, taperWing,...
    CL_a_Total(3), V_Stall_Landing, Ixx, SWing, SHoriz, SVert, aileron_starting_position, aileron_ending_position, cRootWing);


%% WEIGHT ANALYSIS
Nz = 1.5*2.5;% minimum limit load factor = 2.5 according to FAR-25.337 (ultimate load factor = 1.5 x limit load factor)
Ngear = 2.7; %typically 2.7-3
W_avionics_uninstalled = 1000; %typically 800-1400 lb
electricRating = 60; %typically 40 ? 60 for transports (kVA)
W_APU_uninstalled = 8*(1.1*N_Pax)^0.75; %(lb) Pasquale Sforza, in Commercial Airplane Design Principles, 2014
lengthEngineControl = 2*(wingRootLE(1) + 0.2*spanWing)*unitsratio('ft', 'm'); %initial assumption
lengthElectrical = totalLength*unitsratio('ft', 'm');
lengthNacelle = lengthNacelle*unitsratio('ft', 'm');
widthNacelle = widthNacelle*unitsratio('ft', 'm');
engineDiam = 3.97*unitsratio('ft', 'm');
SnacelleWetted = SnacelleWetted*unitsratio('ft', 'm')^2;
lengthMainLG = 4.445*unitsratio('ft', 'm');
lengthNoseLG = 5*unitsratio('ft', 'm');
NmainWheels = 8;
NmainShockStruts = 2;
NumNoseWheels = 2;
numControlFunctions = 4;
numMechanicalFunctions = 3;
fuelXVal = cRootWing*1.2 + wingRootLE(1);
fuelZVal = 0.96 + wingRootLE(3);

%Calculations
fuelFraction = (1 + TrappedFuelFactor)*(1 - ProductWFs);
numPeopleOnBoard = N_Crew + N_Pax + N_Pilots;
totalCSarea = rudder_area + elevator_area + aileron_area;
W_Landing = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6;
W_seats = 60*N_Pilots + 32*N_Pax + 11*N_Crew; %typical 60lbs per flight deck seats, 32lbs for passenger seats
W_People = numPeopleOnBoard*Mass_Person*9.80665;
W_Luggage = numPeopleOnBoard*Mass_Luggage*9.80665;
W_maxCargo = W_Luggage;

%converting from SI to Imperial units
%m2 to ft2
SWing = SWing*unitsratio('ft', 'm')^2;
SHoriz = SHoriz*unitsratio('ft', 'm')^2;
SVert = SVert*unitsratio('ft', 'm')^2;
aileron_area = aileron_area*unitsratio('ft', 'm')^2;
elevator_area = elevator_area*unitsratio('ft', 'm')^2;
rudder_area = rudder_area*unitsratio('ft', 'm')^2;
totalArea = totalArea*unitsratio('ft', 'm')^2;
totalCSarea = totalCSarea*unitsratio('ft', 'm')^2;
%m to ft
spanWing = spanWing*unitsratio('ft', 'm');
spanHoriz = spanHoriz*unitsratio('ft', 'm');
heightVert = heightVert*unitsratio('ft', 'm');
cRootWing = cRootWing*unitsratio('ft', 'm');
cRootHoriz = cRootHoriz*unitsratio('ft', 'm');
cRootVert = cRootVert*unitsratio('ft', 'm');
lHoriz = lHoriz*unitsratio('ft', 'm');
lVert = lVert*unitsratio('ft', 'm');
fusDiamOuter = fusDiamOuter*unitsratio('ft', 'm');
totalLength = totalLength*unitsratio('ft', 'm');
V_Stall_Landing = V_Stall_Landing*unitsratio('ft', 'm');
%N to lb
W0 = convforce(W0, 'N', 'lbf');
W_People = convforce(W_People, 'N', 'lbf');
W_Luggage = convforce(W_Luggage, 'N', 'lbf');
W_maxCargo = convforce(W_maxCargo, 'N', 'lbf');
W_Landing = convforce(W_Landing, 'N', 'lbf');

%Weight breakdown by component (all in lbs)
components = nameComponents();

%lifting surfaces
components(1).weight = W_wings(W0, Nz, SWing, ARwing, taperWing, aileron_area, sweepWingQC, thicknessRatioWing);
components(2).weight = 0.75*W_horizTail(W0, Nz, SHoriz, ARhoriz, elevator_area, lHoriz, fuseWidthHoriz, spanHoriz, sweepHorizQC);
components(3).weight = 0.75*0.5*W_vertTail(W0, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert);
%fuselage and undercarriage
components(4).weight = W_fuse(W0, Nz, taperWing, spanWing, sweepWingQC, totalLength, totalArea, fusDiamOuter);
components(5).weight = 0.88*W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, V_Stall_Landing, NmainShockStruts);
components(6).weight = 0.88*W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels);
%engine and fuel system
components(7).weight = 2*convforce(Engine_Weight*9.80665, 'N', 'lbf');
components(8).weight = 0.8*2*W_nacelle(components(7).weight/2, lengthNacelle, widthNacelle, Nz, NumberOfEngines, SnacelleWetted);
components(9).weight = 5*NumberOfEngines + 0.8*lengthEngineControl; %lengthEngineControl = engine to cockpit total length (ft)
components(10).weight = W_engineStarter(NumberOfEngines, components(7).weight);
components(11).weight = 3e-4*W0;
components(12).weight = W_fuelSystem(2, volumeWingTotalGal, 0, volumeWingTotalGal);
%subsystems
components(13).weight = W_flightControls(W0, numControlFunctions, numMechanicalFunctions, totalCSarea, lHoriz);
components(14).weight = 2.2*W_APU_uninstalled; %installed APU weight
components(15).weight = W_instruments(N_Crew, NumberOfEngines, totalLength, spanWing);
components(16).weight = W_hydraulics(numControlFunctions, totalLength, spanWing);
components(17).weight = W_electrical(electricRating, lengthElectrical, NumberOfEngines);
components(18).weight = 1.73 * W_avionics_uninstalled^0.983; %installed avionics weight (uninstalled typically 800-1400lbs)
components(19).weight = W_furnish(N_Crew, W_maxCargo, totalArea, W_seats, numPeopleOnBoard);
components(20).weight = W_aircon(numPeopleOnBoard, PressVolFt3, W_avionics_uninstalled);
components(21).weight = 0.002*W0;
emptyWeight = sum([components(1:21).weight]);

components(22).weight = W_People; %crew + pax
components(23).weight = W_Luggage; %luggage of crew + pax
W_fuel = (emptyWeight + W_People + W_Luggage)*fuelFraction/(1 - fuelFraction);
components(24).weight = 0;
components(25).weight = W_fuel*1.2; %Using more fuel than we need for CG and stability ;) 
totalWeight= sum([components.weight]);

%Converting back from Imperial to SI units
%ft2 to m2
SWing = SWing/unitsratio('ft', 'm')^2;
SHoriz = SHoriz/unitsratio('ft', 'm')^2;
SVert = SVert/unitsratio('ft', 'm')^2;
aileron_area = aileron_area/unitsratio('ft', 'm')^2;
elevator_area = elevator_area/unitsratio('ft', 'm')^2;
rudder_area = rudder_area/unitsratio('ft', 'm')^2;
totalArea = totalArea/unitsratio('ft', 'm')^2;
totalCSarea = totalCSarea/unitsratio('ft', 'm')^2;
%ft to m
spanWing = spanWing/unitsratio('ft', 'm');
spanHoriz = spanHoriz/unitsratio('ft', 'm');
heightVert = heightVert/unitsratio('ft', 'm');
cRootWing = cRootWing/unitsratio('ft', 'm');
cRootHoriz = cRootHoriz/unitsratio('ft', 'm');
cRootVert = cRootVert/unitsratio('ft', 'm');
lengthNacelle = lengthNacelle/unitsratio('ft', 'm');
widthNacelle = widthNacelle/unitsratio('ft', 'm');
lHoriz = lHoriz/unitsratio('ft', 'm');
lVert = lVert/unitsratio('ft', 'm');
fusDiamOuter = fusDiamOuter/unitsratio('ft', 'm');
totalLength = totalLength/unitsratio('ft', 'm');
V_Stall_Landing = V_Stall_Landing/unitsratio('ft', 'm');
%lb to N
W0 = convforce(W0, 'lbf', 'N');
W_Crew = convforce(W_Crew, 'lbf', 'N');
W_Luggage = convforce(W_Luggage, 'lbf', 'N');
W_Landing = convforce(W_Landing, 'lbf', 'N');
W_maxCargo = convforce(W_maxCargo, 'lbf', 'N');
W_fuel = convforce(W_fuel, 'lbf', 'N');
emptyWeight = convforce(emptyWeight, 'lbf', 'N');
totalWeight = convforce(totalWeight, 'lbf', 'N');

for i = 1:length(components)
    components(i).weight = convforce(components(i).weight, 'lbf', 'N');
end
%Fuel volume check
V_fuel = (components(25).weight/9.81)/804;


%% BALANCE ANALYSIS

%CG of each component (in meters [x; y; z])
%lifting surfaces
components(1).cog = wingRootLE + liftingSurfaceCG(0.6, 0.35, spanWing, taperWing, cRootWing, dihedralWing, sweepWingLE, false);
components(2).cog = horizRootLE + liftingSurfaceCG(0.42, 0.38, spanHoriz, taperHoriz, cRootHoriz, dihedralHoriz, sweepHorizLE, false);
components(3).cog = vertRootLE + liftingSurfaceCG(0.42, 0.38, 2*heightVert, taperVert, cRootVert, dihedralVert, sweepVertLE, true);
%fuselage and undercarriage
components(4).cog = [0.45*totalLength; 0; 0];
components(5).cog = [25.3; 0; -1.5*fusDiamOuter/2]; 
components(6).cog = [2; 0; -1.5*fusDiamOuter/2];
%engine and fuel system
components(7).cog = Engine_CG;
components(8).cog = Nacelle_CG;
components(9).cog = [0.5*components(7).cog(1); 0; 0]; %lengthEngineControl = engine to cockpit total length (ft)
components(10).cog = [0.5*totalLength;0;0];
components(11).cog = [frontLength+0.65*mainLength;0;0]; 
components(12).cog = [fuelXVal+1.3*wingRootLE(1);0;fuelZVal]; % tank cg + root chord for x, z half way between root and fuel
%subsystems
components(13).cog = [0.5*frontLength; 0; -0.25*fusDiamOuter];
components(14).cog = [frontLength + mainLength + 0.65*aftLength; 0; 1.2];
components(15).cog = [0.5*frontLength; 0; -0.25*fusDiamOuter];
components(16).cog = [0.5*totalLength; 0; 0];
components(17).cog = [0.5*totalLength; 0; 0];
components(18).cog = [frontLength + 3; 0; -0.5*fusDiamOuter];
components(19).cog = [frontLength + 0.6*mainLength; 0; 0]; 
components(20).cog = [0.5*totalLength;0;0];
components(21).cog = [wingRootLE(1)+0.5*cRootWing;0;0];

components(22).cog = [frontLength + 0.55*mainLength; 0; 0]; 
components(23).cog = [frontLength + 0.5*mainLength; 0; 0];
components(24).cog = [0;0;0];
components(25).cog = [fuelXVal; 0; (fuelZVal+wingRootLE(3))/2];

%calculating CG empty
sumBalance_empty = [0;0;0];
sumWeight_empty = 0;
for i = 1:(length(components)-4)
    sumBalance_empty = sumBalance_empty + components(i).weight.*components(i).cog;
    sumWeight_empty = sumWeight_empty + components(i).weight;
end

CG_empty = sumBalance_empty./sumWeight_empty;

%calculating CG fuel no pax no cargo
sumBalance_fuel = sumBalance_empty;
sumWeight_fuel = sumWeight_empty;

i = 25;
sumBalance_fuel = sumBalance_fuel + components(i).weight.*components(i).cog;
sumWeight_fuel = sumWeight_fuel + components(i).weight;

CG_fuel = sumBalance_fuel./sumWeight_fuel;

%calculating CG MTOW
sumBalance_MTOW = [0;0;0];
sumWeight_MTOW = 0;
for i = 1:length(components)
    sumBalance_MTOW = sumBalance_MTOW + components(i).weight.*components(i).cog;
    sumWeight_MTOW = sumWeight_MTOW + components(i).weight;
end
CG_mtow = sumBalance_MTOW./sumWeight_MTOW;

%calculating CG cruise start
sumBalance_start = [0;0;0];
sumWeight_start = 0;
for i = 1:(length(components)-1)
    sumBalance_start = sumBalance_start + components(i).weight.*components(i).cog;
    sumWeight_start = sumWeight_start + components(i).weight;
end
sumWeight_start = sumWeight_start + components(25).weight - (W0 - W0*WF1*WF2*WF3*WF4);
sumBalance_start = sumBalance_start + (components(25).weight - (W0 - W0*WF1*WF2*WF3*WF4)).*components(25).cog;
CG_start = sumBalance_start./sumWeight_start;

%calculating CG cruise end
sumBalance_end = [0;0;0];
sumWeight_end = 0;
for i = 1:(length(components)-1)
    sumBalance_end = sumBalance_end + components(i).weight.*components(i).cog;
    sumWeight_end = sumWeight_end + components(i).weight;
end
sumWeight_end = sumWeight_end + components(25).weight - (W0 - W0*WF1*WF2*WF3*WF4*WF5);
sumBalance_end = sumBalance_end + (components(25).weight - (W0 - W0*WF1*WF2*WF3*WF4*WF5)).*components(25).cog;
CG_end = sumBalance_end./sumWeight_end;

%calculating CG landing
sumBalance_land = [0;0;0];
sumWeight_land = 0;
for i = 1:(length(components)-1)
    sumBalance_land = sumBalance_land + components(i).weight.*components(i).cog;
    sumWeight_land = sumWeight_land + components(i).weight;
end
sumWeight_land = sumWeight_land + components(25).weight - (W0 - W0*WF1*WF2*WF3*WF4*WF5*WF6);
sumBalance_land = sumBalance_land + (components(25).weight - (W0 - W0*WF1*WF2*WF3*WF4*WF5*WF6)).*components(25).cog;
CG_land = sumBalance_land./sumWeight_land;


CG_all = [CG_mtow, CG_start, CG_end, CG_land]; 


%% STABILTIY ANALYSIS

%Plotting aircraft lifting surfaces and fuselage
wingPlanform = wingRootLE + tailplanePlanform(spanWing, sweepWingLE, cRootWing, cTipWing, dihedralWing, false);
horizPlanform = horizRootLE + tailplanePlanform(spanHoriz, sweepHorizLE, cRootHoriz, cTipHoriz, dihedralHoriz, false);
vertPlanform = vertRootLE + tailplanePlanform(2*heightVert, sweepVertLE, cRootVert, cTipVert, dihedralVert, true);

%aircraft fuselage pitching moment contribution
CMalphaF = fuselagePitchingMoment(totalLength, fusDiamOuter, cBarWing, SWing, wingRootLE(1) + 0.25*cRootWing);

%wing downwash on tailplane d(e)/d(alpha) 
downwash = downwash(lHoriz, hHoriz, spanWing, sweepWingQC, ARwing, taperWing, CL_a_Total, CL_a_M0);

%neutral point and static margin
[xNPOff, KnOff, xNPOn, KnOn] =...
   staticStability(CG_all, SWing, SHoriz, wingAC(1), horizAC(1), cBarWing, CL_ah, CL_a_Total, CMalphaF, downwash, etaH);

%% TRIM ANALYSIS 

%wing aerofoil parameters
CMoAerofoilW = -0.03; %Sforza and -0.04 according to airfoiltools (xfoil)
alpha0W = [alpha_zero_takeoff, -1.8, alpha_zero_landing]; %degrees

%wing zero-lift pitching moment coefficient
CMoW = zeroLiftPitchingMoment(CMoAerofoilW, ARwing, sweepWingQC, twistWing, CL_a_Total, CL_a_M0);

%determine iH, AoA, AoA_h, AoA_w, CL_w, and CL_h for trimmed flight
[iH_trim, iW_trim, AoA_trim, AoA_trimWings, AoA_trimHoriz, CL_trimWings, CL_trimHoriz] =...
   trimAnalysis(CG_all, wingAC, horizAC, Thrustline_position, y_MAC, spanWing, cBarWing, SWing, SHoriz, CMoW, CMalphaF,...
   CL_Target, CD_Total, CL_a_Total, CL_ah, twistWing, alpha0W, alpha0H, downwash, etaH);

%drawing aircraft
sweepVertRudder = sweepConverter(sweepVertLE, 0, 0.8, 2*ARvert, taperVert);
tailplanePlot(vertRootLE, cRootVert, xNPOff, sweepVertRudder, sweepVertTE, heightVert, CG_mtow, wingPlanform, horizPlanform, vertPlanform, aftLength, mainLength, frontLength, fusDiamOuter, aftDiameter)

% Ground clearance checker ( DO NOT DELETE )

%         Bruhg1 = tand(theta_maxground - 90);
%         Bruhc1 = CG_full(3) - Bruhg1*CGfull(1);
%         Bruhg2 = tand(theta_maxground);
%         Bruhc2 = -fusDiamOuter/2 - Bruhg2*(frontLength + mainLength);
%         Bruhxmin = (Bruhc2-Bruhc1)/(Bruhg1-Bruhg2);
%         Bruhxmin = Bruhxmin - 1.5; % FUDGE factor to allow more ground clearance options

%tailplanePlot2(Bruhxmin, xNPOff, CGempty, CGfull, wingPlanform, horizPlanform, vertPlanform, aftLength, mainLength, frontLength, fusDiamOuter, aftDiameter)

%% UNDERCARRIAGE DESIGN

%theta_maxground = 15;
theta_maxground = 16;
x_firsttailstrike = frontLength + mainLength;
height_mgmax = 1.5;
length_mgmax = 3;
x_cgmin = CG_empty(1); % FUDGE factor to move ground CG forward
x_cgmax = CG_empty(1); % FUDGE factor to move ground CG forward
z_cg = CG_all(3,1);
fudge = 0.4;

[MainOleo, NoseOleo, LocationMainGearJoint, LocationNoseGearJoint, LengthMainGearDeployed, ...
    LengthMainGearRetracted, LengthNoseGearDeployed, LengthNoseGearRetracted, ...
    GroundClearanceFuselage, GroundClearanceEngine, NoseGearLoadRatio, LandingLoadRatio, ...
    AngleTailstrike, AngleTipback, AngleOverturn, NoseWheel, MainWheel, FrontalAreaNoseGear, FrontalAreaMainGear] ...
    = UndercarriageFunction2(fudge, W0, WF1*WF2*WF3*WF4*WF5*WF6, wingRootLE(1) + 0.25*cBarWing, wingRootLE(3), cRootWing, ...
    i_w_root, Sweep_UCspar, dihedralWing, ...
    theta_maxground, UCSparPercent, totalLength, fusDiamOuter/2, ...
    x_firsttailstrike, -fusDiamOuter/2, height_mgmax, length_mgmax, x_cgmin, x_cgmax, ...
    z_cg, y_engine_strike, z_engine_strike);


        
        
        

%% PERFORMANCE ANALYSIS
W_ini_1 = W0 * WF1 * WF2 * WF3 * WF4;       % Weight at start of cruise 1 in Newtons
V_S1 = sqrt((2 * W_ini_1) / (1.225 * SWing * CLmax_clean));         % Finding out the stall speed in clean config
CL_MAX_TAKEOFF = CL_max_takeoff + (SHoriz / SWing) * CL_ah(1); 
V_stall_takeoff = sqrt((2 * W0) / (1.225 * SWing* CL_MAX_TAKEOFF)); % Stall speed in take off config

beta_thrust_ratio_takeoff = ThrustLapseModel(0, 0, 0.8, 35000); % Finding out Beta value during takeoff
L_over_D_transition = CL_MAX_TAKEOFF/0.2995;  % Lift to drag ratio at Transition phase. Denominator is CD_Total
T_dummy = W0 * ThrustToWeightTakeOff;      
T_Takeoff = T_dummy * beta_thrust_ratio_takeoff; % Finding out the Takeoff Thrust

% This equation gives the Take off distance in metres
S_to = Take_off_distance(V_stall_takeoff, V_S1, T_Takeoff, W0,...
    CD_0_Total(1), ARwing, e_Cruise, zeroAlphaLCT, L_over_D_transition, SWing);    



W_L = W0 * WF8 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF9 * WF10;
% ^ Weight of the flight at start of landing phase

CL_MAX_LANDING = CL_max_landing + (SHoriz / SWing) * CL_ah(3);
VS0 = sqrt((2 * W_L) / (1.225 * SWing * CL_MAX_LANDING)); % Stall speed in Landing config
L_over_D_landing = sqrt((pi * ARwing * e_Cruise) / (4 * CD_0_Total(3)));  % Lift to drag ratio in landing config
landing_velocity = 1.1 * VS0;                             % Landing velocity
landing_velocity_mach = landing_velocity / sqrt(1.4 * 287 * 288.051); % Mach number for landing velocity

beta_thrust_ratio_landing = ThrustLapseModel(landing_velocity_mach,...
    50, 0.8, 35000);                                      % Beta value for landing
T_L = T_dummy * beta_thrust_ratio_landing;                % Thrust during landing in Newtons

% This equation gives the Landing distance in metres
S_L = Landing_distance(0.7859, V_S1, W_L, VS0,...
    T_L, L_over_D_landing, SWing, ARwing, e_Cruise, CD_0_Total(3));


D2 = 0.5 * 1.225 * SWing * 1.44 * V_stall_takeoff^2 * 0.2995;  % The last value is CD_Total
T_oei = 0.5 * T_Takeoff;
T_takeoff_static = T_dummy;

% This equation gives the Balanced Field Length in metres
BFL = Balanced_Field_Length(W0, SWing, CL_MAX_TAKEOFF,...
    T_oei, D2, 10, CL_MAX_LANDING, T_takeoff_static);



W_fin_1 = W0 * WF1 * WF2 * WF3 * WF4 * WF5; % Weight at end of cruise 1 in Newtons
c_t1 = 14.10 * 9.81 / 1000000;              % Thrust Specific Fuel Consumption for Cruise 1 in 1/second
[E1, R1, FC1] = Range(W_ini_1, rho_cruise, V_Cruise, SWing,...
    CD_0_Total(2), c_t1, ARwing, W_fin_1, e_Cruise);

W_ini_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7;        % Weight at start of cruise 2
W_fin_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8;  % Weight at end of cruise 2
rho_cruise_2 = 0.849137;                                       % Density of air at 12000 ft in kg/m^3
c_t2 = 11.55 * 9.81 / 1000000;              % Thrust Specific Fuel Consumption for Cruise 2 in 1/second

[E2, R2, FC2] = Range(W_ini_2, rho_cruise_2, V_Divert, SWing,...
    0.0186, c_t2, ARwing, W_fin_2, e_Cruise);

W_ini_3 = W_fin_2;                                                  % Weight of aircraft at start of Loiter
W_fin_3 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8 * WF9; % Weight of aircraft at end of Loiter
rho_cruise_3 = 1.05555;                                             % Density of air at 5000 ft in kg/m^3
c_t3 = 11.30 * 9.81 / 1000000;             % Thrust Specific Fuel Consumption for Loiter in 1/second

[E3, R3, FC3] = Range(W_ini_3, rho_cruise_3, V_Loiter, SWing,...
    0.0202, c_t3, ARwing, W_fin_3, e_Loiter); 

fprintf('The Endurance of the aircraft during Cruise 1 is %f hours.\n',E1);
fprintf('The Endurance of the aircraft during Cruise 2 is %f hours.\n',E2);
fprintf('The Endurance of the aircraft during Loiter is %f hours.\n',E3);
fprintf('The Range of the aircraft during Cruise 1 is %f km.\n',R1);
fprintf('The Range of the aircraft during Cruise 2 is %f km.\n',R2);
fprintf('The Range of the aircraft during Loiter is %f km.\n',R3);
fprintf('The fuel consumption of the aircraft during Cruise 1 is %f.\n',FC1);
fprintf('The fuel consumption of the aircraft during Cruise 2 is %f.\n',FC2);
fprintf('The fuel consumption of the aircraft during Loiter is %f.\n',FC3);


% Climb rate during OEI
climb_rate = tan(asin((0.5 * (ThrustToWeightTakeOff)) - (CD_Total(1) / CL_max_takeoff))); 
fprintf('The climb rate during OEI Take off is %f. \n',climb_rate);


% This section plots a graph for Altitude against Rate of climb which is
% then used to find the Absolute and Service ceilings

W_cruise = W_ini_1;  % Weight of aircraft at start of cruise 1
[ROC_max, altitude] = climb(W_ini_1, CD_Total(2), 18, SWing, T_dummy);  

figure 
plot(altitude, ROC_max, '-xr')
ylabel('Maximum Rate of Climb (feet/minute)');
xlabel('Altitude (feet)');

%{
% Finding out some parameters during cruise
beta_thrust_ratio_cruise = ThrustLapseModel(0.8, 35000, 0.8, 35000);
T_cruise = T_dummy * beta_thrust_ratio_cruise; 

[L_over_D_max, Vs_Cruise, V_LDmax, V_max, V_min] = Cruise_leg_calculations(CD_min(2),...
    0.7853, ARwing, e_Cruise, rho_cruise, W_cruise, SWing, CL_max_clean, 1, T_cruise);
%}


h = (0:100:60000);              % Height in feet
height_metres = h*0.3048;       % Height in metres
M = (0:(1/(length(h) - 1)):1);  % Mach number
vals = (0:1:length(h));
K=0.04096652332;

for i = 1 : length(h)
    alt = height_metres(i);     % Converting altitude from feet to metres to do temp/pressure calculations
    [T, a, P, rho] = atmosisa(alt);
    
    for j = 1 : length(h)
        velocity = M(j) * a;                                   % Finding out the velocity
        beta_thrust_ratio_cruise = ThrustLapseModel(M(j), alt/0.3048, 0.8, 35000);
        Thrust = W0 * ThrustToWeightTakeOff * beta_thrust_ratio_cruise; 
        CL_Cruise = W_cruise / (0.5 * rho * velocity^2 * SWing);
        CD_Total = CD_0_Total(2) + (K * (CL_Cruise)^2);
        D = 0.5 * rho * SWing * velocity^2 * CD_Total;
        Ps(i,j) = (velocity / W0) * (Thrust - D);              % Finding out specific excess power
    end
    
    vstall(i) = sqrt((2 * W_cruise / SWing) / (rho * CL_max_clean)) / a;   % Stall speed to be plotted in Mach
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plotting the Contour plot
figure
[cl,hl] = contour(M,height_metres,Ps,vals);
clabel(cl,hl)
title('Specific Excess Power')
xlabel('Mach number')
ylabel('Altitude (feet)')
hold on
plot(vstall, height_metres, '-r')
legend('Specific Excess Energy', 'Stall Boundary')




KnOff
LocationNoseGearJoint
LocationMainGearJoint
toc


%% OUTPUTS

%
designparams = readtable('designparamsempty.csv');

designparams(1,2) = {W0};
designparams(2,2) = {W0*WF1*WF2*WF3*WF4*WF5*WF6}; %max landing weight
designparams(3,2) = {W_People + W_Luggage}; %total pax/crew/payload weight
designparams(4,2) = {W_fuel};
designparams(5,2) = {totalLength};
designparams(6,2) = {fusDiamOuter};
designparams(7,2) = {6}; %num seats abreast
designparams(8,2) = {aftDiameter};
designparams(9,2) = {frontFR};
designparams(10,2) = {aftFR};
designparams(11,2) = {15.7}; %aftbody upsweep angle
designparams(12,2) = {wingRootLE(1)};
designparams(13,2) = {wingRootLE(3)};
designparams(15,2) = {thicknessRatioWing};
designparams(16,2) = {5.73}; %wing aerofoil lift curve slope
designparams(17,2) = {-1.6};
designparams(18,2) = {1.6}; %wing aerofoil max CL
designparams(19,2) = {SWing};
designparams(20,2) = {taperWing};
designparams(21,2) = {ARwing};
designparams(22,2) = {sweepWingQC};
designparams(23,2) = {dihedralWing};
designparams(24,2) = {twistWing};
designparams(25,2) = {i_w_root};
designparams(26,2) = {frontSparPercent};
designparams(27,2) = {rearSparPercent};
designparams(29,2) = {0.2}; %TE device chord ratio c' = cf + c
designparams(30,2) = {flap_deflection}; %TE device extension ratio
designparams(31,2) = {0.0844}; %TE device start position
designparams(32,2) = {0.493}; %TE device end position
designparams(38,2) = {0.2}; %aileron chord ratio
designparams(39,2) = {aileron_starting_position};
designparams(40,2) = {aileron_ending_position};
designparams(42,2) = {thicknessRatioHoriz};
designparams(43,2) = {6.11}; %HT aerofoil lift curve slope
designparams(44,2) = {alpha0H};
designparams(45,2) = {horizRootLE(1)};
designparams(46,2) = {horizRootLE(2)};
designparams(47,2) = {SHoriz};
designparams(48,2) = {taperHoriz};
designparams(49,2) = {ARhoriz};
designparams(50,2) = {sweepHorizQC};
designparams(51,2) = {dihedralHoriz};
designparams(52,2) = {iH_trim(2)};
designparams(53,2) = {frontSparPercent};
designparams(54,2) = {rearSparPercent};
designparams(55,2) = {0.2}; %elevator chord ratio
designparams(56,2) = {0.05};
designparams(57,2) = {0.95};
designparams(59,2) = {thicknessRatioVert};
designparams(60,2) = {vertRootLE(1)};
designparams(61,2) = {vertRootLE(3)};
designparams(62,2) = {SVert};
designparams(63,2) = {taperVert};
designparams(64,2) = {ARvert};
designparams(65,2) = {sweepVertQC};
designparams(66,2) = {frontSparPercent};
designparams(67,2) = {rearSparPercent};
designparams(68,2) = {0.2}; %rudder chord ratio
designparams(69,2) = {0.05};
designparams(70,2) = {0.95};
designparams(71,2) = {LocationMainGearJoint(1)};
designparams(72,2) = {LocationMainGearJoint(2)};
designparams(73,2) = {LengthMainGearRetracted};
designparams(74,2) = {MainOleo.Stroke}; %main gear stroke
designparams(75,2) = {4};
designparams(76,2) = {0.508};
designparams(77,2) = {0.714};
designparams(78,2) = {MainWheel.InflatedOuterDiamMaxINCH*0.0254};
designparams(79,2) = {MainWheel.InflatedOuterDiamMinINCH*0.0254};
designparams(80,2) = {MainWheel.SectionWidthMaxINCH*0.0254};
designparams(81,2) = {MainWheel.RatedInflationPSI*6894.76};
designparams(82,2) = {LocationNoseGearJoint(1)};
designparams(83,2) = {LengthNoseGearRetracted};
designparams(84,2) = {NoseOleo.Stroke};
designparams(85,2) = {2};
designparams(86,2) = {0.4064};
designparams(87,2) = {NoseWheel.InflatedOuterDiamMaxINCH*0.0254};
designparams(88,2) = {NoseWheel.InflatedOuterDiamMinINCH*0.0254};
designparams(89,2) = {NoseWheel.SectionWidthMaxINCH*0.0254};
designparams(90,2) = {NoseWheel.RatedInflationPSI*6894.76};
designparams(91,2) = {Engine_SeaLevelThrust};
designparams(92,2) = {D_f};
designparams(93,2) = {engine_uninstalled_length};
designparams(94,2) = {Engine_BPR};
designparams(95,2) = {Capture_radius*2};
designparams(96,2) = {lengthNacelle};
designparams(97,2) = {Thrustline_position(2)};
designparams(99,2) = {0.50643144};
designparams(100,2) = {Engine_Weight};
designparams(101,2) = {1};

%{
designparams.Value = num2cell(designparams.Value);

designparams{14,2} = "NACA 64-215 ";
designparams{28,2} = "double      ";
designparams{41,2} = "NACA 0012   ";
designparams{58,2} = "NACA 0012   ";
designparams{14,2} = "NACA 64-215 ";
%}
writetable(designparams, 'designparams.csv')
%}
