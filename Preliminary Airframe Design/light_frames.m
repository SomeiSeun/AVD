function fuselage = light_frames(E, D, M, L)

% This function does calculations for light frames
% The INPUTS are:
% E = Youngs Modulus
% D = fuselage diameter
% L = frame spacing
% M = ultimate bending moment on fuselage

% The OUTPUTS are:
% fuselage = structure with light frame variables added

I_f = (1 / 16000) * M * D^2 / (L * E);

fuselage.web_height = linspace(0.05,0.2,40);  % In metres
fuselage.flange_width = linspace(0,0.1,40);   % In metres
fuselage.frame_t = zeros(length(web_height),length(flange_width));
fuselage.frame_area = zeros(length(web_height),length(flange_width));

for i = 1:length(fuselage.web_height)
    for j = 1:length(fuselage.flange_width)
        fuselage.frame_t(i,j) = (12 * I_f) / (fuselage.web_height(i)^3 + ...
            6 * fuselage.flange_width(j) * fuselage.web_height(i)^2);
        fuselage.frame_area(i,j) = (2 * fuselage.flange_width(j) + fuselage.web_height(i)) * (fuselage.frame_t(i,j));
    end
end
end