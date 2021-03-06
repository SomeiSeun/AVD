function [WS, TW] = OEI_takeoff(N,L_over_D,CGR)

% inputs are
% N = number of engines
% L_over_D = lift to drag ratio
% CGR = climb gradient rate

% The multiple situations are:
% 0.012 CGR and velocity Vs = 1.2*V_stall_takeoff (Initial climb requirement)
% +ve CGR                                         (Transition segment climb requirement)
% 0.024 CGR and Vs = 1.2*V_stall_takeoff          (Second segment climb requirement)
% 0.012 CGR and 1.25*V_stall                      (En-route climb requirement)
% 0.021 CGR and 1.65*V_stall_landing              (Go around or balked landing)

% outputs are
% T_over_W

WS = [0:10:12500];
TW = zeros(1, length(WS));
TW = TW + (N/(N-1)) * (L_over_D^(-1) + CGR);
end
