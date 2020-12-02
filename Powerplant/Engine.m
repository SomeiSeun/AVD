%% Engine and nacelle sizing
%{
This script should hopefully finally solve all issues with engine and
provide a function which can be used to calculate the engine performance,
size, location based on the inputs it takes.
%}

%% Housekeeping
clear
clc
close all

%% How much thrust is required
%{
As per initial sizing (and its assumptions), there is a minimum requirement
for the thrust to weight ratio at sea level, which when combined with the
MTOW gives us the installed thrust required to be bare bones mission capable.

However, initial sizing does not take into account the various sources of
losses that occur in the engine due to installation effects. There are two
major sources of losses:

Systems losses
    Pressurisation losses
    Pneumatic losses
    Hydraulic losses
    Electrical losses
    Cowl Thermal Anti Icing losses
    Wing leading edge thermal losses
    etc.
Values for systems losses are probably just to be estimated at this stage
as a percent increase required for thrust.

Engine losses
    Nacelle intake losses
    Spillage drag
    Boundary layer removal losses
Such losses are to be calculated as part of the engine itself because these
very directly impact the engine thrust and are inseperable from the engine
itself.
%}

load('../Initial Sizing/InitialSizing.mat', 'ThrustToWeight', 'W0', 'C_Cruise', 'C_Divert', 'C_Loiter', 'V_Cruise')
InstalledThrustTotalReq = ThrustToWeight * W0;
SystemsLossFactor = 1.08;
NacelleLossFactor = 1.02;
UninstalledThrustTotalReq = InstalledThrustTotalReq * SystemsLossFactor * NacelleLossFactor;
UninstalledThrustPerEngineReq = UninstalledThrustTotalReq/2;
disp(['Look for engines that provide thrust in the range of ', num2str(round(UninstalledThrustPerEngineReq/1000)), 'kN (aka ', num2str(round(UninstalledThrustPerEngineReq*0.2248089)), ' pounds-force).'])


%% Thrust lapse model

Mach_numbers = 0:0.01:1;
Altitudes = 0:100:42000;
beta = zeros(length(Mach_numbers), length(Altitudes));

for i = 1:length(Mach_numbers)
    for ii = 1:length(Altitudes)
        beta(i,ii) = ThrustLapseModel(Mach_numbers(i), Altitudes(ii), 0.8, 35000);
    end
end
figure(1)
contourf(Altitudes, Mach_numbers, beta, 100)
title('Contours of Constant Thrust Ratio $\beta$ with Mach Number and Altitude', 'interpreter', 'latex', 'fontsize', 20)
xlabel('Altitude (ft)', 'interpreter', 'latex', 'fontsize', 15)
ylabel('Mach number', 'interpreter', 'latex', 'fontsize', 15)

figure(2)
plot(Mach_numbers, beta(:,1), 'k', 'LineWidth', 1.5)
hold on
plot(Mach_numbers, beta(:,101), '--b', 'LineWidth', 1.5)
plot(Mach_numbers, beta(:,201), 'b', 'LineWidth', 1.5)
plot(Mach_numbers, beta(:,351), '--r', 'LineWidth', 1.5)
plot(Mach_numbers, beta(:,421), 'r', 'LineWidth', 1.5)
xlim([0 1])
ylim([0 1])
hold off
title('Rolls Royce Trent 1000-A Thrust Ratio $\beta$ versus Mach Number', 'interpreter', 'latex', 'fontsize', 20)
xlabel('Mach Number', 'interpreter', 'latex', 'fontsize', 15)
ylabel('Thrust Ratio $\beta$', 'interpreter', 'latex', 'fontsize', 15)
legend('Sea Level', '10000 ft', '20000 ft', 'Cruise Altitude', 'Absolute Ceiling', 'interpreter', 'latex', 'fontsize', 15)

%{
% For comparison purposes
for i = 1:length(Mach_numbers)
    for ii = 1:length(Altitudes)
        beta(i,ii) = ThrustLapseModel(Mach_numbers(i), Altitudes(ii), 0.6, 0);
    end
end
figure(2)
contourf(Altitudes, Mach_numbers, beta, 100)
title('Contour plot of thrust ratio $\beta$ with Mach number and altitude', 'interpreter', 'latex', 'fontsize', 20)
xlabel('Altitude (ft)', 'interpreter', 'latex', 'fontsize', 15)
ylabel('Mach number', 'interpreter', 'latex', 'fontsize', 15)
%}

%% Pure rubber engine sizing for sanity checking

BPR = 10;
Rubber_W = 14.7 * ((UninstalledThrustPerEngineReq/1000)^1.1) * exp(-0.045*BPR);
Rubber_L = 0.49 * ((UninstalledThrustPerEngineReq/1000)^0.4) * 0.8^0.2;
Rubber_D = 0.15 * ((UninstalledThrustPerEngineReq/1000)^0.5) * exp(0.04*BPR);
Rubber_SFC_maxT = 19 * exp(-0.12*BPR);
Rubber_T_Cruise = 0.35 * ((UninstalledThrustPerEngineReq/1000)^0.9) * exp(0.02 * BPR);
Rubber_SFC_cruise = 25 * exp(-0.05 * BPR);

disp(' ')
disp(['For a pure rubber engine requiring approx ', num2str(round(UninstalledThrustPerEngineReq/1000)), ' kN of thrust:'])
disp(['Assuming a bypass ratio of ', num2str(BPR)])
disp(['Mass = ', num2str(Rubber_W), ' kg'])
disp(['Length = ', num2str(Rubber_L), ' m'])
disp(['Diameter = ', num2str(Rubber_D), ' m'])
disp(['Max thrust SFC = ', num2str(Rubber_SFC_maxT), ' lbs/lbs/hr (probably)'])
disp(['Thrust during cruise = ', num2str(round(Rubber_T_Cruise)), ' kN (beta ratio of approx ', num2str(round(Rubber_T_Cruise/UninstalledThrustPerEngineReq * 1000, 2)), ')'])
disp(['Cruise SFC = ', num2str(Rubber_SFC_cruise), ' lbs/lbs/hr (probably)'])

%% Engine selection
%{
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
%}

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

SF = UninstalledThrustPerEngineReq/(Engine_MaxContThrust*1000);
L = Engine_Length * (SF^0.4);
D_e = Engine_Diameter * (SF^0.5);
D_f = 2.85 * (SF^0.5);
W = Engine_Mass_Dry * (SF^1.1);

disp(' ')
disp('Using the Trent 1000-A as the basis engine to rubber size, we get: ')
disp(['Mass = ', num2str(W), ' kg'])
disp(['Length = ', num2str(L), ' m'])
disp(['Diameter of engine = ', num2str(D_e), ' m'])
disp(['Diameter of fan = ', num2str(D_f), ' m'])
disp(['Area of fan = ', num2str( pi*(D_f/2)^2 ), ' m^2'])

%% Capture area calculation
%{
% First method is a statistical approach. Here we find that A_c / mdot
% should equal 0.36 for flight below Mach 1. mdot is approximated as
% 0.183*D_i^2
%}
Capture_area_estimate = 3.6 * 0.183 * (D_f*39.3700787)^2 * 0.0006451600000025807; %sqm
%{
% Second method is based on the assumption that the inlet is aiming to slow
% the flow down to Mach 0.4 to prevent supersonic blade tips. Also assume
% that half the flow deceleration occurs before the inlet, which means at
% cruise, inlet is receiving air at Mach 0.6 and slowing it down to Mach
% 0.4
%}
A_engine = pi*(D_f/2)^2;
A_throat = A_engine * ( (1/0.6) * ((1+0.2*(0.6)^2)/1.2)^3 )  /  ( (1/0.4) * ((1+0.2*(0.4)^2)/1.2)^3 ); %sqm

disp(' ')
disp(['Capture area estimate from statistical data = ', num2str(Capture_area_estimate), ' sqm'])
disp(['Capture area estimate from compressible flow = ', num2str(A_throat), ' sqm'])

Capture_radius = sqrt(A_throat/pi);
Engine_radius = sqrt(A_engine/pi);
Length_inlet = (Engine_radius - Capture_radius)/tand(10);

disp(['Diffuser length from inlet to fan = ', num2str(Length_inlet), ' m'])

%% Engine placement

% Wing design / aerodynamics inputs
x_wingroot = 29;
z_wingroot = -2.1354937213;
length_rootchord = 7.4505;
theta_setting = 2.2;
theta_sweepLE = 29;
theta_dihedral = 5;
theta_maxground = 15;

% Calculate wing leading edge
x_LE = x_wingroot + length_rootchord*(0-0.25)*cosd(theta_setting);
z_LE = z_wingroot - length_rootchord*(0-0.25)*sind(theta_setting);

% Calculate wing-engine interface point
y_engine_ref = 8;
x_engine_ref = x_LE + y_engine_ref * (tand(theta_sweepLE)*cosd(theta_setting) + tand(theta_dihedral)*sind(theta_setting));
z_engine_ref = z_LE + y_engine_ref * (-tand(theta_sweepLE)*sind(theta_setting) + tand(theta_dihedral)*cosd(theta_setting));

% Calculate engine front face centre point
x_engine_front = x_engine_ref - 2*D_e;
y_engine_front = y_engine_ref;
z_engine_front = z_engine_ref - (D_e/2);

% Calculate engine strike point
y_engine_strike = y_engine_front + ((D_e + 0.3048)/2)*sind(5);
z_engine_strike = z_engine_front - ((D_e + 0.3048)/2)*cosd(5);