function W_aircon = W_aircon(numPeopleOnboard, volumePressurised, W_avionics_uninstalled)
% this function calculates the weight of the air-conditioning system in lb

% INPUTS
% numPeopleOnboard = total number of people onboard (crew + passengers)
% volumePressurised = total volume of pressurised sections (ft3)
% W_avionics_uninstalled = uninstalled avionics weight (typically 800-1400) (lb)

W_aircon = 62.36 * numPeopleOnboard^0.25 * (volumePressurised*1e-3)^0.604 * W_avionics_uninstalled^0.1;
end