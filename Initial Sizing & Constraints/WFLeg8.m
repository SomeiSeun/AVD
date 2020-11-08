function WF8 = WFLeg8(R_Divert, C_Divert, H_Divert, L_DMax, VimD, WeightRatio)
% Leg 8: Diversion

% This is calculated using the Breguet range equation which gives the
% weight fraction as exp(-Rc/v(L/D)) where
    % R is range in m
    % c is fuel consumption in lb/lb/hr
    % v is velocity in m/s
    % L/D is cruise lift to drag ratio, optimum at 0.866*(L/D)max
    
% Geopotential heights are not used yet, consider this next.

[~, a_Divert, ~, ~] = atmosisa(H_Divert * 0.3048);

V_Divert = (3^0.25)*VmDCalculator(VimD, H_Divert, WeightRatio);

WF8 = exp(- (R_Divert * 1000 * C_Divert)/(V_Divert * L_DMax * 0.866 * 3600));

end
