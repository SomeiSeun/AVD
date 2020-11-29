%% Chai-liner W&B Code
% Written by Tanmay Ubgade 201122
%% Housekeeping
clear
clc
close all

% loading parameters from other analyses
addpath('../../Initial Sizing/', '../../Structures/Fuselage/', '../../Aerodynamics/', '../../Static Stability')
load('InitialSizing.mat', 'W0')
load('wingDesign.mat', 'Sref', 'AspectRatio', 'Sweep_quarterchord', 'Airfoil_ThicknessRatio_used', 'TaperRatio')
% load('fuselageOutputs.mat')
load('tailplaneSizing.mat')

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
W0 = W0*0.224809; %N to lbs


%% Weight breakdown by component (all in lbs)

W_wings = W_wings(W_maxTO, Nz, SWing, ARwing, taperWing, SWingCS, sweepWingQC, thicknessRatioWing);
W_horizTail = W_horizTail(W_maxTO, Nz, SHoriz, ARhoriz, S_elevator, lHoriz, Fw, spanHoriz, sweepHorizQC);
W_vertTail = W_vertTail(W_maxTO, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert);
W_fuse = W_fuse(W_maxTO, Nz, taperWing, wingSpan, sweepWingQC, fuseLength, fuseWetted, fuseDiamMax);
W_mainLG = W_mainLG(W_Landing, Ngear, lengthMainLG, NmainWheels, Vstall_Landing, NmainShockStruts, Kmp);


%% Weight


%% Balance


%% Outputs

