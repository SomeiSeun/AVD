function [fuselage,solutions] = heavy_frame_Ixx_area_calc(H, B, second_moment_of_area, area, fuselage)

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

syms h
solutions = zeros(3,length(B));

for i = 1:length(B)
    eqn = (H(i)^2 / 12) * (area - 2*B(i)*h) + (B(i) * h^3 / 6) + ...
        (h * B(i) / 2) * (H(i) + h)^2 == second_moment_of_area;
    solx = solve(eqn,h);
    solutions_normal = double(solx);
    solutions(1,i) = solutions_normal(1);
    solutions(2,i) = solutions_normal(2);
    solutions(3,i) = solutions_normal(3);
end

fuselage.heavyframehimag = solutions;

for i = 1:length(B)
    fuselage.heavyframebimag(1,i) = (area - 2*B(i)*fuselage.heavyframehimag(1,i)) / H(i);  
end

fuselage.heavyframeh = fuselage.heavyframehimag(imag(fuselage.heavyframehimag)==0);
fuselage.heavyframeb = fuselage.heavyframebimag(imag(fuselage.heavyframebimag)==0);

end