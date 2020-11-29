function W_instruments = W_instruments(numCrew, numEngines, fuseLength, spanWing)
%this function calculates the weight of the instruments in lb

% INPUTS
% numCrew = number of crew
% numEngines = number of engines
% fuseLength = total fuselage length (ft)
% spanWing = wing span (ft)

W_instruments = 4.509 * numCrew^0.541 * numEngines * (fuseLength + spanWing)^0.5;
end