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
load('fuselageOutputs.mat', 'totalLength', 'totalArea', 'fusDiamOuter', 'wallThickness')
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

save uc_limts

