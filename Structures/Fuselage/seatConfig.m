function WF8 = seatConfig(passengers, crew, noAbreast, lavRatio, noExit, pitch, )
% Function that takes base inputs from Design configuration relating to
% number of passengers for single class seating layout.

%% Inputs
% passengers    - number of passengers
% crew          - number of crew members (non pilot)
% noAbreast     - number of seats side by side
% lavRatio      - ratio of lavatories to passengers (lav per pax)
% noExit        - number of emergency exits
% pitch         - seat pitch in degrees


%% Outputs
% 

%% Code

% This is calculated using the Breguet range equation which gives the
% weight fraction as exp(-Rc/v(L/D)) where
    % R is range in m
    % c is fuel consumption in lb/lb/hr
    % v is velocity in m/s
    % L/D is cruise lift to drag ratio, optimum at 0.866*(L/D)max
    
% Geopotential heights are not used yet, consider this next.

%[~, a_Divert, ~, ~] = atmosisa(H_Divert * 0.3048);

%V_Divert = (3^0.25)*VmDCalculator(VimD, H_Divert, WeightRatio);

%WF8 = exp(- (R_Divert * 1000 * C_Divert)/(V_Divert * L_DMax * 0.866 * 3600));


%end