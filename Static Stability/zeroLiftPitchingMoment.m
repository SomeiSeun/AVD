function CMoW = zeroLiftPitchingMoment(CMoAerofoilW, ARwing, sweepWingQC, twistWing, CLalphaW, CLalphaW_M0)
% this function calculates the zero lift pitching moment of the wing
% INPUTS
% CMoAerofoilW = incompressible wing aerofoil zero-lift picthing moment
% ARwing = wing aspect ratio
% sweepWingQC = wing quarter-chord sweep (degrees)
% twistWing = wing twist (degrees)
% CLalphaW = wing lift curve slope (1/rad)
% CLalphaW_M0 = wing incompressible lift curve slope (1/rad)

CMoW = (CMoAerofoilW*(ARwing*cosd(sweepWingQC)^2)/(ARwing + 2*cosd(sweepWingQC)) - 0.01*twistWing)*CLalphaW/CLalphaW_M0;

end

