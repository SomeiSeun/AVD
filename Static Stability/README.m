%this script evaluates the longitudinal static stability of the aircraft

etaH = 0.9; %crude approximation for jet planes

CMalphaF = evaluateFuselagePitchingMoment(lf, wf, cBarWing, SWing, xWing);

downwash = evaluateDownwash(lHoriz, hHoriz, wingSpan, quarterSweepWing, ARwing, taperWing, CLalphaW, CLalphaW_M0);

[KnOff, xNPOff] = evaluateLongStaticMargin(xCG, SWing, SHoriz, xWing, xHoriz, cBarW, CLalphaH, CLalphaW, CMalphaF, downwash, etaH);

KnOn = KnOff - 0.02;

xNPPOn = KnOn*cBarW + xCG;
