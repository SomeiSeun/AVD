function xNP = neutralPoint(SWing, SHoriz, xWing, xHoriz, cBarWing, CLalphaH, CLalphaW, CMalphaF, downwash, etaH)
% this function aims to determine the power-off a/c longitudinal static margin Kn

% INPUTS
% xCG = longitudinal aircraft centre of gravity position wrt nose (m)
% lf = fuselage length (m)
% wf = fuselage max width (m)
% MAC = wing mean aerodynamic chord (m)
% SWing = wing reference area (m2)
% SHoriz = horizontal stabiliser reference area (m2)
% xWing = longitudinal wing quarter-chord position wrt nose (m)
% xHoriz = longitudinal horizontal stabiliser quarter-chord position wrt nose(m)
% downwash = d(eta)/d(alpha) downwash effects
% etaH = horizontal stabiliser efficiency factor
% lf - fuselage length (m)
% wf - fuselage max width (m)

xNP = (CLalphaW*xWing + etaH*CLalphaH.*(1-downwash)*SHoriz/SWing*xHoriz - CMalphaF*cBarWing)./(CLalphaW + etaH.*SHoriz./SWing.*(1 - downwash).*CLalphaH);
end

