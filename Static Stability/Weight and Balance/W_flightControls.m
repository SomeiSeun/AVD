function W_flightControls = W_flightControls(W_maxTO, numControlFunctions, numMechanicalFunctions, StotalCS, lHoriz)
%this function calculates the weight of the flight controls in lb

% INPUTS
% W_maxTO = design gross weight aka maximum takeoff weight (lb)
% numControlFunctions = number of functions performed by controls (typically 4-7)
% numMechanicalFunctions = number of mechanical functions performed by controls (typically 0-2)
% StotalCS = total control surface area (ft2)
% lHoriz = lenth from wing AC to horizontal tail AC (ft)

Iy = W_maxTO * (0.3*lHoriz)^2;

W_flightControls = 145.9 * numControlFunctions^0.554 * StotalCS^0.2 * (Iy*1e-6)^0.07 /...
    (1 + numMechanicalFunctions/numControlFunctions);
end