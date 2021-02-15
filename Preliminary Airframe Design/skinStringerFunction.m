function [N_alongSpan,t2_alongSpan,sigma,boxHeight] = skinStringerFunction(numSections, wing,E)

%skin-stringer panel calculations
boxHeight=0.15*wing.chord; %thickness of the aerofoil used as height of wing box

%c_alongSpan=(RS_pos-FS_pos)*wingchord; %length of wing box
N_alongSpan=wing.bendingMoment./(wing.boxLength.*boxHeight); %bending moment per unit length at each station
t2_alongSpan= ((((N_alongSpan.*(wing.boxLength.^2))/(3.62*E.YM)).^(1/3)))*1000;
%enforce a minimum thickness of 1mm
for i=1:numSections
    if t2_alongSpan(i)<1.0
        t2_alongSpan(i)=1.0;
    end
end

sigma=N_alongSpan./t2_alongSpan/1000;
end