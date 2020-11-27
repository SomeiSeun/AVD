%this script runs through the tailplane sizing and design, followed by
%static stability analysis and then trim analysis
clear
clc

%% LOADING PARAMETERS

%loading parameters from other scripts
addpath('../Initial Sizing/', '../Xfoil/', '../Structures/Fuselage/', '../Aerodynamics/', '../Preliminary Design Optimiser/')
load('wingDesign.mat', 'Sref', 'MAC', 'b', 'Sweep_quarterchord', 'TaperRatio', 'Sweep_LE', 'Dihedral', 'AspectRatio')
load('fuselageOutputs.mat', 'fusDiamOuter', 'totalLength')
load('../Preliminary Design Optimiser/Aerodynamics.mat', 'CL_a', 'CL_ah', 'CL_a_M0')

%renaming wing parameters to avoid confusion with tailplane parameters
SWing = Sref;
ARwing = AspectRatio;
cBarWing = MAC;
wingSpan = b;
sweepWingQC = Sweep_quarterchord;
taperWing = TaperRatio;
sweepWingLE = Sweep_LE;
dihedralWing = Dihedral;
clear AspectRatio MAC b Sweep_quarterchord TaperRatio Sweep_LE Sref Dihedral

%% DEFINING TAILPLANE PARAMETERS

%horizontal and vertical stabiliser parameters
etaH = 0.9; %crude approximation for jet planes
twistHoriz = 0;
twistVert = 0;
dihedralHoriz = 0;
dihedralVert = 0;

%aerofoil choice and characteristics
NACAhoriz = '0012';
NACAvert = '0012';
thicknessRatioHoriz = 0.12;
thicknessRatioVert = 0.12;
maxThicknessLocationHoriz = 0.3;
maxThicknessLocationVert = 0.3;

%tailplane parameters to optimse
ARhoriz = 4; %typically 3-5 where AR = b^2/Sh and b is the tail span
ARvert = 1.8; %typically 1.3-2 where AR = h^2/Sv and h is the tail height
taperHoriz = 0.4; %typically 0.3 - 0.5
taperVert = 0.4; %typically 0.3 - 0.5
% VbarH = 1; %horizontal volume coefficient estimates based off Raymer's historical data
% VbarV = 0.09; %vertical volume coefficient estimates based off Raymer's historical data
SHoriz = 60;
SVert = 48;

%% CALCULATING TAILPLANE GEOMETRY BASED ON PARAMETERS ABOVE

%exposed and wetted areas
SHorizExposed = SHoriz - 10; %approximation
SHorizWetted = SHorizExposed*(1.977 + 0.52*thicknessRatioHoriz);
SVertExposed = SVert;
SVertWetted = SVertExposed*(1.977 + 0.52*thicknessRatioVert);

%calculating tailplane span/height and chords
[spanHoriz, cRootHoriz, cTipHoriz, cBarHoriz] = tailplaneSizing(SHoriz, ARhoriz, taperHoriz);
[heightVert, cRootVert, cTipVert, cBarVert] = tailplaneSizing(SVert, ARvert, taperVert);

%calculating tailplane sweep angles based on wing sweep...
%...for horizongtal tailplane
sweepHorizLE = sweepWingLE + 5;
sweepHorizQC = sweepConverter(sweepHorizLE, 0, 0.25, ARhoriz, taperHoriz);
sweepHorizTE = sweepConverter(sweepHorizLE, 0, 1, ARhoriz, taperHoriz);

%...for vertical tailplane
sweepVertLE = sweepWingLE + 8;
sweepVertQC = sweepConverter(sweepVertLE, 0, 0.25, ARvert, taperVert);
sweepVertTE = sweepConverter(sweepVertLE, 0, 1, ARvert, taperVert);

% Note on position values along the aircraft:
% x-coordinate - measured from the nose along the fuselage centreline
% y-coordinate - measured from the fuselage centreline, +ve along starboard
% z-coordinate - measured from the fuselage centreline, +ve above the centreline

%% WING AND TAIL PLACEMENT

%root chord root chord leading edge positions [x-coord, y-coord, z-coord]
wingRootLE = [29 - 0.25*cBarWing, 0, -2];
horizRootLE = [0.9*totalLength, 0, 0.6*fusDiamOuter/2];
vertRootLE = [0.8*totalLength, 0, fusDiamOuter/2];

%aerodynamic centre positions of wing and tailplane
wingAC = wingRootLE + aerodynamicCentre(cBarWing, wingSpan, taperWing, sweepWingLE, dihedralWing);
horizAC = horizRootLE + aerodynamicCentre(cBarHoriz, spanHoriz, taperHoriz, sweepHorizLE, dihedralHoriz);
%switching y and z coordinate because vertical tailplane is... vertical
temp = aerodynamicCentre(cBarVert, 2*heightVert, taperVert, sweepVertLE, dihedralVert);
temp([2 3]) = temp([3 2]); 
vertAC = vertRootLE + temp;
clear temp

%% STABILITY ANALYSIS

%tailplane moment arms
lHoriz = horizAC(1) - wingAC(1);
lVert = vertAC(1) - wingAC(1);
hHoriz = horizRootLE(3) - wingRootLE(3);

%tailplane volume coefficients
VbarH = lHoriz*SHoriz/(cBarWing*SWing);
VbarV = lVert*SVert/(wingSpan*SWing);

%aircraft fuselage pitching moment contribution
CMalphaF = fuselagePitchingMoment(totalLength, fusDiamOuter, cBarWing, SWing, wingAC(1));

%wing downwash on tailplane d(e)/d(alpha) 
downwash = downwash(lHoriz, hHoriz, wingSpan, sweepWingQC, ARwing, taperWing, CL_a, CL_a_M0);

%power-off neutral point and static margin
xNPOff = neutralPoint(SWing, SHoriz, wingAC(1), cBarWing, CL_ah, CL_a, CMalphaF, VbarH, downwash, etaH);
% KnOff = (xNPOff - xCG)/cBarWing;
% 
% %power-on static margin and neutral point
% KnOn = KnOff - 0.02;
% xNPPOn = KnOn*cBarW + xCG;

save('tailplaneSizing.mat');
