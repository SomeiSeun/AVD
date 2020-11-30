%% This script runs a function which determines the Lift-Curve Slope for all lifting surfaces (main wing, horizontal tail and vetrical tail)

%% Inputs
%AR= Wing aspect ratio----> this will change to AR_effective if we add
%winglets
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
%LCS with HLD

%%
function [CL_a,CL_max_clean,delta_alpha_takeoff,delta_alpha_landing,delta_CL_max,CL_max_takeoff,CL_max_landing,takeoff_factor,landing_factor,zeroAlphaLCT]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,sweepanglemax,Cl_am,chord_ratio,Cl_max,flapped_ratio,sweep_quarterchord,sweep_HLD)
beta=sqrt(1-(M).^2);% to account for compressibility effects;
F=1.07*(1+(d/b))^2;
% fuselage spillover lift factor
eta=0.95;
a=2*pi*AspectRatio*1;
B=((AspectRatio.*beta)/eta).^2;
c=(1+(tand(sweepanglemax)./beta).^2);
CL_a=a./(2+sqrt(4+(B.*c)));

CL_max_clean=0.9.*Cl_max.*cosd(sweep_quarterchord);                        % Determine CL max for clean configuration

delta_CL_max=1.26*Cl_max.*(flapped_ratio)*cosd(sweep_HLD);                 % Determine additional CL_max due to HLD
CL_max_landing=CL_max_clean+delta_CL_max;                                  % Calculate CL_max at take-off and landing
CL_max_takeoff=CL_max_clean+0.7*(delta_CL_max);

takeoff_factor=(1+(chord_ratio-1.09)*(flapped_ratio));                     % Calculate the additional amount to add to LCS
landing_factor=(1+(chord_ratio-1)*(flapped_ratio));

%Change in zero-lift angle of attack when flaps and leading edge devices
%are considered.
delta_alpha_takeoff=(-10)*(flapped_ratio)*cosd(20.9647);
delta_alpha_landing=(-15)*(flapped_ratio)*cosd(20.9647);
alpha_zero_takeoff=-6.349*pi/180;
zeroAlphaLCT=CL_a(1)*(0-alpha_zero_takeoff);

end 
