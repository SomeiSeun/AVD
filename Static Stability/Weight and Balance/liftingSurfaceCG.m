function CG = liftingSurfaceCG(chord_fraction, semiSpan_fraction, span, taperRatio, rootChord, dihedral, sweepLE, vert)
% this function calculates the CG position of a lifting surface w.r.t. the
% leading edge of the root chord.
% 
chord_CG = rootChord*((taperRatio - 1)*semiSpan_fraction + 1);

yCG = 0.5*span*semiSpan_fraction;
xCG = yCG*tand(sweepLE) + chord_fraction*chord_CG;
zCG = yCG*tand(dihedral);

if vert == 0
    CG = [xCG; 0; zCG];
elseif vert == 1
    CG = [xCG; 0; yCG];
else
    disp('ERROR: variable vert should only be 0 or 1')
end

end