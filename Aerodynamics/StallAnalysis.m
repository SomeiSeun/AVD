%% This script carries out stall analysis on our aircraft and will output the stall speed
%The stall speed may be determined directly from the wing loading obtained
%at the conceptual poster stage and maximum lift coefficient.
%They will be calculated for take-off, cruise, apprach and landing.

function [Vstall]= StallAnalysis(WtoS,rho,Clmax)
Vstall=sqrt((2*WtoS)/(rho*Clmax));
end 