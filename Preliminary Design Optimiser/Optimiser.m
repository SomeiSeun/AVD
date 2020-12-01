%% Optimiser code

% This code would call on each individual member's codes and populate the
% .csv file based on results produced by each.

%% Housekeeping
clear
clc
close all

%% Add path to functions and workspace files

addpath('../Initial Sizing/', '../Xfoil/', '../Structures/Fuselage/', '../Aerodynamics/', '../Static Stability/',...
    '../Static Stability/Weight and Balance/', '../Powerplant/')  
load('Unknowns.mat')

%% INIITIAL SIZING

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

%% CONSTRAINTS ANALYSIS

% Inputs
beta_Cruise = 0.2; e_Cruise = 0.85; C_D0_Cruise = 0.02;             % Cruise
beta_Divert = 0.5; e_Divert = 0.85; C_D0_Divert = 0.02;             % Divert
beta_Loiter = 0.8; e_Loiter = 0.75; C_D0_Loiter = 0.02;             % Loiter
[~,~,~,rho_ConsVT] = atmosisa(H_Loiter);                            % Constant turns
alpha_AbsC = WF1*WF2*WF3*WF4; beta_AbsC = 0.14; C_D0_AbsC = 0.02; e_AbsC = 0.85;   % Absolute ceiling
TODA = 2200; CL_TakeOff = 1.7;                                      % Takeoff
NumberOfEngines = 2; ClimbGradient = 0.024;                         % One engine inoperative
C_LMaxLanding = 2.2;                                                % Landing

% Functions
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

% Diameters 
wallThicknessIn = 8; % in inches
wallThickness = wallThicknessIn*2.54/100;
fusDiamOuterfeet = 13.7; % in feet
fusDiamOuter = fusDiamOuterfeet*12*2.54/100; % in m
fusDiamInner = fusDiamOuter-wallThickness;

% Front
frontFR = 1.3;
frontLength = frontFR*fusDiamOuter;

%{
noseLength = 1.35;
noseRadius = 0.816;
cockpitLength = 2.58;
entranceLength = 1.92;
frontLength2 = noseLength + cockpitLength + entranceLength;
%}

cockpitArea = 48.777;
noseArea = 5.046;

%frontLength = 1.4*fusDiamOuter;
noseLength = 0.93;
noseRadius = 0.816;
noseArea = 3.823;

cockpitLength = 2.58;
cockpitArea = 48.996;
entranceLength = 1.92;

%frontLength2 = noseLength + cockpitLength + entranceLength;
frontArea = noseArea + cockpitArea;

% Main
mainLength = 36.506; 
mainArea = 479.325;

% Aft
aftLength = 12.60;
aftFR = aftLength/fusDiamOuter;
aftArea = 0.223 + 99.78;
aftDiameter = 0.7996;

% Total
totalLength = frontLength + aftLength + mainLength;
totalArea = frontArea + mainArea + aftArea;


%% WING DESIGN

%Calculate design Cl (sectional)
[~,~,~,rho_cruise]= atmosisa(distdim(35000,'ft','m'));
q_cruise=0.5*rho_cruise*V_Cruise^2;
Cl_design_sectional = WingLoading/q_cruise;

%Airfoil
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

c_fuselage = cRootWing - fusDiamOuter*( tand(sweepWingLE) - tand(sweepWingTE));
WingArea_fuselage=0.5*fusDiamOuter*(cRootWing+c_fuselage);
SWingExposed= SWing-WingArea_fuselage;
SWingWetted= SWingExposed*(1.977+0.52*thicknessRatioWing);            

%wing incidence
i_w_root=2.3;
i_w_tip=i_w_root-twistWing;

%HLDs
CLmax_required=2.2;
CLmax_clean=1.283;
Delta_CLmax=0.9170;

%using double slotted flaps at TE
Sflapped_over_Sref=0.487; %dependent on aileron span
Sweep_hingeline_TE= sweepWingTE;
flap_deflection= Delta_CLmax/(1.6*Sflapped_over_Sref*cosd(Sweep_hingeline_TE));


%% TAILPLANE DESIGN

%horizontal and vertical stabiliser parameters
etaH = 0.9; %crude approximation for jet planes
twistHoriz = 0;
twistVert = 0;
dihedralHoriz = 0;
dihedralVert = 0;

%aerofoil choice and characteristics
NACAhoriz = '0012';
NACAvert = '0012';
thicknessRatioHoriz = 0.12;
thicknessRatioVert = 0.12;
maxThicknessLocationHoriz = 0.3;
maxThicknessLocationVert = 0.3;
alpha0H = 0;

%tailplane parameters to optimse
ARhoriz = 5; %typically 3-5 where AR = b^2/Sh and b is the tail span
ARvert = 1.8; %typically 1.3-2 where AR = h^2/Sv and h is the tail height
taperHoriz = 0.3; %typically 0.3 - 0.5
taperVert = 0.35; %typically 0.3 - 0.5

%calculating tailplane sweep angles based on wing sweep...
%...for horizongtal tailplane
sweepHorizLE = 35;
sweepHorizQC = sweepConverter(sweepHorizLE, 0, 0.25, ARhoriz, taperHoriz);
sweepHorizMT = sweepConverter(sweepHorizLE, 0, maxThicknessLocationHoriz, ARhoriz, taperHoriz);
sweepHorizTE = sweepConverter(sweepHorizLE, 0, 1, ARhoriz, taperHoriz);

McritHoriz = 0.82*cosd(sweepHorizLE);

%...for vertical tailplane
sweepVertLE = 40;
sweepVertQC = sweepConverter(sweepVertLE, 0, 0.25, 2*ARvert, taperVert);
sweepVertMT = sweepConverter(sweepVertLE, 0, maxThicknessLocationVert, 2*ARhoriz, taperVert);
sweepVertTE = sweepConverter(sweepVertLE, 0, 1, 2*ARvert, taperVert);

McritVert = 0.82*cosd(sweepVertLE);

%target volume coefficients
VbarH_target = 1; %horizontal volume coefficient estimates based off Raymer's historical data
VbarV_target = 0.09; %vertical volume coefficient estimates based off Raymer's historical data

%initialising loop
SHoriz = 1;
SVert = 1;
VbarH = 0.01;
VbarV = 0.01;
count = 0;

while abs(VbarH_target - VbarH) > 1e-6 || abs(VbarV_target - VbarV) > 1e-6
    %CALCULATING TAILPLANE GEOMETRY BASED ON PARAMETERS ABOVE
    SHoriz = SHoriz*VbarH_target/VbarH;
    SVert = SVert*VbarV_target/VbarV;
    
    %calculating tailplane span/height and chords
    [spanHoriz, cRootHoriz, cTipHoriz, cBarHoriz] = tailplaneSizing(SHoriz, ARhoriz, taperHoriz);
    [heightVert, cRootVert, cTipVert, cBarVert] = tailplaneSizing(SVert, ARvert, taperVert);

    % WING AND TAIL PLACEMENT

    % Note on coordinate values along the aircraft:
    % x-coordinate - measured from the nose along the fuselage centreline
    % y-coordinate - measured from the fuselage centreline, +ve along starboard
    % z-coordinate - measured from the fuselage centreline, +ve above the centreline

    %root chord root chord leading edge positions [x-coord, y-coord, z-coord]
    wingRootLE = [0.3*totalLength; 0; -0.8*fusDiamOuter/2];
    horizRootLE = [totalLength - 1.1*cRootHoriz; 0; 0.8*fusDiamOuter/2];
    vertRootLE = [horizRootLE(1) - 0.8*cRootVert; 0; fusDiamOuter/2];

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
SHorizExposed = SHoriz - 10; %approximation
SHorizWetted = SHorizExposed*(1.977 + 0.52*thicknessRatioHoriz);
SVertExposed = SVert;
SVertWetted = SVertExposed*(1.977 + 0.52*thicknessRatioVert);

%fuselage width at horizontal tailplane intersection in m
fuseWidthHoriz = 2;

% %% PLOTTING TAILPLANE AND WING GEOMETRY AND PLACEMENT
% wingPlanform = wingRootLE + tailplanePlanform(wingSpan, sweepWingLE, cRootWing, cTipWing, dihedralWing, false);
% horizPlanform = horizRootLE + tailplanePlanform(spanHoriz, sweepHorizLE, cRootHoriz, cTipHoriz, dihedralHoriz, false);
% vertPlanform = vertRootLE + tailplanePlanform(2*heightVert, sweepVertLE, cRootVert, cTipVert, dihedralVert, true);
% 
% tailplanePlot(wingPlanform, horizPlanform, vertPlanform, aftLength, mainLength, frontLength, fusDiamOuter, aftDiameter)

%% CONTROL SURFACE DESIGN

starting_position = 0.6;
ending_position = 0.95;

[Max_ail_def, y1, y2, aileron_area] = aileron_sizing_new(spanWing, ARwing, taperWing,...
    starting_position, ending_position, cRootWing);

% Assigning values to variables below
elevator_avg_chord = 0.2 * cBarHoriz;                       % Average Elevator chord in m 
elevator_span = 0.9 * spanHoriz * 0.5;                      % Elevator half span in m
elevator_max_def = 15;                                      % In degrees
elevator_area = elevator_span * elevator_avg_chord * 2;     % Total area of the elevator

rudder_avg_chord = 0.2 * cBarVert;                          % Average Rudder chord in m      
rudder_span = 0.9 * heightVert;                             % Rudder half span in m
rudder_max_def = 18.75;                                     % In degrees
rudder_area = rudder_span * rudder_avg_chord * 2;           % Total area of the rudder


%% THRUST ANALYSIS
%Finding thrust required

T_req_all_engines_fly = ThrustToWeight * W0;                                    % This is how much thrust is required to fly when all engines are operating
T_req_all_engines_operate = T_req_all_engines_fly * 1.03;                       % This is how much thrust is required accounting for losses in bleed air/equivalent systems. This would also be known as the installed thrust.
T_req_per_engine_operate = T_req_all_engines_operate/2;                         % This is how much thrust we want each engine to produce (assuming two engines)

%disp(['Look for engines that provide thrust in the range of ', num2str(round(T_req_per_engine_operate/1000)), 'kN (aka ', num2str(round(T_req_per_engine_operate*0.2248089)), ' pounds-force).'])

%Pure rubber engine sizing for sanity checking
BPR = 10;
Rubber_W = 14.7 * ((T_req_per_engine_operate/1000)^1.1) * exp(-0.045*BPR);
Rubber_L = 0.49 * ((T_req_per_engine_operate/1000)^0.4) * 0.8^0.2;
Rubber_D = 0.15 * ((T_req_per_engine_operate/1000)^0.5) * exp(0.04*BPR);
Rubber_SFC_maxT = 19 * exp(-0.12*BPR);
Rubber_T_Cruise = 0.35 * ((T_req_per_engine_operate/1000)^0.9) * exp(0.02 * BPR);
Rubber_SFC_cruise = 25 * exp(-0.05 * BPR);

Engine_Length = 4.771; %m
Engine_Radius = 1.899; %m
Engine_Diameter = 2 * Engine_Radius; %m
Engine_Mass_Dry = 6033; %kg
Engine_Takeoff_Thrust_5min = 307.8; %kN
Engine_MaxContThrust = 287.9; %kN
Engine_EquivalentBareEngine_TakeoffThrust = 310.9; %kN
Engine_EquivalentBareEngine_MaxContinuous = 290.8; %kN
Engine_BPR = 10;

%Rubber sizing selected engine to match requirements
SF = T_req_per_engine_operate/(Engine_MaxContThrust*1000);
L = Engine_Length * (SF^0.4);
D_e = Engine_Diameter * (SF^0.5);
D_f = 2.85 * (SF^0.5);
W_Engine = Engine_Mass_Dry * (SF^1.1);

%% WEIGHT ANALYSIS
Nz = 1.5*2.5;% minimum limit load factor = 2.5 according to FAR-25.337 (ultimate load factor = 1.5 x limit load factor)
Ngear = 3; %typically 2.7-3
W_avionics_uninstalled = 1000; %typically 800-1400 lb
electricRating = 60; %typically 40 − 60 for transports (kVA)
W_APU_uninstalled = 8*(1.1*N_Pax)^0.75; %(lb) Pasquale Sforza, in Commercial Airplane Design Principles, 2014
lengthEngineControl = (wingRootLE(1) + 0.2*spanWing)*unitsratio('ft', 'm'); %initial assumption
lengthElectrical = totalLength*unitsratio('ft', 'm');
W_maxTO = W0;

%Calculations
fuelFraction = (1 + TrappedFuelFactor)*(1 - ProductWFs);
numPeopleOnBoard = N_Crew + N_Pax + N_Pilots;
totalCSarea = rudder_area + elevator_area + aileron_area;
W_Landing = W_maxTO * WF1 * WF2 * WF3 * WF4 * WF5 * WF6;
W_seats = 60*N_Pilots + 32*N_Pax + 11*N_Crew; %typical 60lbs per flight deck seats, 32lbs for passenger seats
W_People = numPeopleOnBoard*Mass_Person*9.80665;
W_Luggage = numPeopleOnBoard*Mass_Luggage*9.80665;
W_maxCargo = W_Luggage;
V_Stall_Landing = V_landing/1.3;

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
W_maxTO = convforce(W_maxTO, 'N', 'lbf');
W_People = convforce(W_People, 'N', 'lbf');
W_Luggage = convforce(W_Luggage, 'N', 'lbf');
W_maxCargo = convforce(W_maxCargo, 'N', 'lbf');
W_Landing = convforce(W_Landing, 'N', 'lbf');

%Weight breakdown by component (all in lbs)

components(1).name = 'Wings'; 
components(2).name = 'Horizontal Tail';
components(3).name = 'Vertical Tail';
components(4).name = 'Fuselage';
components(5).name = 'Main LG';
components(6).name = 'Nose LG';
components(7).name = 'Engine';
components(8).name = 'Nacelle';
components(9).name = 'Engine Controls';
components(10).name = 'Engine Starter';
components(11).name = 'Handling Gear';
components(12).name = 'Fuel System';
components(13).name = 'Flight Controls';
components(14).name = 'APU';
components(15).name = 'Instruments';
components(16).name = 'Hydraulics';
components(17).name = 'Electrical System';
components(18).name = 'Avionics';
components(19).name = 'Furninshings';
components(20).name = 'Air-Conditioning';
components(21).name = 'Anti-Icing';
components(22).name = 'People';
components(23).name = 'Luggage';
components(24).name = 'Fuel';

%lifting surfaces
components(1).weight = W_wings(W_maxTO, Nz, SWing, ARwing, taperWing, aileron_area, sweepWingQC, thicknessRatioWing);
components(2).weight = W_horizTail(W_maxTO, Nz, SHoriz, ARhoriz, elevator_area, lHoriz, fuseWidthHoriz, spanHoriz, sweepHorizQC);
components(3).weight = W_vertTail(W_maxTO, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert);

%fuselage and undercarriage
components(4).weight = W_fuse(W_maxTO, Nz, taperWing, spanWing, sweepWingQC, totalLength, totalArea, fusDiamOuter);
components(5).weight = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, Vstall_Landing, NmainShockStruts);
components(6).weight = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels);

%engine and fuel system
components(7).weight = W_engine; %REMEMBER TO INCLUDE ACTUAL ENGINE WEIGHT
components(8).weight = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumberOfEngines, SnacelleWetted);
components(9).weight = 5*NumberOfEngines + 0.8*lengthEngineControl; %lengthEngineControl = engine to cockpit total length (ft)
components(10).weight = W_engineStarter(NumberOfEngines, W_engine);
components(11).weight = 3e-4*W_maxTO;
components(12).weight = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank);

%subsystems
components(13).weight = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, totalCSarea, lHoriz);
components(14).weight = 2.2*W_APU_uninstalled; %installed APU weight
components(15).weight = W_instruments(N_crew, NumberOfEngines, totalLength, spanWing);
components(16).weight = W_hydraulics(numControlFunctions, totalLength, spanWing);
components(17).weight = W_electrical(electricRating, lengthElectrical, NumberOfEngines);
components(18).weight = 1.73 * W_avionics_uninstalled^0.983; %installed avionics weight (uninstalled typically 800-1400lbs)
components(19).weight = W_furnish(N_crew, W_maxCargo, totalArea, W_seats, numPeopleOnBoard);
components(20).weight = W_aircon(numPeopleOnBoard, volumePressurised, W_avionics_uninstalled);
components(21).weight = 0.002*W_maxTO;
emptyWeight = sum([components(1:21).weight]);

components(22).weight = W_People; %crew + pax
components(23).weight = W_Luggage; %luggage of crew + pax
components(24).weight = (emptyWeight + W_People + W_Luggage)*fuelFraction/(1 - fuelFraction);
totalWeight = sum([components.weight]);

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
lHoriz = lHoriz/unitsratio('ft', 'm');
lVert = lVert/unitsratio('ft', 'm');
fusDiamOuter = fusDiamOuter/unitsratio('ft', 'm');
totalLength = totalLength/unitsratio('ft', 'm');
V_Stall_Landing = V_Stall_Landing/unitsratio('ft', 'm');

%lb to N
W_maxTO = convforce(W_maxTO, 'lbf', 'N');
W_Crew = convforce(W_Crew, 'lbf', 'N');
W_Luggage = convforce(W_Luggage, 'lbf', 'N');
W_Landing = convforce(W_Landing, 'lbf', 'N');
W_maxCargo = convforce(W_maxCargo, 'lbf', 'N');
emptyWeight = convforce(emptyWeight, 'lbf', 'N');
totalWeight = convforce(totalWeight, 'lbf', 'N');

for i = length(components)
    components(i).weight = convforce(components(i).weight, 'lbf', 'N');
    components(i).mass = components(i).weight/9.80665; %N to kg
end


%% BALANCE ANALYSIS
%CG of each component (in meters [x; y; z])

%lifting surfaces
components(1).cog = wingRootLE + liftingSurfraceCG(0.6, 0.35, spanWing, taperWing, cRootWing, dihedralWing, sweepWingLE, false);
components(2).cog = horizRootLE + liftingSurfaceCG(0.42, 0.38, spanHoriz, taperHoriz, cRootHoriz, dihedralHoriz, sweepHorizLE, false);
components(3).cog = vertRootLE + liftingSurfaceCG(0.42, 0.38, 2*heightHoriz, taperVert, cRootVert, dihedralVert, sweepVertLE, true);

%fuselage and undercarriage
components(4).cog = [0.45*totalLength; 0; 0];
components(5).cog = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, V_Stall_Landing, NmainShockStruts);
components(6).cog = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels);

%engine and fuel system
components(7).cog = W_engine;
components(8).cog = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumberOfEngines, SnacelleWetted);
components(9).cog = 5*NumEngines + 0.8*lengthEngineControl; %lengthEngineControl = engine to cockpit total length (ft)
components(10).cog = W_engineStarter(NumEngines, W_engine);
components(11).cog = 'Handling Gear';
components(12).cog = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank);

%subsystems
components(13).cog = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, StotalCS, lHoriz);
components(14).cog = [frontLength + mainLength + 0.65*aftLength; 0; 1.2];
components(15).cog = W_instruments(N_crew, NumberOfEngines, totalLength, spanWing);
components(16).cog = W_hydraulics(numControlFunctions, totalLength, spanWing);
components(17).cog = W_electrical(electricRating, lengthElectrical, NumberOfEngines);
components(18).cog = [frontLength + 0.2*mainLength; 0; -fusDiamOuter/2];
components(19).cog = [frontLength + 0.5*mainLength; 0; 0];
components(20).cog = W_aircon(numPeopleOnBoard, volumePressurised, W_avionics_uninstalled);
components(21).cog = 0.002*W_maxTO;

components(22).cog = 'People';
components(23).cog = 'Luggage';
components(24).cog = 'Fuel';

%calculating CG
CGempty = sum([components(1:21).mass].*[components(1:21).cog], 2)/sum([components(1:21).mass]);
CGfull = sum([components.mass].*[components.cog], 2)/sum([components.mass]);


%% Aerodynamic Analysis
l=[cBarWing,totalLength,8,cBarHoriz,cBarVert];
xtocmax=[0.349,0,0,maxThicknessLocationHoriz,maxThicknessLocationVert];
ttoc=[thicknessRatioWing,0,0,thicknessRatioHoriz,thicknessRatioVert];
theta_max=[sweepWingMT,0,0,sweepHorizMT,sweepVertMT];
S_wet_all=[SWingWetted,totalArea,90,SHorizWetted,SVertWetted];
flapped_ratio=0.487;
chord_ratio=1.26;
sweepWingTE=20.9647;
upsweep_angle=15*(pi/180);
Cl_tail_airfoil=1.4;

%Aerodynamics: Lift
[CL_a,CL_max_clean,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(ARwing,SWingExposed,SWing,fusDiamOuter,spanWing,M,sweepWingMT,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,sweepWingQC,sweepWingTE);
[CL_a_M0]=WingLift(ARwing,SWingExposed,SWing,d,spanWing,0,sweepWingMT,Cl_am,chord_ratio,Cl_wing_airfoil,flapped_ratio,sweepWingQC,sweepWingTE);
CL_a_Total=[CL_a(1)*takeoff_factor,CL_a(2),CL_a(3)*landing_factor];
[CL_ah,CL_max_h]=TailLift(ARhoriz,d,spanHoriz,M,sweepHorizMT,10.5214,Cl_tail_airfoil,sweepHorizQC);
[maxLiftLanding,maxLiftTakeoff]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_h,SHoriz,SWing,rho_landing,V_landing,rho_takeoff,V_takeoff);

%Aerodynamics: Drag 
[CD_Parasitic_Cruise,CD_Parasitic_Total_Cruise,CD_LandP_Cruise,Re,Cfc,FF]=Parasitic(rho_cruise,V_Cruise,l,nu_cruise,M_Cruise,xtocmax,ttoc,theta_max,fuselage_length,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,SWing);
[CD_Parasitic_Takeoff,CD_Parasitic_Total_Takeoff,CD_LandP_Takeoff]=Parasitic(rho_takeoff,V_takeoff,l,nu_takeoff,M_takeoff,xtocmax,ttoc,theta_max,fuselage_length,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,SWing);
[CD_Parasitic_Landing,CD_Parasitic_Total_Landing,CD_LandP_Landing]=Parasitic(rho_landing,V_landing,l,nu_landing,M_landing,xtocmax,ttoc,theta_max,fuselage_length,fusDiamOuter,nacelle_length,nacelle_diameter,S_wet_all,SWing);
[CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,SWing,flapspan,spanWing,flap_deflection_takeoff,flap_deflection_landing,Aeff,fusDiamOuter,upsweep_angle);
[CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing);

%% STABILITY ANALYSIS

%aircraft fuselage pitching moment contribution
CMalphaF = fuselagePitchingMoment(totalLength, fusDiamOuter, cBarWing, SWing, wingRootLE(1) + 0.25*cBarWing);

%wing downwash on tailplane d(e)/d(alpha) 
downwash = downwash(lHoriz, hHoriz, spanWing, sweepWingQC, ARwing, taperWing, CL_a_Total, CL_a_M0);

%neutral point and static margin
[xNPOff, KnOff, xNPOn, KnOn] = staticStability(CG, SWing, SHoriz, wingAC(1), horizAC(1), cBarWing, CL_ah, CL_a_Total, CMalphaF, downwash, etaH);


%% TRIM ANALYSIS

%wing aerofoil parameters
CMoAerofoilW = -0.03; %Sforza and -0.04 according to airfoiltools (xfoil)
alpha0W = -1.6; %degrees

%wing zero-lift pitching moment coefficient
CMoW = zeroLiftPitchingMoment(CMoAerofoilW, ARwing, sweepWingQC, twistWing, CL_a_Total, CL_a_M0);

%required lift coefficient and drag at cruise 
[~,~,~,rhoCruise]= atmosisa(distdim(35000,'ft','m'));
CLtarget(1:3) = WingLoading/(0.5*rhoCruise*V_Cruise^2); %CHANGE IT TO SPECIFIC WEIGHT, RHO, AND VELOCITY AT EACH SEGMENT

%determine iH and AoA for trimmed flight
[iH_trim, AoA_trim, AoA_trimWings, AoA_trimHoriz, CL_trimWings, CL_trimHoriz] = ...
    trimAnalysis(CG, wingAC, horizAC, enginePosition, cBarWing, SWing, SHoriz, ...
    CMoW, CMalphaF, CLtarget, CD_Total, CL_a_Total, CL_ah, twistWing, alpha0W, alpha0H, downwash, etaH);

%% TOTAL DRAG AT TRIM
[CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,SWing,CD_0_Total,rho_landing,V_landing,ARwing);

%% Once everything converges, populate the csv

% write values to csv
