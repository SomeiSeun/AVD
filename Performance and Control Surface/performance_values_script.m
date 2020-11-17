% Creating a programme to put all performance metrics in one place

clear
clc

% Loading in the relevant .mat files
load('../Initial Sizing/InitialSizing.mat')
load('../Aerodynamics/wingDesign.mat');
load('../Static Stability/tailplane_Sizing_variable_values.mat'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This equation gives the Take off distance in metres
S_to = Take_off_distance(alpha_liftoff, V_stall_takeoff, V_S1, T, W0,...
    Cd0_takeoff, AspectRatio, e, Cl0, Cl_alpha, alpha_T0, L_over_D, Sref)    
% ^ Values still needed: Cd0_takeoff, e, Cl0, Cl_alpha, alpha_liftoff,
% V_stall_takeoff, V_S1, T, alpha_T0, L_over_D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W_L = W0 * WF8 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF9 * WF10;
% ^ Weight of the flight at start of landing phase

% This equation gives the Landing distance in metres
S_L = Landing_distance(Cl0, Cl_alpha, V_S1, W_L, VS0,...
    T_L, L_over_D_landing, Sref, AspectRatio, e) 
% ^ Values still needed: Cl0, Cl_alpha, V_S1, VS0, T_L, L_over_D_landing, e
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This equation gives the Balanced Field Length in metres
BFL = Balanced_Field_Length(W0, Sref, Cl_TakeOff,...
    T_oei, D2, BPR, Cl_climb, T_takeoff_static)
% ^ Values still needed: T_oei, D2, BPR, Cl_climb, T_takeoff_static
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This section gives the Range, Endurance and Fuel Consumption for the 2
% cruise phases

W_ini_1 = W0 * WF1 * WF2 * WF3 * WF4;       % Weight at start of cruise 1
W_fin_1 = W0 * WF1 * WF2 * WF3 * WF4 * WF5; % Weight at end of cruise 1

[E1, R1, FC1] = Range(W_ini_1, rho_cruise, V_cruise, Sref,...
    C_Dmin, c_t, AspectRatio, W_fin_1, e_Cruise); 
% ^ Values still needed: C_Dmin, c_t (needs to be converted to 1/s units)

W_ini_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7;        % Weight at start of cruise 2
W_fin_2 = W0 * WF1 * WF2 * WF3 * WF4 * WF5 * WF6 * WF7 * WF8;  % Weight at end of cruise 2
rho_cruise_2 = 0.849137;   % Density of air at 12000 ft in kg/m^3

[E2, R2, FC2] = Range(W_ini_2, rho_cruise_2, V_Divert, Sref,...
    C_Dmin, c_t, AspectRatio, W_fin_2, e_Cruise); 
% ^ Values still needed: C_Dmin, c_t 

disp('The Endurance of the aircraft during Cruise 1 is', E1, ' hours.');
disp('The Endurance of the aircraft during Cruise 2 is', E2, ' hours.');
disp('The Range of the aircraft during Cruise 1 is', R1, ' km.');
disp('The Range of the aircraft during Cruise 2 is', R2, ' km.'); 
disp('The fuel consumption of the aircraft during Cruise 1 is', FC1, '.');
disp('The fuel consumption of the aircraft during Cruise 2 is', FC2, '.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The equation below is used to find several variables during cruise 1
% phase of the flight

W = W_ini_1;  % Weight of the aircraft at start of cruise 1

[L_over_D_max, Vs_Cruise, V_LDmax, V_max, V_min] = Cruise_leg_calculations(C_Dmin,...
    C_LminD, AspectRatio, e_Cruise, rho_cruise, W, Sref, C_Lmax, 1, T)
% ^ Values still needed: C_Dmin, C_LminD, C_Lmax, T

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This section plots a graph for Altitude against Rate of climb which is
% then used to find the Absolute and Service ceilings

W_cruise = W_ini_1;  % Weight of aircraft at start of cruise 1
[ROC_max, altitude] = climb(W_cruise, C_Dmin, L_over_D_max, Sref);  
% ^ Values still needed: C_Dmin

figure 1
plot(ROC_max, altitude, '-xr')
xlabel('Maximum Rate of Climb (feet/minute)');
ylabel('Altitude (feet)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The equation below gives the Maximum aileron deflection and the time
% taken by the aircraft to achieve the max bank angle
[t, Max_ail_def] = aileron_sizing_new(b, Sref, AspectRatio, TaperRatio, C_L_aw, Vs, Ixx, S_w, S_ht, S_vt)
% ^ Values still needed: C_L_aw, Ixx, S_w, S_ht, S_vt, Vs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Saving the .mat file
filename = 'Performance_and_control_surface_values.mat' ;

save(filename, 'S_to', 'S_L', 'BFL', 'E1', 'R1', 'FC1',...
    'E2', 'R2', 'EC2', 't', 'Max_ail_def', 'L_over_D_max', 'Vs_cruise', 'V_LDmax', 'V_max', 'V_min');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%