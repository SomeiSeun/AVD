% Creating a programme to put all performance/control surface metrics in one place

clear
clc

% Adding a path to access the Thrust Lapse Model
addpath('C:\Users\usain\Documents\Aerospace Vehicle Design\Programmes\Git Kraken codes\AVD\Powerplant');

% Loading in the relevant .mat files
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat');
load('../Static Stability/tailplaneSizing.mat'); 
load('AerodynamicsFINAL.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_S1 = sqrt((2 * W0) / (1.225 * Sref * CLmax_clean));              % Finding out the stall speed in clean config
V_stall_takeoff = sqrt((2 * W0) / (1.225 * Sref* CL_max_takeoff)); % Stall speed in take off config

beta_thrust_ratio_takeoff = ThrustLapseModel(0, 0, 0.8, 35000); % Finding out Beta value during takeoff
L_over_D_transition = CL_max_takeoff/CD_Total(1);               % Lift to drag ratio at Transition phase
T_dummy = W0 * ThrustToWeightTakeOff;      
T_Takeoff = T_dummy * beta_thrust_ratio_takeoff; % Finding out the Takeoff Thrust

% This equation gives the Take off distance in metres
S_to = Take_off_distance(V_stall_takeoff, V_S1, T_Takeoff, W0,...
    CD_0_Total(1), AspectRatio, e_Cruise, zeroAlphaLCT, L_over_D_transition, Sref);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W_L = W0 * WF8 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF9 * WF10;
% ^ Weight of the flight at start of landing phase

VS0 = sqrt((2 * W_L) / (1.225 * Sref * CL_max_landing)); % Stall speed in Landing config
L_over_D_landing = CL_max_landing/CD_Total(3);           % Lift to Drag ratio in landing config
landing_velocity = 1.1 * VS0;                            % Landing velocity
landing_velocity_mach = landing_velocity / sqrt(1.4 * 287 * 288.051); % Mach number for landing velocity

beta_thrust_ratio_landing = ThrustLapseModel(landing_velocity_mach,...
    50, 0.8, 35000);                                     % Beta value for landing
T_L = T_dummy * beta_thrust_ratio_landing;               % Thrust during landing in Newtons

% This equation gives the Landing distance in metres
S_L = Landing_distance(zeroAlphaLCT, V_S1, W_L, VS0,...
    T_L, L_over_D_landing, Sref, AspectRatio, e_Cruise, CD_0_Total(3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D2 = 0.5 * 1.225 * Sref * 1.44 * V_stall_takeoff^2 * CD_Total(1);
T_oei = 0.5 * T_Takeoff;
T_takeoff_static = T_dummy; 

% This equation gives the Balanced Field Length in metres
BFL = Balanced_Field_Length(W0, Sref, CL_TakeOff,...
    T_oei, D2, 10, CL_max_landing, T_takeoff_static);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section gives the Range, Endurance and Fuel Consumption for the 2 cruise phases

W_ini_1 = W0 * WF1 * WF2 * WF3 * WF4;       % Weight at start of cruise 1 in Newtons
W_fin_1 = W0 * WF1 * WF2 * WF3 * WF4 * WF5; % Weight at end of cruise 1 in Newtons
c_t1 = 14.10 * 9.81 / 1000000;              % Thrust Specific Fuel Consumption for Cruise 1 in 1/second
[E1, R1, FC1] = Range(W_ini_1, rho_cruise, V_Cruise, Sref,...
    0.0440, c_t1, AspectRatio, W_fin_1, e_Cruise); 

W_ini_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7;        % Weight at start of cruise 2
W_fin_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8;  % Weight at end of cruise 2
rho_cruise_2 = 0.849137;                                       % Density of air at 12000 ft in kg/m^3
c_t2 = 11.55 * 9.81 / 1000000;              % Thrust Specific Fuel Consumption for Cruise 2 in 1/second

[E2, R2, FC2] = Range(W_ini_2, rho_cruise_2, V_Divert, Sref,...
    0.0440, c_t2, AspectRatio, W_fin_2, e_Cruise); 

W_ini_3 = W_fin_2;                                                  % Weight of aircraft at start of Loiter
W_fin_3 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8 * WF9; % Weight of aircraft at end of Loiter
rho_cruise_3 = 1.05555;                                             % Density of air at 5000 ft in kg/m^3
c_t3 = 11.30 * 9.81 / 1000000;             % Thrust Specific Fuel Consumption for Loiter in 1/second

[E3, R3, FC3] = Range(W_ini_3, rho_cruise_3, V_Loiter, Sref,...
    0.0440, c_t3, AspectRatio, W_fin_3, e_Loiter); 

fprintf('The Endurance of the aircraft during Cruise 1 is %f hours.\n',E1);
fprintf('The Endurance of the aircraft during Cruise 2 is %f hours.\n',E2);
fprintf('The Endurance of the aircraft during Loiter is %f hours.\n',E3);
fprintf('The Range of the aircraft during Cruise 1 is %f km.\n',R1);
fprintf('The Range of the aircraft during Cruise 2 is %f km.\n',R2);
fprintf('The Range of the aircraft during Loiter is %f km.\n',R3);
fprintf('The fuel consumption of the aircraft during Cruise 1 is %f.\n',FC1);
fprintf('The fuel consumption of the aircraft during Cruise 2 is %f.\n',FC2);
fprintf('The fuel consumption of the aircraft during Loiter is %f.\n',FC3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The equation below is used to find several variables during cruise 1 phase of the flight

W = W_ini_1;            % Weight of the aircraft at start of cruise 1
beta_thrust_ratio_cruise = ThrustLapseModel(0.8, 35000, 0.8, 35000);
T_cruise = T_dummy * beta_thrust_ratio_cruise; 

[L_over_D_max, Vs_Cruise, V_LDmax, V_max, V_min] = Cruise_leg_calculations(CD_min(2),...
    0.7853, AspectRatio, e_Cruise, rho_cruise, W, Sref, CL_max_clean, 1, T_cruise);
% ^ Values still needed: C_LminD (0.7853 for now) (COULD CHANGE)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section plots a graph for Altitude against Rate of climb which is
% then used to find the Absolute and Service ceilings

W_cruise = W_ini_1;  % Weight of aircraft at start of cruise 1
[ROC_max, altitude] = climb(W_ini_1, CD_Total(2), 18, Sref, T_dummy);  

figure 
plot(altitude, ROC_max, '-xr')
ylabel('Maximum Rate of Climb (feet/minute)');
xlabel('Altitude (feet)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Ixx = 8.716*10^6; 

% The equation below gives the Maximum aileron deflection and the time 
% taken by the aircraft to achieve the max bank angle
[t, Max_ail_def, y1, y2] = aileron_sizing_new(b, Sref, AspectRatio,...
    TaperRatio, CL_a_Total(3), VS0, Ixx, Sref, SHoriz, SVert, 0.61, 0.89, root_chord);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Climb rate during OEI
climb_rate = tan(asin((0.5 * (ThrustToWeightTakeOff)) - (CD_Total(1) / CL_max_takeoff))); 
fprintf('The climb rate during OEI Take off is %f. \n',climb_rate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Saving the .mat file
filename = 'Performance_and_control_surface_values.mat' ;

save(filename, 'S_to', 'S_L', 'BFL', 'E1', 'R1', 'FC1',...
    'E2', 'R2', 'EC2', 't', 'Max_ail_def', 'L_over_D_max',...
    'Vs_cruise', 'V_LDmax', 'V_max', 'V_min', 'y1', 'y2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%