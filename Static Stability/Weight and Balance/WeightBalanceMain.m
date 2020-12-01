%% Chai-liner W&B Code
clear
clc
close all

%% LOADING PARAMETERS

addpath('../../Initial Sizing/', '../../Structures/Fuselage/', '../../Aerodynamics/', '../../Static Stability',...
    '../../Preliminary Design Optimiser')
load('InitialSizing.mat', 'W0', 'NumberOfEngines', 'N_Crew', 'N_Pax', 'N_Pilots', 'TrappedFuelFactor',...
    'WF1', 'WF2', 'WF3', 'WF4', 'WF5', 'WF6', 'ProductWFs', 'Mass_Luggage', 'Mass_Person')
load('wingDesign.mat', 'Sref', 'AspectRatio', 'Sweep_quarterchord', 'Airfoil_ThicknessRatio_used',...
    'TaperRatio', 'b', 'Dihedral', 'Sweep_LE', 'root_chord')
load('fuselageOutputs.mat', 'totalLength', 'totalArea', 'fusDiamOuter', 'frontLength',...
    'mainLength', 'aftLength')
load('tailplaneSizing.mat', 'SHoriz', 'ARhoriz', 'spanHoriz', 'sweepHorizQC',...
    'SVert', 'ARvert', 'sweepVertQC', 'thicknessRatioVert', 'heightVert', ...
    'cRootHoriz', 'cRootVert')
load('stabilityAndTrim.mat', 'lVert', 'lHoriz', 'wingRootLE', 'horizRootLE', 'vertRootLE', 'fuseWidthHoriz')
load('rudder_and_elevator_values.mat', 'aileron_area', 'elevator_area', 'rudder_area')
load('AerodynamicsFINAL.mat', 'V_Stall_Landing')

%renaming wing parameters to avoid confusion with tailplane parameters
SWing = Sref;
ARwing = AspectRatio;
sweepWingLE = Sweep_LE;
sweepWingQC = Sweep_quarterchord;
thicknessRatioWing = Airfoil_ThicknessRatio_used;
taperWing = TaperRatio;
cRootWing = root_chord;
dihedralWing = Dihedral;
spanWing = b;
clear Sref ASpectRatio Sweep_quarterchord Aerfoi_ThicknessRatio_used TaperRatio b Dihedral root_chord


%% Decisions
Nz = 1.5*2.5;% minimum limit load factor = 2.5 according to FAR-25.337 (ultimate load factor = 1.5 x limit load factor)
Ngear = 3; %typically 2.7-3
W_avionics_uninstalled = 1000; %typically 800-1400 lb
electricRating = 60; %typically 40 − 60 for transports (kVA)
W_APU_uninstalled = 8*(1.1*N_Pax)^0.75; %(lb) Pasquale Sforza, in Commercial Airplane Design Principles, 2014
lengthEngineControl = (wingRootLE(1) + 0.2*spanWing)*unitsratio('ft', 'm'); %initial assumption
lengthElectrical = totalLength*unitsratio('ft', 'm');
W_maxTO = W0;

%% Calculations
fuelFraction = (1 + TrappedFuelFactor)*(1 - ProductWFs);
numPeopleOnBoard = N_Crew + N_Pax + N_Pilots;
totalCSarea = rudder_area + elevator_area + aileron_area;
W_Landing = W_maxTO * WF1 * WF2 * WF3 * WF4 * WF5 * WF6;
W_seats = 60*N_Pilots + 32*N_Pax + 11*N_Crew; %typical 60lbs per flight deck seats, 32lbs for passenger seats
W_People = numPeopleOnBoard*Mass_Person*9.80665;
W_Luggage = numPeopleOnBoard*Mass_Luggage*9.80665;
W_maxCargo = W_Luggage;

%% converting from SI to Imperial units

%m2 to ft2
SWing = SWing*unitsratio('ft', 'm')^2;
SHoriz = SHoriz*unitsratio('ft', 'm')^2;
SVert = SVert*unitsratio('ft', 'm')^2;
aileron_area = aileron_area*unitsratio('ft', 'm')^2;
elevator_area = elevator_area*unitsratio('ft', 'm')^2;
rudder_area = rudder_area*unitsratio('ft', 'm')^2;
totalArea = totalArea*unitsratio('ft', 'm')^2;
totalCSarea = totalCSarea*unitsratio('ft', 'm')^2;

%m to ft
spanWing = spanWing*unitsratio('ft', 'm');
spanHoriz = spanHoriz*unitsratio('ft', 'm');
heightVert = heightVert*unitsratio('ft', 'm');
cRootWing = cRootWing*unitsratio('ft', 'm');
cRootHoriz = cRootHoriz*unitsratio('ft', 'm');
cRootVert = cRootVert*unitsratio('ft', 'm');
lHoriz = lHoriz*unitsratio('ft', 'm');
lVert = lVert*unitsratio('ft', 'm');
fusDiamOuter = fusDiamOuter*unitsratio('ft', 'm');
totalLength = totalLength*unitsratio('ft', 'm');
V_Stall_Landing = V_Stall_Landing*unitsratio('ft', 'm');

%N to lb
W_maxTO = convforce(W_maxTO, 'N', 'lbf');
W_People = convforce(W_People, 'N', 'lbf');
W_Luggage = convforce(W_Luggage, 'N', 'lbf');
W_maxCargo = convforce(W_maxCargo, 'N', 'lbf');
W_Landing = convforce(W_Landing, 'N', 'lbf');

%% Weight breakdown by component (all in lbs)

components(1).name = 'Wings'; 
components(2).name = 'Horizontal Tail';
components(3).name = 'Vertical Tail';
components(4).name = 'Fuselage';
components(5).name = 'Main LG';
components(6).name = 'Nose LG';
components(7).name = 'Engine';
components(8).name = 'Nacelle';
components(9).name = 'Engine Controls';
components(10).name = 'Engine Starter';
components(11).name = 'Handling Gear';
components(12).name = 'Fuel System';
components(13).name = 'Flight Controls';
components(14).name = 'APU';
components(15).name = 'Instruments';
components(16).name = 'Hydraulics';
components(17).name = 'Electrical System';
components(18).name = 'Avionics';
components(19).name = 'Furninshings';
components(20).name = 'Air-Conditioning';
components(21).name = 'Anti-Icing';
components(22).name = 'People';
components(23).name = 'Luggage';
components(24).name = 'Fuel';

%lifting surfaces
components(1).weight = W_wings(W_maxTO, Nz, SWing, ARwing, taperWing, aileron_area, sweepWingQC, thicknessRatioWing);
components(2).weight = W_horizTail(W_maxTO, Nz, SHoriz, ARhoriz, elevator_area, lHoriz, fuseWidthHoriz, spanHoriz, sweepHorizQC);
components(3).weight = W_vertTail(W_maxTO, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert);

%fuselage and undercarriage
components(4).weight = W_fuse(W_maxTO, Nz, taperWing, spanWing, sweepWingQC, totalLength, totalArea, fusDiamOuter);
components(5).weight = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, Vstall_Landing, NmainShockStruts);
components(6).weight = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels);

%engine and fuel system
components(7).weight = W_engine; %REMEMBER TO INCLUDE ACTUAL ENGINE WEIGHT
components(8).weight = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumberOfEngines, SnacelleWetted);
components(9).weight = 5*NumberOfEngines + 0.8*lengthEngineControl; %lengthEngineControl = engine to cockpit total length (ft)
components(10).weight = W_engineStarter(NumberOfEngines, W_engine);
components(11).weight = 3e-4*W_maxTO;
components(12).weight = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank);

%subsystems
components(13).weight = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, totalCSarea, lHoriz);
components(14).weight = 2.2*W_APU_uninstalled; %installed APU weight
components(15).weight = W_instruments(N_crew, NumberOfEngines, totalLength, spanWing);
components(16).weight = W_hydraulics(numControlFunctions, totalLength, spanWing);
components(17).weight = W_electrical(electricRating, lengthElectrical, NumberOfEngines);
components(18).weight = 1.73 * W_avionics_uninstalled^0.983; %installed avionics weight (uninstalled typically 800-1400lbs)
components(19).weight = W_furnish(N_crew, W_maxCargo, totalArea, W_seats, numPeopleOnBoard);
components(20).weight = W_aircon(numPeopleOnBoard, volumePressurised, W_avionics_uninstalled);
components(21).weight = 0.002*W_maxTO;
emptyWeight = sum([components(1:21).weight]);

components(22).weight = W_People; %crew + pax
components(23).weight = W_Luggage; %luggage of crew + pax
components(24).weight = (emptyWeight + W_People + W_Luggage)*fuelFraction/(1 - fuelFraction);
totalWeight = sum([components.weight]);

%% Converting back from Imperial to SI units

%ft2 to m2
SWing = SWing/unitsratio('ft', 'm')^2;
SHoriz = SHoriz/unitsratio('ft', 'm')^2;
SVert = SVert/unitsratio('ft', 'm')^2;
aileron_area = aileron_area/unitsratio('ft', 'm')^2;
elevator_area = elevator_area/unitsratio('ft', 'm')^2;
rudder_area = rudder_area/unitsratio('ft', 'm')^2;
totalArea = totalArea/unitsratio('ft', 'm')^2;
totalCSarea = totalCSarea/unitsratio('ft', 'm')^2;

%ft to m
spanWing = spanWing/unitsratio('ft', 'm');
spanHoriz = spanHoriz/unitsratio('ft', 'm');
heightVert = heightVert/unitsratio('ft', 'm');
cRootWing = cRootWing/unitsratio('ft', 'm');
cRootHoriz = cRootHoriz/unitsratio('ft', 'm');
cRootVert = cRootVert/unitsratio('ft', 'm');
lHoriz = lHoriz/unitsratio('ft', 'm');
lVert = lVert/unitsratio('ft', 'm');
fusDiamOuter = fusDiamOuter/unitsratio('ft', 'm');
totalLength = totalLength/unitsratio('ft', 'm');
V_Stall_Landing = V_Stall_Landing/unitsratio('ft', 'm');

%lb to N
W_maxTO = convforce(W_maxTO, 'lbf', 'N');
W_Crew = convforce(W_Crew, 'lbf', 'N');
W_Luggage = convforce(W_Luggage, 'lbf', 'N');
W_Landing = convforce(W_Landing, 'lbf', 'N');
W_maxCargo = convforce(W_maxCargo, 'lbf', 'N');
emptyWeight = convforce(emptyWeight, 'lbf', 'N');
totalWeight = convforce(totalWeight, 'lbf', 'N');

for i = length(components)
    components(i).weight = convforce(components(i).weight, 'lbf', 'N');
    components(i).mass = components(i).weight/9.80665; %N to kg
end


%% CG of each component (in meters [x; y; z])

%lifting surfaces
components(1).cog = wingRootLE + liftingSurfraceCG(0.6, 0.35, spanWing, taperWing, cRootWing, dihedralWing, sweepWingLE, false);
components(2).cog = horizRootLE + liftingSurfaceCG(0.42, 0.38, spanHoriz, taperHoriz, cRootHoriz, dihedralHoriz, sweepHorizLE, false);
components(3).cog = vertRootLE + liftingSurfaceCG(0.42, 0.38, 2*heightHoriz, taperVert, cRootVert, dihedralVert, sweepVertLE, true);

%fuselage and undercarriage
components(4).cog = [0.45*totalLength; 0; 0];
components(5).cog = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, V_Stall_Landing, NmainShockStruts);
components(6).cog = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels);

%engine and fuel system
components(7).cog = W_engine;
components(8).cog = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumberOfEngines, SnacelleWetted);
components(9).cog = 5*NumEngines + 0.8*lengthEngineControl; %lengthEngineControl = engine to cockpit total length (ft)
components(10).cog = W_engineStarter(NumEngines, W_engine);
components(11).cog = 'Handling Gear';
components(12).cog = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank);

%subsystems
components(13).cog = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, StotalCS, lHoriz);
components(14).cog = [frontLength + mainLength + 0.65*aftLength; 0; 1.2];
components(15).cog = W_instruments(N_crew, NumberOfEngines, totalLength, spanWing);
components(16).cog = W_hydraulics(numControlFunctions, totalLength, spanWing);
components(17).cog = W_electrical(electricRating, lengthElectrical, NumberOfEngines);
components(18).cog = [frontLength + 0.2*mainLength; 0; -fusDiamOuter/2];
components(19).cog = [frontLength + 0.5*mainLength; 0; 0];
components(20).cog = W_aircon(numPeopleOnBoard, volumePressurised, W_avionics_uninstalled);
components(21).cog = 0.002*W_maxTO;

components(22).cog = 'People';
components(23).cog = 'Luggage';
components(24).cog = 'Fuel';

%calculating CG



%% Outputs

