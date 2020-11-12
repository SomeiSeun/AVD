function nSweep = sweepConverter(mSweep, mChord, nChord, AR, taperRatio)
% this function converts the sweep angle of the m-chord line to the n-chord
% line of a reference (trapezoidal) wing. Angles must be in degrees)

% INPUTS
% mSweep = sweep angle at the m-chord line (degrees)
% mChord = fraction of the m-chord line (where sweep is known)
% nChord = fraction of the desired n-chord line
% AR = wing aspect ratio b^2/S
% taperRatio = wing taper ratio cTip/cRoot

% Example: to convert a sweep angle of 20 degrees at the leading edge to
% the sweep angle at the 14-chord length:
% mSweep = 20;
% mChord = 0;
% nChord = 0.25;

nSweep = atand(tand(mSweep) - 4/AR*(nChord-mChord)*(1-taperRatio)/(1+taperRatio));
end