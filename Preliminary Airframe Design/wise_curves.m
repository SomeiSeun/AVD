function fuselage = wise_curves(P, R, T, Q)

% This function plots the wise curves
% The INPUTS are:
% P =
% R =
% T =
% Q =

% The OUTPUTS are:
% fuselage = structure with forces due to the different load cases

% Initialising the arrays
theta = linspace(0,2*pi,1000);
fuselage.tangent_m = zeros(1,length(theta));
fuselage.tangent_n = zeros(1,length(theta));
fuselage.tangent_s = zeros(1,length(theta));
fuselage.radial_m = zeros(1,length(theta));
fuselage.radial_n = zeros(1,length(theta));
fuselage.radial_s = zeros(1,length(theta));
fuselage.moment_m = zeros(1,length(theta));
fuselage.moment_n = zeros(1,length(theta));
fuselage.moment_s = zeros(1,length(theta));

for i = 1:length(theta)
    fuselage.tangent_m(i) = ((P * R) / (2 * pi)) * (1.5 * sin(theta(i)) + (pi - theta(i)) * (cos(theta(i)) - 1)); 
    fuselage.tangent_n(i) = (P / (2 * pi)) * (0.5 * sin(theta(i)) - (pi - theta(i)) * cos(theta(i)));
    fuselage.tangent_s(i) = (P / (2 * pi)) * ((pi - theta(i))*sin(theta(i)) - 1 - 0.5 * cos(theta(i)));
    fuselage.radial_m(i) = (Q * R / (2 * pi)) * (0.5 * cos(theta(i)) - (pi - theta(i)) * sin(theta(i)) + 1);
    fuselage.radial_n(i) = (Q / (2 * pi)) * (1.5 * cos(theta(i)) + (pi - theta(i)) * sin(theta(i)));
    fuselage.radial_s(i) = (Q / (2 * pi)) * ((pi - theta(i)) * cos(theta(i)) - 0.5 * sin(theta(i)));
    fuselage.moment_m(i) = (T / (2 * pi)) * (pi - (2 * sin(theta(i))) - theta(i));
    fuselage.moment_n(i) = (T / (2 * pi * R)) * (1.5 * cos(theta(i)) + (pi - theta(i)) * sin(theta(i)));
    fuselage.moment_s(i) = (T / (2 * pi * R)) * (1 + 2 * cos(theta(i)));
end
end