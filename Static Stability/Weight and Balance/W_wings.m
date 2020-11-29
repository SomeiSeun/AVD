function W_wings = W_wings(W_maxTO, Nz, SWing, ARwing, taperWing, SWingCS, sweepWingQC, thicknessRatioWing)
% this function calculates the weight of the wings in lbs

% INPUTS
% W_maxTO = design gross weight aka maximum takeoff weight (lbs)
% Nz = ultimate load factor (1.5x limit load factor)
% SWing = wing reference area (ft2)
% ARwing = wing aspect ratio
% taperWing = wing taper ratio
% SWingCS = area of wing-mounted control surfaces (ft2)
% thicknessRatioWing = thickness to chord ratio of wing aerofoil at root
% sweepWingQC = wing quarter chord sweep (degrees)

W_wings = 0.0051 * (W_maxTO*Nz)^0.557 * SWing^0.649 * ARwing^0.5 * (1+taperWing)^0.1 *...
    SWingCS^0.1 / (cosd(sweepWingQC) * thicknessRatioWing^0.4);
end