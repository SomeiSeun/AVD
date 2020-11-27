% Creating a programme to put all performance/control surface metrics in one place

clear
clc

% Loading in the relevant .mat files
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat');
load('tailplane_Sizing_variable_values.mat'); 
load('../Aerodynamics/AerodynamicsMain.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_S1 = sqrt((2 * W0) / (1.225 * Sref * CL_max_clean_wing));   % Finding out the stall speed in clean config
V_stall_takeoff = sqrt((2 * W0) / (1.225 * Sref* CL_max_takeoffconfig)); % Stall speed in take off config

C_L_climb = L / (0.5 * 1.225 * (1.15 * V_S1)^2 * Sref);  % Lift Coefficient at Transition phase
C_D_climb = D / (0.5 * 1.225 * (1.15 * V_S1)^2 * Sref);  % Drag Coefficient at Transition phase
L_over_D = C_L_climb / C_D_climb;                        % Lift to drag ratio at Transition phase
% ^ NEED LIFT AND DRAG VALUES AT TRANSITION PHASE

% This equation gives the Take off distance in metres
S_to = Take_off_distance(V_stall_takeoff, V_S1, T, W0,...
    Cd0_takeoff, AspectRatio, e, Cl0, L_over_D, Sref)    
% ^ Values still needed: Cd0_takeoff, e, Cl0, T
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W_L = W0 * WF8 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF9 * WF10;
% ^ Weight of the flight at start of landing phase

VS0 = sqrt((2 * W_L) / (1.225 * Sref * CL_max_landing));         % Stall speed in Landing config
% ^ NEED THE CL_MAX_LANDING VALUE

% This equation gives the Landing distance in metres
S_L = Landing_distance(Cl0, V_S1, W_L, VS0,...
    T_L, L_over_D_landing, Sref, AspectRatio, e) 
% ^ Values still needed: Cl0, T_L, L_over_D_landing, e
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This equation gives the Balanced Field Length in metres
BFL = Balanced_Field_Length(W0, Sref, Cl_TakeOff,...
    T_oei, D2, BPR, Cl_climb, T_takeoff_static)
% ^ Values still needed: T_oei, D2, BPR, Cl_climb, T_takeoff_static
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This section gives the Range, Endurance and Fuel Consumption for the 2 cruise phases

W_ini_1 = W0 * WF1 * WF2 * WF3 * WF4;       % Weight at start of cruise 1 in Newtons
W_fin_1 = W0 * WF1 * WF2 * WF3 * WF4 * WF5; % Weight at end of cruise 1 in Newtons
c_t1 = 14.10 * 9.81 / 1000000;              % Thrust Specific Fuel Consumption for Cruise 1 in 1/second
C_Dmin = 0.01783;                           % Just a random value for the time being
[E1, R1, FC1] = Range(W_ini_1, rho_cruise, V_Cruise, Sref,...
    C_Dmin, c_t1, AspectRatio, W_fin_1, e_Cruise); 
% ^ Values still needed: C_Dmin

W_ini_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7;        % Weight at start of cruise 2
W_fin_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8;  % Weight at end of cruise 2
rho_cruise_2 = 0.849137;                                       % Density of air at 12000 ft in kg/m^3
c_t2 = 11.55 * 9.81 / 1000000;              % Thrust Specific Fuel Consumption for Cruise 2 in 1/second

[E2, R2, FC2] = Range(W_ini_2, rho_cruise_2, V_Divert, Sref,...
    C_Dmin, c_t2, AspectRatio, W_fin_2, e_Cruise); 
% ^ Values still needed: C_Dmin

W_ini_3 = W_fin_2;                                                  % Weight of aircraft at start of Loiter
W_fin_3 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8 * WF9; % Weight of aircraft at end of Loiter
rho_cruise_3 = 1.05555;                                             % Density of air at 5000 ft in kg/m^3
c_t3 = 11.30 * 9.81 / 1000000;             % Thrust Specific Fuel Consumption for Loiter in 1/second

[E3, R3, FC3] = Range(W_ini_3, rho_cruise_3, V_Loiter, Sref,...
    C_Dmin, c_t3, AspectRatio, W_fin_3, e_Loiter); 
% ^ Values still needed: C_Dmin

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

W = W_ini_1;  % Weight of the aircraft at start of cruise 1

[L_over_D_max, Vs_Cruise, V_LDmax, V_max, V_min] = Cruise_leg_calculations(C_Dmin,...
    C_LminD, AspectRatio, e_Cruise, rho_cruise, W, Sref, C_Lmax, 1, T)
% ^ Values still needed: C_Dmin, C_LminD, C_Lmax, T

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This section plots a graph for Altitude against Rate of climb which is
% then used to find the Absolute and Service ceilings

W_cruise = W_ini_1;  % Weight of aircraft at start of cruise 1
[ROC_max, altitude] = climb(W_ini_1, C_Dmin, L_DMax, Sref);  
% ^ Values still needed: C_Dmin, Thrust (Equation needed inside the function)

figure 1
plot(ROC_max, altitude, '-xr')
xlabel('Maximum Rate of Climb (feet/minute)');
ylabel('Altitude (feet)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The equation below gives the Maximum aileron deflection and the time 
% taken by the aircraft to achieve the max bank angle
[t, Max_ail_def, y1, y2] = aileron_sizing_new(b, Sref, AspectRatio,...
    TaperRatio, CL_a_landing, VS0, Ixx, Sref, S_HT, S_VT)
% ^ Values still needed: Ixx

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Saving the .mat file
filename = 'Performance_and_control_surface_values.mat' ;

save(filename, 'S_to', 'S_L', 'BFL', 'E1', 'R1', 'FC1',...
    'E2', 'R2', 'EC2', 't', 'Max_ail_def', 'L_over_D_max',...
    'Vs_cruise', 'V_LDmax', 'V_max', 'V_min', 'y1', 'y2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%