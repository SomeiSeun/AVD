function VmD = VmDCalculator(VimD, H_Segment, WeightRatio)
% This function calculates the predicted minimum drag velocity from the
% target VimD for a given altitude. It also takes into account the changes
% in weight there would have been until this segment. The weight ratio is
% the product of all the weight fractions from Leg 5 onwards, until the one
% before your segment. Eg WF5 * WF6 * WF7 for diversion. Changes made in
% any of the parameters A or B (check AP notes) could be accounted for in
% similar ways as ratios.

% There is an issue regarding the units of pressure. 101000 vs 101325 for
% pressure at sea level when comparing Thiago's value vs matlab value. Aha
% not a massive difference maybe not an issue.

gamma = 1.4;

VimD_New = VimD * sqrt(WeightRatio);

[~, a_Segment, P_Segment, ~] = atmosisa(H_Segment * 0.3048);
[~, a_SL, P_SL, ~] = atmosisa(0);

P0 = P_Segment + P_SL*( ( ((gamma-1)*VimD_New^2)/(2*a_SL^2) + 1 )^(gamma/(gamma-1)) -1);

MmD = sqrt(   (2/(gamma-1)) * ( ((P0/P_Segment)^((gamma-1)/gamma)) - 1)   );

VmD = MmD * a_Segment;

end
