function W_furnish = W_furnish(numCrew, W_maxCargo, fuseWetted, W_seats, numPeopleOnboard)
%this function calculates the weight of furnishings in lb

% INPUTS
% numCrew = no. of crew
% W_maxCargo = max cargo weight (lb)
% fuseWetted = fuselage wetted area (ft2)
% W_seats = total weight of seats (lb) - typical 60lbs per flight deck seats, 32lbs for passenger seats
% numPeopleOnboard = total number of people onboard (crew + passengers)
    
W_furnish = 0.0577 * numCrew^0.1 * W_maxCargo^0.393 * fuseWetted^0.75 +...
    W_seats + 1.11*numPeopleOnboard^1.33 + 5.68*numPeopleOnboard^1.12;
end