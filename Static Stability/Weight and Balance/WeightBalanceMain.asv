%% Chai-liner W&B Code
% Written by Tanmay Ubgade 201122
%% Housekeeping
clear
clc
close all

% loading parameters from other analyses
addpath('../../Initial Sizing/', '../../Structures/Fuselage/', '../../Aerodynamics/', '../../Static Stability')
load('InitialSizing.mat', 'W0')
load('wingDesign.mat', 'Sref', 'AspectRatio', 'Sweep_quarterchord', 'Airfoil_ThicknessRatio_used', 'TaperRatio', 'b')
load('fuselageOutputs.mat')
load('tailplaneSizing.mat', 'SHoriz', 'ARhoriz', 'lHoriz', 'spanHoriz', 'sweepHorizQC',...
    'SVert', 'lVert', 'ARvert', 'sweepVertQC', 'thicknessRatioVert')

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


%% Weight breakdown by component (all in lbs)

%lifting surfaces
W_wings = W_wings(W_maxTO, Nz, SWing, ARwing, taperWing, SWingCS, sweepWingQC, thicknessRatioWing);
W_horizTail = W_horizTail(W_maxTO, Nz, SHoriz, ARhoriz, S_elevator, lHoriz, Fw, spanHoriz, sweepHorizQC);
W_vertTail = W_vertTail(W_maxTO, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert);

%fuselage and undercarriage
W_fuse = W_fuse(W_maxTO, Nz, taperWing, spanWing, sweepWingQC, fuseLength, fuseWetted, fuseDiamMax);
W_mainLG = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, Vstall_Landing, NmainShockStruts, Kmp);
W_noseLG = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels, Knp);

%engine and fuel system
W_engine = W_engine; %REMEMBER TO INCLUDE ACTUAL ENGINE WEIGHT
W_nacelle = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumEngines, SnacelleWetted);
W_engineControls(NumEngines, lengthEngineControl);
W_engineStarter(NumEngines, W_engine);
W_fuelSystem = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank);

%subsystems
W_flightControls = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, StotalCS, lHoriz);
W_APU = 2.22*W_APU_uninstalled; %installed APU weight
W_instruments = W_instr(numCrew, numEngines, fuseLength, spanWing);
W_hydraulics = W_hydr(numControlFunctions, fuseLength, spanWing);
W_electrical = W_electrical(electricRating, lengthElectrical, numGenerators);
W_avionics = 1.73 * W_avionics_uninstalled^0.983; %installed avionics weight (uninstalled typically 800-1400lbs)
W_furnish = W_furnish(numCrew, W_maxCargo, fuseWetted, W_seats, numPeopleOnboard);
W_aircon = W_aircon(numPeopleOnboard, volumePressurised, W_avionics_uninstalled);
W_antiIce = 0.002*W_maxTO;
W_handling = 3e-4*W_maxTO;

%% Weight


%% Balance


%% Outputs

