function [WS, TW, X, Y] = Absolute_Ceiling(Altitude, n, alpha, beta, L_DMax, C_D0, AspectRatio, e)
% Constraint thrust to weight ratio against wing loading for absolute
% ceiling. Example:

% At absolute ceiling, the aircraft would fly at maximum lift to drag ratio
% and minimum drag speed. Given that the minimum drag speed would vary with
% wing loading, we first create an array of values for VimD for different
% wing loadings. This comes straight from the AP formula for VimD (the one
% with A and B.

WS = [0:1:12500];
[T_SL, A_SL, P_SL, RHO_SL] = atmosisa(0);
[T_H, A_H, P_H, RHO_H] = atmosisa(Altitude*0.3048);
gamma = 1.4;

VimD = (((n * alpha)/(RHO_SL * L_DMax * C_D0)) .* WS) .^ 0.5;

% Now we have VimD varying with wing loading as required for absolute
% ceiling. We can use the specific excess power equation to get the
% required point performance, however, that equation uses true airspeed in
% the calculations. To convert to true airspeed, this equation uses the
% compressible flow relations.

A = ((((gamma-1).*VimD.*VimD)./(2*A_SL*A_SL)) + 1).^(gamma/(gamma-1));
VmD = A_H .* ((2/(gamma-1).*((1 + ((P_SL/P_H).*(A-1)) ).^((gamma-1)/gamma) - 1))).^(0.5);

% Now we have converted to true airspeed, so we can finally use it in the
% specific excess power equation.

TW = (alpha/beta) .* (  (0.5 * RHO_H .* VmD .* VmD .* C_D0)./(alpha .* WS) + (alpha * n * n .* WS)./(0.5 * RHO_H .* VmD .* VmD * pi * AspectRatio * e)   );

% It is worth noting that this entire process did not involve the target
% VimD anywhere. The below provides coordinates of the point which matches
% the target minimum drag speed the closest.
TargetVimD = VimDCalculator(35000, 0.8);
TargetVmD_AbsCeil = VmDCalculator(TargetVimD, 42000, 1);
A = abs(VmD - TargetVmD_AbsCeil);
X = WS(find(A == min(A)));
Y = TW(find(A == min(A)));

end