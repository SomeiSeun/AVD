%this script evaluates the longitudinal static stability of the aircraft

etaH = 0.9; %crude approximation for jet planes

VbarH = 1; %volume coefficient estimates based off Raymer's historical data
VbarV = 0.09;

[SHoriz, SVert] = tailplaneSizing(cBarWing, wingSpan, SWing, xWing, xHoriz, xVert, VbarH, VbarV);

CMalphaF = fuselagePitchingMoment(lf, wf, cBarWing, SWing, xWing);

downwash = downwash(lHoriz, hHoriz, wingSpan, quarterSweepWing, ARwing, taperWing, CLalphaW, CLalphaW_M0);

%power off static margin and neutral point
[KnOff, xNPOff] = longStaticMargin(xCG, SWing, SHoriz, xWing, xHoriz, cBarW, CLalphaH, CLalphaW, CMalphaF, downwash, etaH);

%power-on static margin and neutral point
KnOn = KnOff - 0.02;
xNPPOn = KnOn*cBarW + xCG;
