function CMalphaf = fuselagePitchingMoment(lf, wf, cBarWing, Swing, xWing)
%this function uses an emperical method to estimate the pitching moment
%contribution by the fuselage - CMalphaf (1/rad)

% INPUTS
% lf = fuselage length (m)
% wf = fuselage max width (m)
% MAC = wing mean aerodynamic chord (m)
% Swing = wing reference area (m2)
% xWing = longitudinal wing root quarter-chord position wrt nose (m)

%wing root 1/4-chord position as fraction of body length
xFract = xWing/lf;

%constant of proportionality based on graph from errikos' slides
Kf = 91.667*xFract^4 - 102.78*xFract^3 + 45.25*xFract^2 - 5.7841*xFract + 0.3;

CMalphaf = Kf*lf*wf^2/(cBarWing*Swing);
end
