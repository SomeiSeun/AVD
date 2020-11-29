function W_mainLG = W_mainLG(W_Landing, Ngear, lengthMainLG, NumMainWheels, Vstall_Landing, NumMainShockStruts, Kmp)
% this function calculates the main landing gear weight in lbs

% INPUTS
% W_Landing = landing design gross weight aka max landing weight (lb)
% Ngear = ratio of landing load on main gear to max landing weight (typically 2.7-3)
% lengthMainLG = length of main landing gear (in)
% NumMainWheels = number of main wheels
% Vstall_Landing = landing stall speed (ft/s)
% NumMainShockStruts = number of main gear shock struts

W_mainLG = 0.0106 * W_Landing^0.888 * (1.5*Ngear)^0.25 * lengthMainLG^0.4 *...
    NumMainWheels^0.321 * Vstall_Landing^0.1 / NumMainShockStruts^0.5;
end