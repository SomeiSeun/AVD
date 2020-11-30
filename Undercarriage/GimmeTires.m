function Wheel = GimmeTires(minLoad, maxPSI, maxDiam)
% This function takes load bearing requirements as well as maximum pressure
% and diameter (and can expand to any other requirements) and finds the
% tires that succeed each criteria. It then finds the successful tire with
% the minimum diameter. This can also be expanded to include other
% optimisers.

% Load data
load('Wheels_All_Table.mat')

% Remove all wheels that don't meet minimum load criteria
toRemove = WheelsAll.RatedLoadLBS < minLoad;
WheelsAll(toRemove, :) = [];

% Remove all wheels that have too high a tire pressure
toRemove = WheelsAll.RatedInflationPSI > maxPSI;
WheelsAll(toRemove, :) = [];

% Remove all wheels that are too big
toRemove = WheelsAll.InflatedOuterDiamMaxINCH > maxDiam;
WheelsAll(toRemove, :) = [];

% Check if any wheels still satisfy the requirements
if size(WheelsAll) == [0 23]
    
    % Which means no wheels available
    Wheel = 0;
    
else
    
    % Sort successful wheels by diameter
    sortrows(WheelsAll, 9);
    
    % Pick the first wheel
    Wheel = WheelsAll(1,:);
    
end

end