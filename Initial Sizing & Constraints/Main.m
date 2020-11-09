%% Aerospace Vehicle Design Group 1 Chai-liner

%% Housekeeping
clear
clc

%% Initial Sizing
%Loads all the "givens"
load("DesignBriefTargets.mat") 

% Maybe make a separate function which takes ALL inputs for initial sizing
% etc using a cool ass dialog box, with preset values to avoid having to
% type each time, with values updating to newly changed values if user asks
% somehow.

% Inputs (hard-coded for now)
Mass_Person = 75; %input("Enter mass of person ");
Mass_Luggage = 31; %input("Enter mass of luggage allowed");
C_Cruise = 14.1 * 0.035316;
C_Divert = 11.55 * 0.035316;
C_Loiter = 11.3 * 0.035316;
K_LD = 15.5;
AspectRatio = 10.5;
SWet_SRef = 5.6;
TrappedFuelFactor = 0.02;
H_Divert = 12000;

% Functions
[W_Payload, W_Crew] = payloadAndCrewWeights(N_Pilots, N_Crew, N_Pax, Mass_Person, Mass_Luggage);
L_DMax = LiftToDragRatio(K_LD, AspectRatio, SWet_SRef);

WF1 = WFLeg1();
WF2 = WFLeg2();
WF3 = WFLeg3();
WF4 = WFLeg4();
WF5 = WFLeg5(R_Cruise, C_Cruise, H_Cruise, M_Cruise, L_DMax);
VimD = VimDCalculator(H_Cruise, M_Cruise);
WF6 = WFLeg6();
WF7 = WFLeg7();
WF8 = WFLeg8(R_Divert, C_Divert, H_Divert, L_DMax, VimD, WF5*WF6*WF7);
WF9 = WFLeg9(E_Loiter, C_Loiter, L_DMax, VimD, WF5*WF6*WF7*WF8, H_Loiter);
WF10 = WFLeg10;
WF11 = WFLeg11;

ProductWFs = WF1*WF2*WF3*WF4*WF5*WF6*WF7*WF8*WF9*WF10*WF11;

% Outputs
W0 = RoskamGimmeMTOW(ProductWFs, W_Payload, W_Crew, TrappedFuelFactor);

%% Sizing to Constraints

[T_Over_W_0, W_SRef] = Take_off_constraint(2200, 1.7, 1);
plot(W_SRef, T_Over_W_0)
