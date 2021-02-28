function fuselage = heavy_frame_Ixx_area_calc(h,b,second_moment_of_area,area)

% Creating a function which finds out the dimensions of an I cross section
% to be used in heavy frames

% The INPUTS are:
% h = flange height in m
% b = width of the central part of I section in m
% second_moment_of_area = required Ixx value for the I section
% area = required area for the I section

% The OUTPUTS are:
% fuselage = structure

syms H
eqn = (b * H^3 / 12) + (h^3 / 6) * ((50 * area) - (0.5 * H)) + ...
    (h / 2) * ((50 * area) - (0.5 * H)) * (H + h)^2 == second_moment_of_area;
solx = solve(eqn,H);

for i = 1:length(solx)
    if double(solx(i)) > 0
       fuselage.heavyframeH(i) = double(solx(i));
    end
end
fuselage.heavyframeB = (50 * area) - (0.5.*fuselage.heavyframeH);
end