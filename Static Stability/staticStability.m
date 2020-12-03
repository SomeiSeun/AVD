function [xNPOff, KnOff, xNPOn, KnOn] = staticStability(CG, SWing, SHoriz, xWing, xHoriz, cBarWing, CLalphaH, CLalphaW, CMalphaF, downwash, etaH)
% this function aims to determine the power-off a/c longitudinal static margin Kn

%doubling up cruise parameter into [takeoff, cruise start, cruise end, landing]
CLalphaH = doubleCruise(CLalphaH);
CLalphaW = doubleCruise(CLalphaW);
downwash = doubleCruise(downwash);

xNPOff = (CLalphaW*xWing + etaH*CLalphaH.*(1-downwash)*SHoriz/SWing*xHoriz - CMalphaF*cBarWing)./(CLalphaW + etaH.*SHoriz./SWing.*(1 - downwash).*CLalphaH);

KnOff = (xNPOff - CG(1,:))/cBarWing; %typically 0.04 - 0.07 (never > 0.2)

%power-on static margin and neutral point
KnOn = KnOff - 0.02;
xNPOn = KnOn*cBarWing + CG(1,:);
end

