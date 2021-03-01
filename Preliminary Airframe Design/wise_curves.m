function [fuselage,theta_deg] = wise_curves(P, R, T, Q, fuselage)

% This function plots the wise curves
% The INPUTS are:
% P = Tangential load
% R = Radius of the fuselage
% T = Moment
% Q = Radial load
% fuselage = structure to stop this structure from being overwritten

% The OUTPUTS are:
% fuselage = structure with forces due to the different load cases

% Initialising the arrays
theta = linspace(0,2*pi,1000);
theta_deg = (180 / pi) * theta;
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
fuselage.heavyframe_bendingmoment = fuselage.tangent_m + fuselage.radial_m + fuselage.moment_m;
fuselage.heavyframe_normalforce = fuselage.tangent_n + fuselage.radial_n + fuselage.moment_n;
fuselage.heavyframe_shearforce = fuselage.tangent_s + fuselage.radial_s + fuselage.moment_s;
fuselage.heavyframe_bendingmoment_max = max(abs(fuselage.heavyframe_bendingmoment));
fuselage.heavyframe_normalforce_max = max(abs(fuselage.heavyframe_normalforce));
fuselage.heavyframe_shearforce_max = max(abs(fuselage.heavyframe_shearforce));
end