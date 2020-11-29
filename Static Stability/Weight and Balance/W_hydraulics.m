function W_hydraulics = W_hydraulics(numControlFunctions, fuseLength, spanWing)
%this function calculates the weight of the hydraulic system in lb

% INPUTS
% numControlFunctions = number of functions performed by controls (typically 4-7)
% fuseLength = total fuselage length (ft)
% spanWing = wing span (ft)

W_hydraulics = 0.2673 * numControlFunctions * (fuseLength + spanWing)^0.937;
end