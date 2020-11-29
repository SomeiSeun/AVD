function W_vertTail = W_vertTail(W_maxTO, Nz, SVert, lVert, ARvert, sweepVertQC, thicknessRatioVert)
this function calculates the weight of the vertical tail in lbs

% INPUTS
% W_maxTO = design gross weight aka maximum takeoff weight (lbs)
% Nz = ultimate load factor (1.5x limit load factor)
% SVert = vertical tail reference area (ft2)
% ARvert = vertical tail aspect ratio
% lVert = longitudinal lenth from wing AC to vertical tail AC (ft)
% sweepHorizQC = wing quarter chord sweep (degrees)

W_vertTail = 0.0026 * W_maxTO^0.556 * Nz^0.536 * SVert^0.5 * lVert^0.875 *...
    ARvert^0.35 / (lVert^0.5 * cosd(sweepVertQC) * thicknessRatioVert^0.5);

end