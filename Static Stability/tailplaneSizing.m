function [SHoriz, SVert] = tailplaneSizing(cBarWing, wingSpan, SWing, xWing, xHoriz, xVert, VbarH, VbarV)
%this function determines the size of the horizontal and vertical
%stabilizers SHoriz and SVert

% INPUTS
% cBarWing = wing mean aerodynamic chord (m)
% wingSpan = span of wing "b" (m)
% SWing = wing reference area (m2)
% xWing = longitudinal wing quarter-chord position wrt nose (m)
% xHoriz = longitudinal horizontal stabiliser quarter-chord position wrt nose(m)
% xVert = longitudinal vertical stabiliser quarter-chord position wrt nose (m)
% VbarH = horizontal volume coefficient
% VbarV = vertical volume coeffeicient

%determining tail reference areas
SHoriz = VbarH*cBarWing*SWing/(xHoriz - xWing);
SVert = VbarV*wingSpan*SWing/(xVert - xWing);
end


