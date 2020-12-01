function trapezium = tailplanePlanform(span, sweepLE, cRoot, cTip, dihedral, vert)
% plot made by connecting the four points for each trapezoidal wing section
% points are in the format [x-coord, y-coord, z-coord]
% x-coord - chord-wise direction
% y-coord - span-wise direciton


rootLE = [0;0;0];
tipLE = [0.5*span*tand(sweepLE); 0.5*span; 0.5*span*tand(dihedral)];
tipTE = tipLE + [cTip; 0; 0];
rootTE = rootLE + [cRoot; 0; 0];

trapezium = [rootLE, tipLE, tipTE, rootTE];

if (vert)
    trapezium([2 3],:) = trapezium([3 2],:);
end

end