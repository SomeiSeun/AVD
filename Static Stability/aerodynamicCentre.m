function AC = aerodynamicCentre(cBar, span, taper, sweepLE, dihedral)
% this function calculates the (x,y,z) position of the aerodynamic centre of
% a horizontal trapezoidal reference lifting surface wrt the root chord LE
% 
% Note on position values along the aircraft:
% x-coordinate - chord-wise direction
% y-coordinate - span-wise direction
% z-coordinate - out of plane direction
% 
% INPUTS
% cBar = wing mean aerodynamic chord length (m)
% span = wing span (m)
% taper = taper ratio cTip/cRoot
% sweepLE = sweep angle of leading edge (degrees)
% dihedral = wing dihedral angle (degrees)


yAC = cosd(dihedral)*span/6*(1 + 2*taper)/(1 + taper);
xAC = yAC*tand(sweepLE) + 0.25*cBar;
zAC = yAC*sind(dihedral);

AC = [xAC; yAC; zAC];
end

