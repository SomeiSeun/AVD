clear
clc

addpath('../Initial Sizing/', '../Xfoil/', '../Wing Design')
load('InitialSizing.mat', 'W0', 'WingLoading')

SWing = W0/WingLoading; %wing reference area based on initial sizing

%horizontal and vertical stabiliser 
etaH = 0.9; %crude approximation for jet planes

%tail parameters to optimse
VbarH = 1; %horizontal volume coefficient estimates based off Raymer's historical data
VbarV = 0.09; %vertical volume coefficient estimates based off Raymer's historical data
ARhoriz = 4; %typically 3-5 where AR = b^2/Sh and b is the tail span
ARvert = 2; %typically 1.3-2 where AR = h^2/Sv and h is the tail height

[SHoriz, SVert, spanHoriz, heightVert] = tailplaneSizing(cBarWing, wingSpan, SWing, xWing, xHoriz, xVert, VbarH, VbarV, ARhoriz, ARvert);

CMalphaF = fuselagePitchingMoment(lf, wf, cBarWing, SWing, xWing);

downwash = downwash(lHoriz, hHoriz, wingSpan, quarterSweepWing, ARwing, taperWing, CLalphaW, CLalphaW_M0);

%power-off neutral point and static margin
xNPOff = neutralPoint(SWing, SHoriz, xWing, cBarW, CLalphaH, CLalphaW, CMalphaF, VbarH, downwash, etaH);
KnOff = (xNPOff - xCG)/cBarW;

%power-on static margin and neutral point
KnOn = KnOff - 0.02;
xNPPOn = KnOn*cBarW + xCG;
