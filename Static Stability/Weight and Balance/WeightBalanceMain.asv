%% Chai-liner W&B Code
clear
clc
close all

%% LOADING PARAMETERS

addpath('../../Initial Sizing/', '../../Structures/Fuselage/', '../../Aerodynamics/', '../../Static Stability')
load('InitialSizing.mat', 'W0', 'NumberOfEngines', 'N_Crew', 'N_Pax', 'N_Pilots')
load('wingDesign.mat', 'Sref', 'AspectRatio', 'Sweep_quarterchord', 'Airfoil_ThicknessRatio_used', 'TaperRatio', 'b')
load('fuselageOutputs.mat', 'totalLength', 'totalArea', 'fusDiamOuterfeet')
load('tailplaneSizing.mat', 'SHoriz', 'ARhoriz', 'spanHoriz', 'sweepHorizQC',...
    'SVert', 'ARvert', 'sweepVertQC', 'thicknessRatioVert')
load('stabilityAndTrim.mat', 'lVert', 'lHoriz', 'wingRootLE', 'horizRootLE', 'vertRootLE')

%renaming wing parameters to avoid confusion with tailplane parameters
SWing = Sref;
ARwing = AspectRatio;
sweepWingQC = Sweep_quarterchord;
thicknessRatioWing = Airfoil_ThicknessRatio_used;
taperWing = TaperRatio;
spanWing = b;
clear Sref ASpectRatio Sweep_quarterchord Aerfoi_ThicknessRatio_used TaperRatio b

%converting from SI to Imperial units
SWing = SWing*10.7639; %m2 to ft2
spanWing = spanWing*3.28084; %m to ft
W_maxTO = W0*0.224809; %N to lbs

% minimum limit load factor = 2.5 according to FAR-25.337
% ultimate load factor = 1.5 x limit load factor;
Nz = 1.5*2.5;

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
components(11).name = 'Fuel';
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
components(22).name = 'Handling Gear';

%lifting surfaces
components(1).weight = W_wings(W_maxTO, Nz, SWing, ARwing, taperWing, SWingCS, sweepWingQC, thicknessRatioWing);
components(2).weight = W_horizTail(W_maxTO, Nz, SHoriz, ARhoriz, S_elevator, lHoriz, Fw, spanHoriz, sweepHorizQC);
components(3).weight = W_vertTail(W_maxTO, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert);

%fuselage and undercarriage
components(4).weight = W_fuse(W_maxTO, Nz, taperWing, spanWing, sweepWingQC, totalLength, totalArea, fusDiamOuterfeet);
components(5).weight = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, Vstall_Landing, NmainShockStruts);
components(6).weight = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels);

%engine and fuel system
components(7).weight = W_engine; %REMEMBER TO INCLUDE ACTUAL ENGINE WEIGHT
components(8).weight = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumEngines, SnacelleWetted);
components(9).weight = 5*NumEngines + 0.8*lengthEngineControl; %lengthEngineControl = engine to cockpit total length (ft)
components(10).weight = W_engineStarter(NumEngines, W_engine);
components(11).weight = W_fuel; %REMEMBER TO INCLUDE FUEL WEIGHT
components(12).weight = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank);

%subsystems
components(13).weight = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, StotalCS, lHoriz);
components(14).weight = 2.22*W_APU_uninstalled; %installed APU weight
components(15).weight = W_instruments(N_crew, NumberOfEngines, totalLength, spanWing);
components(16).weight = W_hydraulics(numControlFunctions, totalLength, spanWing);
components(17).weight = W_electrical(electricRating, lengthElectrical, NumberOfEngines);
components(18).weight = 1.73 * W_avionics_uninstalled^0.983; %installed avionics weight (uninstalled typically 800-1400lbs)
components(19).weight = W_furnish(numCrew, W_maxCargo, fuseWetted, W_seats, numPeopleOnboard);
components(20).weight = W_aircon(N_Crew + N_Pilots + N_Pax, volumePressurised, W_avionics_uninstalled);
components(21).weight = 0.002*W_maxTO;
components(22).weight = 3e-4*W_maxTO;

%% Balance


%% Outputs

