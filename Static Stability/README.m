%this script runs through the tailplane sizing and design, followed by
%static stability analysis and then trim analysis
clear
clc
close all

%% LOADING PARAMETERS

%loading parameters from other scripts
addpath('../Initial Sizing/', '../Xfoil/', '../Structures/Fuselage/', '../Aerodynamics/', '../Preliminary Design Optimiser/')
load('wingDesign.mat', 'Sref', 'MAC', 'b', 'Sweep_quarterchord', 'TaperRatio', 'Sweep_LE', 'Dihedral', 'AspectRatio', 'root_chord', 'tip_chord', 'Twist')
load('fuselageOutputs.mat', 'fusDiamOuter', 'totalLength', 'aftLength', 'frontLength', 'mainLength')
load('AerodynamicsFINAL.mat', 'CL_a_Total', 'CL_ah', 'CL_a_M0')
load('InitialSizing.mat', 'WingLoading', 'V_Cruise')

%renaming wing parameters to avoid confusion with tailplane parameters
SWing = Sref;
ARwing = AspectRatio;
cBarWing = MAC;
wingSpan = b;
sweepWingQC = Sweep_quarterchord;
taperWing = TaperRatio;
sweepWingLE = Sweep_LE;
dihedralWing = Dihedral;
cRootWing = root_chord;
cTipWing = tip_chord;
twistWing = Twist;
clear AspectRatio MAC b Sweep_quarterchord TaperRatio Sweep_LE Sref Dihedral root_chord tip_chord Twist

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
alpha0H = 0;

%tailplane parameters to optimse
ARhoriz = 5; %typically 3-5 where AR = b^2/Sh and b is the tail span
ARvert = 1.8; %typically 1.3-2 where AR = h^2/Sv and h is the tail height
taperHoriz = 0.3; %typically 0.3 - 0.5
taperVert = 0.3; %typically 0.3 - 0.5
% VbarH = 1; %horizontal volume coefficient estimates based off Raymer's historical data
% VbarV = 0.09; %vertical volume coefficient estimates based off Raymer's historical data
SHoriz = 70;
SVert = 35;

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
sweepHorizMT = sweepConverter(sweepHorizLE, 0, maxThicknessLocationHoriz, ARhoriz, taperHoriz);
sweepHorizTE = sweepConverter(sweepHorizLE, 0, 1, ARhoriz, taperHoriz);

%...for vertical tailplane
sweepVertLE = sweepWingLE + 12;
sweepVertQC = sweepConverter(sweepVertLE, 0, 0.25, 2*ARvert, taperVert);
sweepVertMT = sweepConverter(sweepVertLE, 0, maxThicknessLocationVert, 2*ARhoriz, taperVert);
sweepVertTE = sweepConverter(sweepVertLE, 0, 1, 2*ARvert, taperVert);

save('tailplaneSizing.mat', 'ARhoriz', 'ARvert', 'cBarHoriz', 'cBarVert', 'cRootHoriz', 'cBarVert',...
    'dihedralHoriz', 'dihedralVert', 'maxThicknessLocationHoriz', 'maxThicknessLocationVert',...
    'NACAhoriz', 'NACAvert', 'SHoriz', 'SHorizExposed', 'SHorizWetted', 'spanHoriz', 'SVert',...
    'SVertExposed', 'SVertWetted', 'sweepHorizLE', 'sweepHorizQC', 'sweepHorizTE', 'sweepVertLE',...
    'sweepVertQC', 'sweepVertTE', 'taperHoriz', 'taperVert', 'thicknessRatioHoriz', 'thicknessRatioVert',...
    'twistHoriz', 'twistVert', 'heightVert', 'cTipHoriz', 'cTipVert', 'sweepHorizMT', 'sweepVertMT');


%% WING AND TAIL PLACEMENT

% Note on coordinate values along the aircraft:
% x-coordinate - measured from the nose along the fuselage centreline
% y-coordinate - measured from the fuselage centreline, +ve along starboard
% z-coordinate - measured from the fuselage centreline, +ve above the centreline

%root chord root chord leading edge positions [x-coord, y-coord, z-coord]
wingRootLE = [0.35*totalLength; 0; -0.8*fusDiamOuter/2];
horizRootLE = [0.88*totalLength; 0; 0.6*fusDiamOuter/2];
vertRootLE = [0.8*totalLength; 0; fusDiamOuter/2];

%aerodynamic centre positions (1/4-chord of MAC) of wing and horizontal tailplane
wingAC = wingRootLE + aerodynamicCentre(cBarWing, wingSpan, taperWing, sweepWingLE, dihedralWing);
horizAC = horizRootLE + aerodynamicCentre(cBarHoriz, spanHoriz, taperHoriz, sweepHorizLE, dihedralHoriz);

temp = aerodynamicCentre(cBarVert, 2*heightVert, taperVert, sweepVertLE, dihedralVert);
temp([2 3]) = temp([3 2]); %switching y and z coordinate for vertical tailplane
vertAC = vertRootLE + temp;
clear temp

% %% PLOTTING TAILPLANE AND WING GEOMETRY AND PLACEMENT
% wingPlanform = wingRootLE + tailplanePlanform(wingSpan, sweepWingLE, cRootWing, cTipWing, dihedralWing, false);
% horizPlanform = horizRootLE + tailplanePlanform(spanHoriz, sweepHorizLE, cRootHoriz, cTipHoriz, dihedralHoriz, false);
% vertPlanform = vertRootLE + tailplanePlanform(2*heightVert, sweepVertLE, cRootVert, cTipVert, dihedralVert, true);
% 
% tailplanePlot(wingPlanform, horizPlanform, vertPlanform, aftLength, mainLength, frontLength, fusDiamOuter)

%% STABILITY ANALYSIS

CG = [28,29,30; 0,0,0; 0,0,0]; %guesses to make the code work for now
enginePosition = wingRootLE + [0; 4; -1]; %guesses to make the code work for now

%tailplane moment arms
lHoriz = horizAC(1) - wingAC(1);
lVert = vertAC(1) - wingAC(1);
hHoriz = horizRootLE(3) - wingRootLE(3);

%tailplane volume coefficients
VbarH = lHoriz*SHoriz/(cBarWing*SWing);
VbarV = lVert*SVert/(wingSpan*SWing);

%aircraft fuselage pitching moment contribution
CMalphaF = fuselagePitchingMoment(totalLength, fusDiamOuter, cBarWing, SWing, wingRootLE(1) + 0.25*cBarWing);

%wing downwash on tailplane d(e)/d(alpha) 
downwash = downwash(lHoriz, hHoriz, wingSpan, sweepWingQC, ARwing, taperWing, CL_a_Total, CL_a_M0);

%power-off neutral point and static margin
xNPOff = neutralPoint(SWing, SHoriz, wingAC(1), horizAC(1), cBarWing, CL_ah, CL_a_Total, CMalphaF, downwash, etaH);
KnOff = (xNPOff - CG(1,:))/cBarWing; %typically 0.04 - 0.07 (never > 0.2)

%power-on static margin and neutral point
KnOn = KnOff - 0.02;
xNPPOn = KnOn*cBarWing + CG(1,:);

%% TRIM ANALYSIS

%wing aerofoil parameters
CMoAerofoilW = -0.03; %Sforza and -0.04 according to airfoiltools (xfoil)
alpha0W = -1.6; %degrees

%wing zero-lift pitching moment coefficient
CMoW = zeroLiftPitchingMoment(CMoAerofoilW, ARwing, sweepWingQC, twistWing, CL_a_Total, CL_a_M0);

%required lift coefficient and drag at cruise 
[~,~,~,rhoCruise]= atmosisa(distdim(35000,'ft','m'));
CLtarget(1:3) = WingLoading/(0.5*rhoCruise*V_Cruise^2); %CHANGE IT TO SPECIFIC WEIGHT, RHO, AND VELOCITY AT EACH SEGMENT
CDtotal = [0.0, 0.06, 0.04]; %guess to make the code work for now

%determine iH and AoA for trimmed flight
[iH_trim, AoA_trim] = trimAnalysis(CG, wingAC, horizAC, enginePosition, cBarWing,...
    SWing, SHoriz, CMoW, CMalphaF, CLtarget, CDtotal, CL_a_Total, CL_ah, twistWing, alpha0W, alpha0H, downwash, etaH)
