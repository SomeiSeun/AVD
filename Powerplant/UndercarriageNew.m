%% Undercarriage

% This script is going to be used to follow the suggested process in slides
% for sizing the undercarriage.

%% Housekeeping
clear
clc
close all

%% Get data
load('../Initial Sizing/InitialSizing.mat', 'W0')

%% Step 1: Assume tire pressure, number of u/c struts and wheels per strut

% Inputs
NoseTirePressure = 150;
MainTirePressure = 150;
NoseStruts = 1;
NoseWheelsPerStrut = 2;
MainStruts = 2;
MainWheelsPerStrut = 4;

%% Step 2: Place u/c (assuming CG height and position)

% Inputs 1: Assuming CG height and position
x_cg_max = 32;                                                                  % Allowing for the fact that CG approximations are not going to be accurate yet
x_cg_min = 30;                                                                  % See above
x_cg_avg = (x_cg_max + x_cg_min)/2;                                             % If required
y_cg = 0;                                                                       % For completeness sake, should be zero for symmetric aircraft
z_cg_max = 3;                                                                   % Again allowing deviation
z_cg_min = 2;                                                                   % Value not really used tbh so might not be required
z_cg_avg = (z_cg_max + z_cg_min)/2;                                             % If required

% Inputs 2: Assuming other inputs required to place u/c
Length_ac = 60;                                                                 % Only really relevant for plotting the graph within limits
W_NoseGear_Ratio_Max = 0.20;                                                    % Assumption from slides - to prevent overloading
W_NoseGear_Ratio_Min = 0.05;                                                    % Assumption from slides - to prevent loss of steering friction
x_ng_min = 5;                                                                   % Foremost position of nose gear possible (based on nose and cockpit geometry)
x_fuse_tapers = 50;                                                             % Point where fuselage starts to taper upwards (for tailstrike calculations)
AoA_liftoff = 5;                                                                % Required to know largest angle encountered near ground (for tailstrike calculations)
AoA_landing = 2;                                                                % Angles given in degrees
AoA_GroundMax = max([AoA_landing, AoA_liftoff]);                                % Simplify
ground_clearance = 1.5;                                                         % Required for a lot of things, probably would need to be iterated within the code
overturn_angle = 63;                                                            % Assumption from slides
y_mg_max = 3;                                                                   % Limitations can arise due to structural constraints

% Functions
[x_NoseGear, x_MainGear] = PlaceMyUndercarriage(x_cg_max, x_cg_min, ...
    z_cg_max, Length_ac, W_NoseGear_Ratio_Max, W_NoseGear_Ratio_Min, ...
    x_ng_min, x_fuse_tapers, AoA_liftoff, AoA_landing, ground_clearance, ...
    overturn_angle, y_mg_max);

% Outputs
disp(['Nose gear is now placed at approx ', num2str(round(x_NoseGear)), ' m'])
disp(['Main gear is now placed at approx ', num2str(round(x_MainGear)), ' m'])
disp('Please cross-check with the constraint space to ensure the values work!')

%% Step 3: Calculate wheel loads (static and dynamic)

% Functions
[W_WheelMainGear, W_WheelNoseGear, W_DynamNoseGear, LbsReqMainGear, ...
    LbsReqNoseGearStatic, LbsReqNoseGearDynamic] = WheelLoads(W0, x_NoseGear, ...
    x_MainGear, x_cg_min, x_cg_max, z_cg_max);

% Outputs
disp(['Static load on nose gear is approx ', num2str(round(LbsReqNoseGearStatic)), ' lbs'])
disp(['Dynamic load on nose gear is approx ', num2str(round(LbsReqNoseGearDynamic)), ' lbs'])
disp(['Static load on main gear is approx ', num2str(round(LbsReqMainGear)), ' lbs'])

%% Step 4: Choose tires






