%% This function will calculate the Lift Curve Slope for both the horzontal and vertical tails. 
% The tail aerodynamic analysis is calculated using the same methods as for
% wing lift analysis. However the following assumptions are taken into
% account: The fuselage spillover factor may be ignored for a horizontal
% tail, the wetted area is roughly the same as reference area, cruise
% conditions will be used as we want to ensure trimmed flight during cruise
%. 

function [CL_ah]=HLCS(AR,S_exposed,S_ref,M,sweepanglemax,Cl_am)
%exposed area same as reference area for the horizontal tail? 
beta=sqrt(1-M^2); % to account for compressibility effects
F=1; % neglect fuselage spillover lift factor for horixontal tail. 
eta=(beta*Cl_am)/2*pi; %airfoil efficiency factor
a=2*pi*AR*(S_exposed/S_ref)*F;
b=((AR*beta)/eta)^2;
c=((1+(tan(sweepanglemax))^2)/beta^2);
CL_a=a/(2+sqrt(4+b*c));
end 