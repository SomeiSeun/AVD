%this script evaluates the longitudinal static stability of the aircraft
clear
clc

% load('../Initial Sizing/InitialSizing.mat')
load('../Initial Sizing/InitialSizing.mat', 'W0', 'WingLoading')

%horizontal and vertical stabiliser 
etaH = 0.9; %crude approximation for jet planes
VbarH = 1; %volume coefficient estimates based off Raymer's historical data
VbarV = 0.09;
ARhoriz = 4; %typically 3-5 where AR = b^2/Sh and b is the tail span
ARvert = 2; %typically 1.3-2 where AR = h^2/Sv and h is the tail height

%fuselage length and width initial guesses
lf = 60;
wf = 5.5;

%initial estimates for wing and tail 1/4-chord positions based on fuselage
xVert = 0.9*lf;
xHoriz = 0.95*lf;
xWing = xHoriz - 0.5*lf;

%intial guess values for wing
SWing = W0/WingLoading;


% [SHoriz, SVert, spanHoriz, semiSpanVert] = tailplaneSizing(cBarWing, wingSpan, SWing, xWing, xHoriz, xVert, VbarH, VbarV, ARhoriz, ARvert);
% 
% CMalphaF = fuselagePitchingMoment(lf, wf, cBarWing, SWing, xWing);
% 
% downwash = downwash(lHoriz, hHoriz, wingSpan, quarterSweepWing, ARwing, taperWing, CLalphaW, CLalphaW_M0);
% 
% %power off static margin and neutral point
% [KnOff, xNPOff] = longStaticMargin(xCG, SWing, SHoriz, xWing, xHoriz, cBarW, CLalphaH, CLalphaW, CMalphaF, downwash, etaH);
% 
% %power-on static margin and neutral point
% KnOn = KnOff - 0.02;
% xNPPOn = KnOn*cBarW + xCG;
