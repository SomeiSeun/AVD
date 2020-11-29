function W_HorizTail = W_horizTail(W_maxTO, Nz, SHoriz, ARhoriz, S_elevator, lHoriz, Fw, spanHoriz, sweepHorizQC)
% this function calculates the weight of the horizontal tail in lbs

% INPUTS
% W_maxTO = design gross weight aka maximum takeoff weight (lbs)
% Nz = ultimate load factor (1.5x limit load factor)
% SHoriz = horizontal tail reference area (ft2)
% ARhoriz = horizontal tail aspect ratio
% S_elevator = area of elevator (ft2)
% lHoriz = lenth from wing AC to horizontal tail AC (ft)
% Fw = fuselage width at horizontal tail intersection (ft)
% spanHoriz = span of horizontal tail (ft)
% sweepHorizQC = wing quarter chord sweep (degrees)

W_HorizTail = 0.0379 * W_maxTO^0.639 * Nz^0.1 * SHoriz^0.75 * (0.3*lHoriz)^0.704 *...
    ARhoriz^0.166 * (1+S_elevator/SHoriz)^0.1 / ((1+Fw/spanHoriz)^0.25 * lHoriz * cosd(sweepHorizQC));

end