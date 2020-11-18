%% Engine sizing

%% Housekeeping
clear
clc
close all

%% Import data from initial sizing
load('../Initial Sizing/InitialSizing.mat', 'ThrustToWeight', 'W0', 'C_Cruise', 'C_Divert', 'C_Loiter')

%% Finding thrust required

T_req_all_engines_fly = ThrustToWeight * W0;                                    % This is how much thrust is required to fly when all engines are operating
T_req_all_engines_operate = T_req_all_engines_fly * 1.03;                       % This is how much thrust is required accounting for losses in bleed air/equivalent systems. This would also be known as the installed thrust.
T_req_per_engine_operate = T_req_all_engines_operate/2;                         % This is how much thrust we want each engine to produce (assuming two engines)

disp(['Look for engines that provide thrust in the range of ', num2str(round(T_req_per_engine_operate/1000)), 'kN (aka ', num2str(round(T_req_per_engine_operate*0.2248089)), ' pounds-force).'])

%% Pure rubber engine sizing for sanity checking

BPR = 10;
Rubber_W = 14.7 * ((T_req_per_engine_operate/1000)^1.1) * exp(-0.045*BPR);
Rubber_L = 0.49 * ((T_req_per_engine_operate/1000)^0.4) * 0.8^0.2;
Rubber_D = 0.15 * ((T_req_per_engine_operate/1000)^0.5) * exp(0.04*BPR);
Rubber_SFC_maxT = 19 * exp(-0.12*BPR);
Rubber_T_Cruise = 0.35 * ((T_req_per_engine_operate/1000)^0.9) * exp(0.02 * BPR);
Rubber_SFC_cruise = 25 * exp(-0.05 * BPR);

disp(' ')
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
    % Take off thrust (smallest - Trent 970-84) = 334.29 kN
    % Maximum continuous net thrust = 319.60 kN
    % Theres also data on allowable bleed percent for normal operation etc
    % This family seems suitable, just a bit on the larger size.
    % Certified and approved for use with Aircelle Thrust Reverser Unit
    
% Engine family 3: RB211 Trent 800 series engines
    % Overall length = 4.568 m
    % Maximum diameter = 3.048 m
    % Dry engine weight = 6078 kg
    % Take off thrust (smallest - 875-17) = 340.6 kN
    % Maximum continuous net thrust = 276.5 kN
    % Can use 877-17 instead for a max continuous thrust of 312.3kN and
    % higher (351 kN) take off thrust
    % Seems better than the Trent 900 family
    
% Engine family 4: RB211 Trent 700 series engines
    % Overall length = 5.639 m
    % Maximum diameter = 2.744 m
    % Dry engine weight = 6160 kg
    % Take off thrust (smallest Trent 768-60) = 300.3 kN
    % Maximum continuous net thrust = 268.7 kN
    % T0 thrust requirement matches almost exactly. Could just use this
    % engine as is.
    % Another look at the website makes this series look super tempting.
    
% Engine family 5: GE90 series engines
    % Overall length = 7.283m
    % Maximum diameter = 3.952 m
    % Dry weight = 7892 kg
    % This family looks a bit bigger than we need
    
% Engine family 6: Trent XWB engines
    % Take off thrust (smallest - XWB-75) = 330kN
    % Maximum continuous net thrust = 296 kN
    % Overall length = 5.812 m
    % Maximum diameter = 3 m
    % Dry weight = 7277 kg
    % Too big for our use
    
% Engine family 7: P&W PW4000 engines
    % Again a bit too big: 74-90klbf. Used on Boeing 777s.
    
% Engine family 8: CFM International
    % Meh
    
% Engine family 9: Trent 1000 family (specifically 1000-A)
    % Overall length = 4.771m
    % Maximum diameter = 3.798m
    % Dry weight = 5936kg without SB 72-G319, 6033kg with.
    % Take off thrust = 307.8 kN
    % Maximum continuous thrust = 290.8 kN
    
%% Engine selection

% The Trent 1000-A model seems to fit our requirements quite well. It is a
% three-shaft, high BPR, axial flow turbofan engine with LP, IP and HP
% compressors driven by separate turbines through coaxial shafts. The LP
% compressor fan diameter is 2.85m with a swept fan blade and OGV's. The
% combustion system consists of a single annular combustor with 18-off fuel
% spray nozzles.
    % Compressors: 
        % LP - single stage (fan). Diam 2.85m
        % IP - 8 stage
        % HP - 6 stage
    % Turbines:
        % LP - 6 stage
        % IP - single stage
        % HP - single stage
        
% The engine control system utilises an EEC (Electronic Engine Controller)
% which has an airframe interface for digital bus comms. An EMU (Engine
% Monitor Unit) is fitted to provide vibration signals to the aircraft.

% The engine is certified for use with an operable thrust reverser unit.
% Note that this does not form part of the engine type design and is
% certified as part of the aircraft type design.

% Dimensions:
    % Overall length mm (ins) = 4771 (187.8). This length is measured from
    % tip of spinner to rear of the tail bearing housing inner plug flange.
    % Maximum radius mm (ins) = 1899 (74.8). From centreline, not including
    % drains mast.

% Dry weight:
    % Max dry engine weight (kg) (Without SB 72-G319) = 5936
    % Max dry engine weight (kg) (With SB 72-G319) = 6033
    
% Thrust ratings kN (lbf): 
    % Take-off (net) (5 mins)
        % 307.8 (69,194)
    % Equivalent bare engine take-off
        % 310.9 (69,885)
    % Maximum continuous (net)
        % 287.9 (64,722)
    % Equivalent bare engine maximum continuous 
        % 290.8 (65,382)

% The equiv bare engine take off and max cont thrusts are derived from
% approved net take off and max cont thrust by excluding the losses
% attributable to the inlet, cold nozzle, hot nozzle, by-pass duct flow
% leakage and after body.
% The take off ratings are based on having no air bleed for CTAI but the
% max cont ratings include the effect of CTAI.
        
% Aircraft accessory drives
    % The engine's accessory gearbox may be fitted with two Variable
    % Frequency Starter Generators (VFSG) and one Hydraulic Pump to provide
    % electrical and hydraulic power to the aircraft. Details on torque and
    % power limitations in Engine Installation Manual which I can't find
    % lol.
    
% Maximum permissible air bleed extraction:
    % The Trent 1000 does not supply compressor air for airframe
    % ventilation (Cabin Bleed), but does supply compressor air for the
    % purpose of preventing ice build-up on the engine nacelle (Cowl
    % Thermal Anti-Ice (CTAI)).
    
    % The nacelle thermal anti-icing flow demand is modulated via a
    % regulating valve.
    
    % Engine power setting TET (K) vs Maximum CTAI % core mass flow
        % Idle to 1430: 2.67
        % 1430 to 1785: 2.67 to 1.25 varying linearly
        % 1785 to 1820: 1.25 to 0.54 varying linearly
        % 1820 and above: 0.54
  
% Operating limitations
    % Temperature limits
    % Pressure limits (fuel pressure, oil pressure)
    % Oil consumption limits (max allowable oil consumption = 0.60
    % litres/hr
    % Maximum permissible rotor speeds
    % Installation assumptions
    % Time limited dispatch

Engine_Length = 4.771; %m
Engine_Radius = 1.899; %m
Engine_Diameter = 2 * Engine_Radius; %m
Engine_Mass_Dry = 6033; %kg
Engine_Takeoff_Thrust_5min = 307.8; %kN
Engine_MaxContThrust = 287.9; %kN
Engine_EquivalentBareEngine_TakeoffThrust = 310.9; %kN
Engine_EquivalentBareEngine_MaxContinuous = 290.8; %kN
Engine_BPR = 10;

%% Rubber sizing selected engine to match requirements

SF = T_req_per_engine_operate/(Engine_MaxContThrust*1000);
L = Engine_Length * (SF^0.4);
D_e = Engine_Diameter * (SF^0.5);
D_f = 2.85 * (SF^0.5);
W = Engine_Mass_Dry * (SF^1.1);

