%function[] = Undercarriage(W0, WF6, x_cg_max, x_cg_min, y_cg, z_cg_max, z_cg_min, ...
   % Length_ac, x_ng_min, x_fuse_tapers, AoA_GroundMax, groundclearance, y_mg_max)

%% Undercarriage

% This script is going to be used to follow the suggested process in slides
% for sizing the undercarriage.

%% Housekeeping
%clear
%clc
%close all

%% Get data
load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF6')
disp(['The mass of aircraft is ', num2str(round(W0*2.20462262/9.81)), ' lbs'])

%% Step 1: Assume tire pressure, number of u/c struts and wheels per strut

% Decisions
% NoseTirePressure = 150;
% MainTirePressure = 150;
% NoseStruts = 1;
% NoseWheelsPerStrut = 2;
% MainStruts = 2;
% MainWheelsPerStrut = 4;

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
disp(['Total load on nose gear is approx ', num2str(round(LbsReqNoseGearStatic + LbsReqNoseGearDynamic)), ' lbs'])
disp(['Static load on main gear is approx ', num2str(round(LbsReqMainGear)), ' lbs'])

%% Step 4: Choose tires

[NoseWheel] = GimmeTiresRaymerForReal(LbsReqNoseGearStatic + LbsReqNoseGearDynamic, 1);
[MainWheel] = GimmeTiresRaymerForReal(LbsReqMainGear, 1);

%% Step 5: Estimate ACN

% Here we would ideally like to call comfaa to run because it would perform
% the calculations automatically. Considering people may want to run the
% program on their own computers, they would need to download comfaa. Maybe
% it is worth it to run comfaa with a whole array of inputs and just have
% the pre-calculated ACN numbers ready to be deployed? 

% Also how tf do we find the PCN?

% Anyway, this step can almost be ignored because we can assume that the
% aircraft ACNs are less than the PCNs that we wish to design for. Making
% this assumption would allow us to carry on with the development of the
% landing gear without needing to perform this ACN PCN runway suitability
% check.

%% Step 6: Verify you can operate from desired airfields with chosen u/c

% Ignore for now

%% Step 7: Size oleos and find strut length

% The undercarriage would be designed assuming a telescopic configuration
% for both nose and main gears. This is to minimise the length of the oleos
% which should help with smaller retraction bay sizes. This also means that
% the wheel stroke is the same as the strut stroke.

% Inputs
V_Vertical = 10; %ft/s
eta_oleo = 0.9; %nondim
eta_tire = 0.47; %nondim
N_g = 2.7; %taken as lower bound to give largest stroke
Stroke_tire_main = ((MainWheel.OuterDiamMinINCH/2) - MainWheel.StaticLoadedRadiusINCH)/12; %ft
Stroke_tire_nose = ((NoseWheel.OuterDiamMinINCH/2) - NoseWheel.StaticLoadedRadiusINCH)/12; %ft

% Functions
MainOleo = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire_main, W0*WF6, 2); %ft
NoseOleo = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire_nose, W0*WF6, 1); %ft

% Outputs
disp(['The height of undercarriage is approx ', num2str( (MainOleo.TotalLength + MainWheel.OuterDiamMinINCH/2) * 0.0254 ), ' m'])

%% Step 8: Repeat for actual CG range

% CG range is already taken into account. Extreme load cases already
% considered in the constraint diagram.


%end