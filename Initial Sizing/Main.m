%% Aerospace Vehicle Design Group 1 Chai-liner

%% Housekeeping

clear
clc
close all

%% Initial Sizing

% Inputs
% Update values, specially SwetSref!
load("DesignBriefTargets.mat") 
Mass_Person = 75; 
Mass_Luggage = 31; 
C_Cruise = 14.1 * 0.035316;
C_Divert = 11.55 * 0.035316;
C_Loiter = 11.3 * 0.035316;
K_LD = 15.5;
AspectRatio = 10.5;
SWet_SRef = 6;
TrappedFuelFactor = 0.02;
H_Divert = 12000;

% Functions
% Updated weight fractions, sanity check with team!
[W_Payload, W_Crew] = payloadAndCrewWeights(N_Pilots, N_Crew, N_Pax, Mass_Person, Mass_Luggage);
L_DMax = LiftToDragRatio(K_LD, AspectRatio, SWet_SRef);
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

%% Sizing to Constraints

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
[Const_WS_Cruise, Const_TW_Cruise] = SEP(H_Cruise, V_Cruise, 0, 0, WF1*WF2*WF3*WF4, beta_Cruise, 1, AspectRatio, e_Cruise, C_D0_Cruise);
[Const_WS_Divert, Const_TW_Divert] = SEP(H_Divert, V_Divert, 0, 0, WF1*WF2*WF3*WF4*WF5*WF6*WF7, beta_Divert, 1, AspectRatio, e_Divert, C_D0_Divert);
[Const_WS_Loiter, Const_TW_Loiter] = SEP(H_Loiter, V_Loiter, 0, 0, WF1*WF2*WF3*WF4*WF5*WF6*WF7*WF8, beta_Loiter, 1, AspectRatio, e_Loiter, C_D0_Loiter);
[Const_WS_MaxSpeed, Const_TW_MaxSpeed] = SEP(H_Cruise, V_MaxVelocity, 0, 0, WF1*WF2*WF3*WF4, beta_Cruise, 1, AspectRatio, e_Cruise, C_D0_Cruise);
[Const_WS_ConsVT, Const_TW_ConsVT] = ConsVT(rho_ConsVT, 30, V_Loiter);
[Const_WS_AbsCeil, Const_TW_AbsCeil, TargetMatchX, TargetMatchY] = Absolute_Ceiling(H_Absolute, 1, alpha_AbsC, beta_AbsC, L_DMax, C_D0_AbsC, AspectRatio, e_AbsC);
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

% Outputs
% Sanity check graph!
figure(1)
plot(Const_WS_Cruise, Const_TW_Cruise, '--', 'LineWidth', 1.5)
hold on
plot(Const_WS_Divert, Const_TW_Divert, '--', 'LineWidth', 1.5)
plot(Const_WS_Loiter, Const_TW_Loiter, '--', 'LineWidth', 1.5)
plot(Const_WS_MaxSpeed, Const_TW_MaxSpeed, 'LineWidth', 1.5)
plot(Const_WS_ConsVT, Const_TW_ConsVT, '--', 'LineWidth', 1.5)
plot(Const_WS_AbsCeil, Const_TW_AbsCeil, '--', 'LineWidth', 1.5)
plot(Const_WS_TakeOff, Const_TW_TakeOff, 'LineWidth', 1.5)
plot(Const_WS_OEI, Const_TW_OEI, '--', 'LineWidth', 1.5)
plot(Const_WS_LandingTrev, Const_TW_LandingTrev, '--', 'LineWidth', 1.5)
plot(Const_WS_LandingNoTrev, Const_TW_LandingNoTrev, 'LineWidth', 1.5)
plot(TargetMatchX, TargetMatchY, 'x', 'LineWidth', 1.5)
plot(WingLoading, ThrustToWeight, 'o', 'LineWidth', 1.5)
ylim([0 1])
xlim([0 12500])
grid on
legend('Cruise', 'Diversion', 'Loiter', 'Maximum velocity', 'Constant Velocity 30 deg Turns', 'Absolute Ceiling', 'Take-off', 'OEI', 'Landing with trev', 'Landing w/o trev', 'VimD optimiser', 'Selected Design Point')
hold off
saveas(figure(1), 'Constraints Diagram', 'png') 
disp(['The design point selected gives a wing loading of ', num2str(WingLoading), ' N/m^2 and a thrust to weight ratio of ', num2str(ThrustToWeight), '.'])

save('InitialSizing')
% Reasoning:

% Our entire initial sizing and therefore constraints analysis is based on
% the target/assumption that the aircraft we make would have a VimD (in
% cruise conditions) such that when it begins its cruise segment, its
% flying at exactly sqrtsqrt(3) * VimD. This would essentially optimise the
% longest flight segment of the aircraft and therefore is a great target to
% attempt to reach in order to optimise the entire aircraft.

% While plotting absolute ceiling, I realised that in order to allow VimD
% to change with wing loading, you cannot consider this optimum VimD. You
% can however search within the array to find the wing loading at which the
% VmD nearest matches the target VmD (for absolute ceiling). Performing
% this search gives a single point which I've plotted as a cross. While
% changing some numbers I realised that no matter what the inputs are, the
% absolute ceiling line and cruise line would ALWAYS intersect exactly
% where the cross is. This was totally unintentional and is purely a result
% of the target/assumption we have used. Now what I'm trying to say is that
% we can possibly use this as the wing loading which optimises cruise
% efficiency. I know that Errikos suggested a different method (which
% essentially compares weight of engines and wing etc etc basically
% optimising for better mass), but if we can hit optimum cruise efficiency,
% a little more mass may not hurt. 

% As such, the initial sizing and sizing to constraints are fairly
% independent. The only things that affect sizing to constraints are the
% very first inputs and the weight fractions.