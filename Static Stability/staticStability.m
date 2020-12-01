function [xNPOff, KnOff, xNPOn, KnOn] = staticStabiltiy(CG, SWing, SHoriz, xWing, xHoriz, cBarWing, CLalphaH, CLalphaW, CMalphaF, downwash, etaH)
% this function aims to determine the power-off a/c longitudinal static margin Kn

% INPUTS

xNPOff = (CLalphaW*xWing + etaH*CLalphaH.*(1-downwash)*SHoriz/SWing*xHoriz - CMalphaF*cBarWing)./(CLalphaW + etaH.*SHoriz./SWing.*(1 - downwash).*CLalphaH);
KnOff = (xNPOff - CG(1,:))/cBarWing; %typically 0.04 - 0.07 (never > 0.2)

%power-on static margin and neutral point
KnOn = KnOff - 0.02;
xNPOn = KnOn*cBarWing + CG(1,:);

if KnOn > 0.2
    disp('WARNING: AIRCRAFT OVERLY STABLE')
elseif KnOn < 0 
    disp('WARNING: AIRCRAFT UNSTABLE')
end

end

