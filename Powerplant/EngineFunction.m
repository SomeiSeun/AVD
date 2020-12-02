function [Engine_SeaLevelThrust, Engine_TSFC, Thrustline_position, Engine_Weight, Engine_BPR, Nacelle_length, Nacelle_radius, Nacelle_wetted_area, y_engine_strike, z_engine_strike] = EngineFunction(ThrustToWeight, W0, x_wingroot, z_wingroot, length_rootchord, theta_setting, theta_sweepLE, theta_dihedral, y_engine_ref)
% This is the function-ified version of the engine and nacelle sizing
% script

%% How much thrust is required
InstalledThrustTotalReq = ThrustToWeight * W0;
SystemsLossFactor = 1.08;
NacelleLossFactor = 1.02;
UninstalledThrustTotalReq = InstalledThrustTotalReq * SystemsLossFactor * NacelleLossFactor;
UninstalledThrustPerEngineReq = UninstalledThrustTotalReq/2;

%% Engine selection: Rolls Royce Trent 1000-A
Engine_Length = 4.771; %m
Engine_Radius = 1.899; %m
Engine_Diameter = 2 * Engine_Radius; %m
Engine_Mass_Dry = 6033; %kg
%Engine_Takeoff_Thrust_5min = 307.8; %kN
Engine_MaxContThrust = 287.9; %kN
%Engine_EquivalentBareEngine_TakeoffThrust = 310.9; %kN
%Engine_EquivalentBareEngine_MaxContinuous = 290.8; %kN
Engine_BPR = 10;
Engine_TSFC = 14.34; %g/kN/s

%% Rubber sizing selected engine to match requirements
SF = UninstalledThrustPerEngineReq/(Engine_MaxContThrust*1000);
L = Engine_Length * (SF^0.4);
D_e = Engine_Diameter * (SF^0.5);
D_f = 2.85 * (SF^0.5);
W = Engine_Mass_Dry * (SF^1.1);

%% Capture area calculation
%Capture_area_estimate = 3.6 * 0.183 * (D_f*39.3700787)^2 * 0.0006451600000025807; %sqm
A_engine = pi*(D_f/2)^2;
A_throat = A_engine * ( (1/0.6) * ((1+0.2*(0.6)^2)/1.2)^3 )  /  ( (1/0.4) * ((1+0.2*(0.4)^2)/1.2)^3 ); %sqm
Capture_radius = sqrt(A_throat/pi);
Engine_radius = sqrt(A_engine/pi);
Length_inlet = (Engine_radius - Capture_radius)/tand(10);

%% Nacelle sizing
Nacelle_length = Length_inlet + L;
Nacelle_diameter = D_e * 1.02;
Nacelle_radius = Nacelle_diameter/2;
Nacelle_wetted_area = 2 * pi * Nacelle_diameter/2 * Nacelle_diameter;

%% Engine placement
% Calculate wing leading edge
x_LE = x_wingroot + length_rootchord*(0-0.25)*cosd(theta_setting);
z_LE = z_wingroot - length_rootchord*(0-0.25)*sind(theta_setting);
% Calculate wing-engine interface point
x_engine_ref = x_LE + y_engine_ref * (tand(theta_sweepLE)*cosd(theta_setting) + tand(theta_dihedral)*sind(theta_setting));
z_engine_ref = z_LE + y_engine_ref * (-tand(theta_sweepLE)*sind(theta_setting) + tand(theta_dihedral)*cosd(theta_setting));
% Calculate engine front face centre point
x_engine_front = x_engine_ref - Nacelle_diameter;
y_engine_front = y_engine_ref;
z_engine_front = z_engine_ref - (Nacelle_diameter/2);
% Calculate engine strike point
y_engine_strike = y_engine_front + ((Nacelle_diameter + 0.3048)/2)*sind(5);
z_engine_strike = z_engine_front - ((Nacelle_diameter + 0.3048)/2)*cosd(5);

%% Outputs
Engine_SeaLevelThrust = UninstalledThrustPerEngineReq;
Engine_Weight = W;
%Engine_TSFC;
Thrustline_position = [x_engine_front, y_engine_front, z_engine_front]';
%Nacelle_wetted_area;
%y_engine_strike;
%z_engine_strike;

end
