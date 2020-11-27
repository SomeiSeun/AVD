function CMalphaf = fuselagePitchingMoment(lf, wf, cBarWing, Swing, xWing)
%this function uses an emperical method to estimate the pitching moment
%contribution by the fuselage - CMalphaf (1/rad)

% INPUTS
% lf = fuselage length (m)
% wf = fuselage max width (m)
% MAC = wing mean aerodynamic chord (m)
% Swing = wing reference area (m2)
% xWing = longitudinal wing quarter-chord position wrt nose (m)

%wing 1/4-chord position as fraction of body length
xFract = xWing/lf;

%constant of proportionality based on graph from errikos' slides
Kf = 61.199*xFract^4 + 61.489*xFract^3 + 26.05*xFract^2 - 2.151*xFract + 0.0632;

CMalphaf = Kf*lf*wf^2/(cBarWing*Swing);
end
