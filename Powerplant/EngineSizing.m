%% Engine sizing

%% Housekeeping
clear
clc
close all

%% Import data from initial sizing
load('../Initial Sizing/InitialSizing.mat', 'ThrustToWeight', 'W0')

%% Finding thrust required

T_req_all_engines_fly = ThrustToWeight * W0;                                    % This is how much thrust is required to fly when all engines are operating
T_req_all_engines_operate = T_req_all_engines_fly * 1.03;                       % This is how much thrust is required accounting for losses in bleed air
T_req_per_engine_operate = T_req_all_engines_operate/2;                         % This is how much thrust we want each engine to produce (assuming two engines)

disp(['Look for engines that provide thrust in the range of ', num2str(round(T_req_per_engine_operate/1000)), 'kN (aka ', num2str(round(T_req_per_engine_operate*0.2248089)), ' pounds-force).'])

%% Pure rubber engine sizing for sanity checking

BPR = 6;
Rubber_W = 14.7 * ((T_req_per_engine_operate/1000)^1.1) * exp(-0.045*BPR);
Rubber_L = 0.49 * ((T_req_per_engine_operate/1000)^0.4) * 0.8^0.2;
Rubber_D = 0.15 * ((T_req_per_engine_operate/1000)^0.5) * exp(0.04*BPR);
Rubber_SFC_maxT = 19 * exp(-0.12*BPR);
Rubber_T_Cruise = 0.35 * ((T_req_per_engine_operate/1000)^0.9) * exp(0.02 * BPR);
Rubber_SFC_cruise = 25 * exp(-0.05 * BPR);

disp(['For a pure rubber engine requiring approx ', num2str(round(T_req_per_engine_operate/1000)), ' kN of thrust:'])
disp(['Assuming a bypass ratio of ', num2str(BPR)])
disp(['Mass = ', num2str(Rubber_W), ' kg'])
disp(['Length = ', num2str(Rubber_L), ' m'])
disp(['Diameter = ', num2str(Rubber_D), ' m'])
disp(['Max thrust SFC = ', num2str(Rubber_SFC_maxT), ' lbs/lbs/hr (probably)'])
disp(['Thrust during cruise = ', num2str(round(Rubber_T_Cruise)), ' kN (beta ratio of approx ', num2str(round(Rubber_T_Cruise/T_req_per_engine_operate * 1000, 2)), ')'])
disp(['Cruise SFC = ', num2str(Rubber_SFC_cruise), ' lbs/lbs/hr (probably)'])

%% Finding existing engines to rubber size or install directly

% Engine family 1: Pratt & Whitney PurePower Engines
    % Best model: PW1100-JM (used in A319neo, A320neo and A321neo)
    % Thrust = 33,000lbs
    % BPR = 12
    % Fan diameter = 81 inch (2.0574m)
    % Entry into service: 2015
    % Any other Pratt & Whitney PurePower Engines don't work. Not a
    % suitable family.

% Engine family 2: RB211 Trent 900 series engines
    % Overall length = 5.4775 m
    % Maximum diameter = 3.944 m
    % Dry engine weight = 6246kg
    % Take off thrust (taking the smallest one - Trent 970-84) = 334.29 kN
    % Maximum continuous net thrust = 319.60 kN
    


