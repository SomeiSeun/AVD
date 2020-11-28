%this script runs through the tailplane sizing and design, followed by
%static stability analysis and then trim analysis
clear
clc
clf

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
ARvert = 2; %typically 1.3-2 where AR = h^2/Sv and h is the tail height
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
sweepVertQC = sweepConverter(sweepVertLE, 0, 0.25, 2*ARvert, taperVert);
sweepVertTE = sweepConverter(sweepVertLE, 0, 1, 2*ARvert, taperVert);

save('tailplaneSizing.mat', 'ARhoriz', 'ARvert', 'cBarHoriz', 'cBarVert', 'cRootHoriz', 'cBarVert',...
    'dihedralHoriz', 'dihedralVert', 'maxThicknessLocationHoriz', 'maxThicknessLocationVert',...
    'NACAhoriz', 'NACAvert', 'SHoriz', 'SHorizExposed', 'SHorizWetted', 'spanHoriz', 'SVert',...
    'SVertExposed', 'SVertWetted', 'sweepHorizLE', 'sweepHorizQC', 'sweepHorizTE', 'sweepVertLE',...
    'sweepVertQC', 'sweepVertTE', 'taperHoriz', 'taperVert', 'thicknessRatioHoriz', 'thicknessRatioVert',...
    'twistHoriz', 'twistVert', 'heightVert', 'cTipHoriz', 'cTipVert');

tailplanePlot(spanHoriz, heightVert, sweepHorizLE, sweepVertLE, cRootHoriz, cRootVert, cTipHoriz, cTipVert)

%% WING AND TAIL PLACEMENT

% Note on coordinate values along the aircraft:
% x-coordinate - measured from the nose along the fuselage centreline
% y-coordinate - measured from the fuselage centreline, +ve along starboard
% z-coordinate - measured from the fuselage centreline, +ve above the centreline

%root chord root chord leading edge positions [x-coord, y-coord, z-coord]
wingRootLE = [0.3*totalLength, 0, -0.8*fusDiamOuter/2];
horizRootLE = [0.9*totalLength, 0, 0.6*fusDiamOuter/2];
vertRootLE = [0.8*totalLength, 0, fusDiamOuter/2];

%aerodynamic centre positions (1/4-chord of MAC) of wing and horizontal tailplane
wingAC = wingRootLE + aerodynamicCentre(cBarWing, wingSpan, taperWing, sweepWingLE, dihedralWing);
horizAC = horizRootLE + aerodynamicCentre(cBarHoriz, spanHoriz, taperHoriz, sweepHorizLE, dihedralHoriz);

temp = aerodynamicCentre(cBarVert, 2*heightVert, taperVert, sweepVertLE, dihedralVert);
temp([2 3]) = temp([3 2]); %switching y and z coordinate for vertical tailplane
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
xNPOff = neutralPoint(SWing, SHoriz, wingAC(1), horizAC(1), cBarWing, CL_ah, CL_a, CMalphaF, downwash, etaH);
% KnOff = (xNPOff - xCG)/cBarWing;
% 
% %power-on static margin and neutral point
% KnOn = KnOff - 0.02;
% xNPPOn = KnOn*cBarW + xCG;

%% TRIM ANALYSIS


