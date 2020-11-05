function WF5 = WFLeg5(R_Cruise, C_Cruise, H_Cruise, M_Cruise, L_DMax)
% Leg 5: Cruise

% This is calculated using the Breguet range equation which gives the
% weight fraction as exp(-Rc/v(L/D)) where
    % R is range in m
    % c is fuel consumption in lb/lb/hr
    % v is velocity in m/s
    % L/D is cruise lift to drag ratio, optimum at 0.866*(L/D)max

% Geopotential heights are not yet implemented, consider this next.

[~, A_Cruise, ~, ~] = atmosisa(H_Cruise*0.3048);
V_Cruise = M_Cruise * A_Cruise;
WF5 = exp(- (R_Cruise * 1000 * C_Cruise)/(V_Cruise * L_DMax * 0.866 * 3600));
end