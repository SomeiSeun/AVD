function WF9 = WFLeg9(E_Loiter, C_Loiter, L_DMax, VimD, WeightRatio, H_Loiter)
% Leg 9: Loiter
% This is calculated using the Breguet endurance equation which gives the
% weight fraction as exp(-Ec/(L/D)) where
    % E is the endurance in hours
    % c is the fuel consumption in lb/lb/hr
    % L/D is the appropriate lift to drag ratio optimum at L_DMax

V_Loiter = VmDCalculator(VimD, H_Loiter, WeightRatio);

WF9 = exp(- E_Loiter*C_Loiter/(L_DMax*60));
end
