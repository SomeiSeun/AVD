function downwash = downwash(lHoriz, hHoriz, wingSpan, quarterSweepWing, ARwing, taperWing, CLalphaW, CLalphaW_M0)
%this function evaluates the downwash effect d(e)/d(alpha) of the wing on
%the tailplane

% INPUTS
% lHoriz = longitudinal distance between quarter-chord positions of wing and horizontal stabiliser (m)
% hHoriz = vertical distance between root chord planes of wing and horizontal stabiliser (m)
% ARwing = wing aspect ratio
% taperWing = wing taper ratio
% quarterSweepWing = sweep of wing quarter-chord line (rad)
% CLalphaW = wing lift curve slope (1/rad)
% CLalphaW_M0 = incompressible (M=0) wing lift curve slope (1/rad)
% wingSpan = span of wing "b" (m)


KA = 1/ARwing - 1/(1+ARwing^1.7);

Klambda = (10-3*taperWing)/7;

KH = (1-abs(hHoriz/wingSpan))/((2*lHoriz/wingSpan)^(1/3));

downwash = 4.44*(KA*Klambda*KH*sqrt(cosd(quarterSweepWing)))^1.19.*CLalphaW./CLalphaW_M0;

end
