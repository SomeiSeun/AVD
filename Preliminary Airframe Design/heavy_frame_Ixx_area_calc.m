function fuselage = heavy_frame_Ixx_area_calc(h, b, second_moment_of_area, area, fuselage)

% Creating a function which finds out the dimensions of an I cross section
% to be used in heavy frames

% The INPUTS are:
% h = flange height in m
% b = width of the central part of I section in m
% second_moment_of_area = required Ixx value for the I section
% area = required area for the I section
% fuselage = structure needed to stop overwriting happening

% The OUTPUTS are:
% fuselage = structure

syms H
solutions = zeros(3,length(b));

for i = 1:length(b)
    eqn = (b(i) * H^3 / 12) + (h(i)^3 / 6) * ((50 * area) - (0.5 * H)) + ...
        (h(i) / 2) * ((50 * area) - (0.5 * H)) * (H + h(i))^2 == second_moment_of_area;
    solx = solve(eqn,H);
    solutions_normal = double(solx);
    solutions(1,i) = solutions_normal(1);
    solutions(2,i) = solutions_normal(2);
    solutions(3,i) = solutions_normal(3);
end

fuselage.heavyframeH = solutions(imag(solutions) == 0);
fuselage.heavyframeB = (50 * area) - (0.5.*fuselage.heavyframeH);
end