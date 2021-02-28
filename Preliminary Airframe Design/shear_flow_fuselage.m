function fuselage = shear_flow_fuselage(A_s, y_s, Sy, A_fus, N, T, SYS, fuselage)

% This function finds out the shear force distribution for a Fuselage CSA
% The INPUTS are:
% A_s = area of a stringer
% y_s = distance of the stringers from neutral axis in y axis
% Sy = shear force
% A_fus = area of the fuselage section
% N = number of stringers
% T = torque on the fuselage cross section
% SYS = Shear Yield Stress for the chosen material
% fuselage = structure to stop it being overwritten

% The OUTPUTS are:
% fuselage = structure with q, qb and q0 added

fuselage.q_b = zeros(1,N);
fuselage.q_0 = zeros(1,N);

for i = 1:length(N)
    fuselage.heavyframeIxx(i) = A_s * y_s(i);
end

fuselage.heavyframeIxxtotal(i) = sum(fuselage.heavyframeIxx);

for i = 1:length(N)
    fuselage.q_b(i) = (-(Sy / fuselage.heavyframeIxxtotal) * A_s * y_s(i));
    fuselage.q_0(i) = T / (2 * A_fus);
    fuselage.q(i) = fuselage.q_b(i) + fuselage.q_0(i);
    fuselage.crossectionthickness(i) = fuselage.q(i) / SYS;
end
end