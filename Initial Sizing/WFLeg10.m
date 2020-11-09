function WF10 = WFLeg10(WF6, H_Loiter, H_Cruise)
% Leg 10: Descent
% This value is taken from Roskam. It can and will be updated to a higher
% fidelity model soon.
WF10 = 1 - ( (1-WF6) * H_Loiter/H_Cruise );
end
