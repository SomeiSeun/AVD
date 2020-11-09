%% Powerplant sizing

% This script would be used to size the powerplant and can later be
% converted into a function in order to be used when merged with the main
% script.

%% Housekeeping

clear
clc

%% Get data

W0 = 155585*9.81;
TW_0_Required = 0.36;

%% Required Thrust

Thrust_Required = TW_0_Required * W0;
disp(['The required thrust (assuming no losses) is: ', num2str(round(Thrust_Required)), ' N'])

%% Engine Sizing

% Method 1: Use existing engines. If we find an engine which is very close
% to our thrust requirement, we can use it.

% Method 2: Rubber engine. This would allow us to use an existing engine
% and stretch its dimensions to fit our requirements. Here you take an
% existing state-of-the-art engine and stretch it based on statistically
% derived data, which would work really well as a rough sizing if we have a
% close match already.

% Method 3: Pure rubber engine. This is used to size the engine based on
% regression data and is not reliable, but can be used as a ballpark figure
% for finding the correct engines for Method 2 or 1. Only good for sanity
% checking.

%% Inlet Geometry

% Air entering has to be less than Mach 0.5 ish.

% Want to maintain P0, because losing P0 means losses means reduced
% efficiency.

% Best inlet to use is pitot inlet. It is the one most commonly used in
% commercial aircraft nowadays. 

% Pitot inlet geometry: capture area, inlet front face orientation, upper lip outer
% radius, upper lip inner radius, lower lip outer radius, lower lip inner
% radius, engine front face.

% Engine cowling lip has major influence on performance. For subsonic
% aircraft, the lip radius is 6-10% of the inlet radius. Large lip radius is
% good for high AoA and sideslip angles because it prevents air from
% separating too easily. Large lip radius also accommodates additional air
% at takeoff thrust due to shape of streamlines entering (larger volume can
% enter nicely). However, larger lip radius produces more drag due to
% larger more blunt front. At low speeds, large lip radius can help suck
% larger volume of air, at high speeds, that volume of air is smaller but
% the shape still accommodates that. This may also mean that volume of air
% intake reduces with speed.

% For subsonic aircraft, the inner radius is usually larger than the outer.
% Lower lip radii can be thicker to reduce AoA change effects at takeoff
% and landing. Plane of inlet should be perpendicular to direction of
% cruise, but may be desirable to face it downwards a little for takeoff
% and landing help. Aim to optimise cruise.

%% Capture Radius

%% Inlet Locations (Podded Engine)

% Compromise between ensuring clean air reaches the inlet, u/c location,
% inlet size, separation, etc

% Podded engines have a larger wetted area, lower noise, provide span
% loading, easier accessibility for maintenance. Under wing mounted engines
% often 2-4 degree nose down, canted inwards by 2 degrees.

% To reduce Foreign Object Damage, engine should be half the diameter of
% the fan away from the ground or more. This is one of the constraints, the
% other comes from the weird landing way constraint.

%% Secondary Air Flow

% Determined by subsystem analysis. For initial estimates, it is reasonable
% to assume the systems air to air passing through the engine is 3% for a
% transport aircraft.

% Boundary layer diverters. BL entering the engine can reduce performance
% and can be removed using a variety of methods, check if this is
% applicable to our type of engine and nacelle arrangement.

%% Nozzle Integration

% Nozzle accelerates the exhaust to the correct speed as governed by the
% area. The ideal area depends on the speeds the aircraft is operating at -
% can use cruise as optimiser. Variable area might be required but for
% subsonic transport aircraft, a fixed nozzle is usually used as it is not
% worth the complexity, weight, part count, etc for that slight addition of
% efficiency. For a subsonic nozzle, the exit area can be estimated to be
% 0.5-0.7 times the capture area.

%% Notes

% Axial compressor engines are sensitive to incoming airflow. This may mean
% that the angle of attack have some effect on the thrust produced. We want
% to have a nice uniform pressure distribution along the front face of the
% engine to prevent issues.

% Engines require sizing for thrust

% Clearances for cooling

% Location of the engine accessories

% Air intake and exhaust design