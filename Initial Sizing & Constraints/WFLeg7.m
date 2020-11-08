function WF7 = WFLeg7()
% Leg 7: Climb and accelerate to diversion altitude
% This value is taken from Roskam. Can upgrade to climb equations. A
% slightly higher fidelity for now can be achieved by linearly
% interpolating the value for the first climb (Leg 4) using the altitude
% differences
WF7 = 0.97;
end
