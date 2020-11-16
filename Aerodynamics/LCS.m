%% This script runs a function which determines the Lift-Curve Slope for all lifting surfaces (main wing, horizontal tail and vetrical tail)

%% Inputs
%AR= Wing aspect ratio----> this will change to AR_effective if we add
%S_exposed=Exposed planform area of wing
%S_ref=Reference planform area of wing
%d=diameter of fuselage
%b=wing span
%Cl_a= airfoil lift curve slope as a function of Mach number-so depends on
%take off, cruise and landing mach numbers. Use empirical data for this?? 
%M= Mach number at take-off, cruise and landing 
%sweepanglemax=sweep of the wing at  the chord location where the airfoil
%is thickest.

%% Outputs
%Main-Wing LCS
%Horizontal Tail LCS
%Vertical Tail LCS


function [CL_a]=LCS(AspectRatio,S_exposed,Sref,d,b,M,sweepanglemax,Cl_am)
beta=sqrt(1-M^2);% to account for compressibility effects;
F=1.07*(1+(d/b))^2;% fuselage spillover lift factor
eta=0.95;
%eta=(beta*Cl_am)/2*pi; %airfoil efficiency factor
a=2*pi*AspectRatio*(S_exposed/Sref)*F;
b=((AspectRatio*beta)/eta)^2;
c=(1+(tand(sweepanglemax)/beta)^2);
CL_a=a/(2+sqrt(4+(b*c)));
end 
