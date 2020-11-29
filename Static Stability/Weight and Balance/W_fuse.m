function W_fuse = W_fuse(W_maxTO, Nz, taperWing, wingSpan, sweepWingQC, fuseLength, fuseWetted, fuseDiamMax)
% this function calculates the fuselage weight in lbs

% INPUTS
% W_maxTO = design gross weight aka maximum takeoff weight (lbs)
% Nz = ultimate load factor (1.5x limit load factor)
% taperWing = wing taper ratio
% wingSpan = wing span (ft)
% sweepWingQC = wing quarter-chord sweep angle (degrees)
% fuseLength = length of fuselage (ft)
% fuseWetted = fuselage wetted area (ft2)
% fuseDiamMax = maximum fuselage diameter (ft)


Kws = 0.75*(1+2*taperWing)/(1+taperWing)*wingSpan*tand(sweepWingQC)/fuseLength;

W_fuse = 0.3280 * 1.12 * 1.12 * (W_maxTO * Nz)^0.5 * fuseLength^0.25 * fuseWetted^0.302 *...
    (1+Kws)^0.04 * (fuselength/fuseDiamMax)^0.1;
end