%% Structral layout sizing code
% Tanmay Ubgade 201130

%% housekeeping
clear
clc
close all

%% LOADING PARAMETERS
%mkdir('AVD')
addpath('../Structures/Fuselage/', '../Aerodynamics/', '../Static Stability')
load('wingDesign.mat', 'TaperRatio', 'root_chord')
load('fuselageOutputs.mat', 'fusDiamOuter', 'wallThickness')
load('stabilityAndTrim.mat', 'wingRootLE')

%renaming wing parameters to avoid confusion with tailplane parameters
taperWing = TaperRatio;
cRootWing = root_chord;
clear Sref ASpectRatio Sweep_quarterchord Aerfoi_ThicknessRatio_used TaperRatio b root_chord

%% Wing box

% Front and rear spar limits; Front spar = 10% chord, rear spar = 70% chord

% x-positions for spar
frontSparPos    = 0.3;
rearSparPos     = 0.7;
frontSpar       = wingRootLE(1) + cRootWing*frontSparPos; % Max thickness in 35-40% range, Front spar tends to be 25% 
rearSpar        = wingRootLE(1) + cRootWing*rearSparPos; % Typical placement for rear spar
rearLim         = wingRootLE(1) + cRootWing;

%% Undercarriage limits
wingbox_xlim    = rearSpar - frontSpar;
uc_xlim         = rearLim - frontSpar;
ylim_upper      = 0 - 0.15 - 0.05*fusDiamOuter; % Bottom of floor
ylim_lower      = 0 - fusDiamOuter/2 + wallThickness; % Lowest point at centre
uc_ylim         = ylim_upper - ylim_lower;
uc_xlimGiven    = 5;



%% Fuel tank calculations


%% LOADING PARAMETERS
addpath('../Aerodynamics/')
load('wingDesign.mat', 'TaperRatio', 'root_chord', 'b', 'Sref', 'AspectRatio')

%renaming wing parameters to avoid confusion with tailplane parameters
spanWing    = b;
SWing       = Sref;
tcRatioTip  = 0.15;
tcRatioRoot = 0.15;
tau_w = tcRatioTip/tcRatioRoot;
taperWing   = TaperRatio;
cRootWing   = root_chord;
clear TaperRatio root_chord b Sref

%% Wing Fuel tanks
volumeWingCAD = 71.882; % m^3 for one wing
volumeWingTotal = volumeWingCAD*2;

% Empirical Relation
volumeWetWing = 0.54*((SWing^2)/(spanWing))*tcRatioRoot*(1+taperWing+taperWing)/(1+taperWing)^2; % Volume in ft^3
volumeWetWingUsable = 0.95*volumeWetWing; % 5% unusable due to engine
volumeWingTotalGal = volumeWetWingUsable*264;

volumeFuelReqGal = 19361.75238;
volumeFuelReq = 73.65065391; % Volume in m^3
wingCapacityFuel = volumeFuelReq/volumeWetWingUsable;
wingCapacityFuelWorst = volumeFuelReq/(volumeWetWingUsable*0.9);
wingCapacityFuelBest = volumeFuelReq/(volumeWetWingUsable*1.1);

disp(['The average wet wing capacity is ', volumeWetWingUsable,' m^3']);
disp(['The avg occupied capacity ', wingCapacityFuel,'%']);
disp(['The worst case is ', wingCapacityFuelWorst,'% and best case is ', wingCapacityFuelBest,'%']);

% 
% disp(wingCapacityFuelWorst)
% disp(wingCapacityFuel)
% disp(wingCapacityFuelBest)


%}

%
cFuelEnd = 0.796; % From CAD
trootFS = (0.082900+0.063460)*cRootWing;
trootRS = (0.050850+0.031410)*cRootWing;
tFuelFS = (0.082900+0.063460)*cFuelEnd;
tFuelRS = (0.050850+0.031410)*cFuelEnd;
%}

% Convert units from m to ft
%spanWing = spanWing*unitsratio('ft', 'm');
%SWing = SWing*unitsratio('ft', 'm')^2;

%{
volumeWetWing = 0.54*(SWing^1.5)*tcRatioRoot*((2*AspectRatio)^-0.5)*(1+taperWing+taperWing)/(1+taperWing)^2; % Volume in ft^3
%volumeWetWing = volumeWetWing*unitsratio('m','ft')^3; % Volume in m^3
%volumeWetWing = volumeWetWing*264.172052; % Volume in gallons
volumeWetWingUsable = 0.95*volumeWetWing; % 5% unusable due to engine

volumeFuelReq = 19361.75238/264; % Volume in gallons

wingCapacityFuel = volumeFuelReq/volumeWetWingUsable;
wingCapacityFuelWorst = volumeFuelReq/(volumeWetWingUsable*0.9);
wingCapacityFuelBest = volumeFuelReq/(volumeWetWingUsable*1.1);

disp(wingCapacityFuelWorst)
disp(wingCapacityFuel)
disp(wingCapacityFuelBest)
%}

%{

volumeWetWingUsable = 2*17.028*0.95; % 5% unusable due to engine

volumeFuelReq = 19361.75238/264; % Volume in gallons

wingCapacityFuel = volumeFuelReq/volumeWetWingUsable;
wingCapacityFuelWorst = volumeFuelReq/(volumeWetWingUsable*0.9);
wingCapacityFuelBest = volumeFuelReq/(volumeWetWingUsable*1.1);

disp(wingCapacityFuelWorst)
disp(wingCapacityFuel)
disp(wingCapacityFuelBest)

volumeCentral = cRootWing*(0.7-0.25)*trootFS;


%% CAD version

VolOneWing = 17.028;
VolReqCent = volumeFuelReq - VolOneWing*2;
lengthCentTank = VolReqCent/(2.56*1.2);

%% Alternatively
lengthCentTank2 = cRootWing*0.45;
volumeCentral = lengthCentTank2*2.56*1.2;
%}

thiagoiscool = 1;

save structural_layout
