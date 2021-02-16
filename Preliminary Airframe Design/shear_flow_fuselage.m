function fuselage = shear_flow_fuselage(A_s, y_s, Sy, I_xx, A_fus, N, Sx, I_yy, x_s)

% This function finds out the shear force distribution for a Fuselage CSA
% The INPUTS are:
% A_s = area of the stringer
% y_s = distance of the stringers from neutral axis 
% Sy = shear force 
% I_xx = second moment of area of the fuselage section
% A_fus = area of the fuselage section
% N = number of stringers

% The OUTPUTS are:
% fuselage = structure with q, qb and q0 added

fuselage.q_b = zeros(1,N);
fuselage.q_0 = zeros(1,N);

for i = 1:length(N)
    fuselage.q_b(i) = (-(Sy / I_xx) * A_s * y_s(i)) - ((Sx / I_yy) * A_s * x_s(i));
    fuselage.q_0(i) = T / (2 * A_fus);
    fuselage.q(i) = fuselage.q_b(i) + fuselage.q_0(i);
end

end