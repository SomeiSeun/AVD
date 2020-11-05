function VimD = VimDCalculator(H_Cruise, M_Cruise)
% This function is going to be used to calculate the "target" indicated
% minimum drag speed. This is a useful quantity because it is constant for
% a given weight and also relates to the most efficient velocities for
% cruise and loiter in a simple relation. We will target making VimD
% according to the cruise speed for optimal performance.

gamma = 1.4;

[~, a_Cruise, P, ~] = atmosisa(H_Cruise * 0.3048);
[~, a_SL, P_SL, ~] = atmosisa(0);

V_Cruise = M_Cruise * a_Cruise;
VmD = V_Cruise / 3^0.25;
MmD = VmD / a_Cruise;

P0 = P * (1 + ((gamma-1)/2)*MmD^2 ) ^ (gamma/(gamma-1));
VimD = sqrt( ((2*a_SL^2)/(gamma-1)) * (  ((P0-P)/P_SL + 1)^((gamma-1)/gamma) - 1  ) );
end