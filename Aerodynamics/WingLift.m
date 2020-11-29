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


function [CL_a,CL_max_clean,CL_aflaps,delta_alpha_zero,delta_CL_max]=WingLift(AspectRatio,S_exposed,Sref,d,b,M,sweepanglemax,Cl_am,chord_ratio,Cl_max,S_flapped,sweep_quarterchord,sweep_HLD,delta_alpha_zeroairfoil)
beta=sqrt(1-(M).^2);% to account for compressibility effects;
F=1.07*(1+(d/b))^2;% fuselage spillover lift factor
eta=0.95;
%eta=(beta*Cl_am)/2*pi; %airfoil efficiency factor
a=2*pi*AspectRatio*(S_exposed/Sref)*F;
B=((AspectRatio.*beta)/eta).^2;
c=(1+(tand(sweepanglemax)./beta).^2);
CL_a=a./(2+sqrt(4+(B.*c)));

% Determine maximum lift coefficient in clean configuration 
delta_CL_max=Cl_max.*(S_flapped/Sref)*cos(sweep_HLD);

%Effect of HLD added
CL_aflaps=(CL_a).*(1+(chord_ratio-1)).*(S_flapped/Sref);

%Change in zero-lift angle of attack when flaps and leading edge devices
%are considered.
delta_alpha_zero=delta_alpha_zeroairfoil.*(S_flapped/Sref).*cos(sweep_HLD);

%Determining CL_max for clean configuration: 
CL_max_clean=0.9.*Cl_max.*cosd(sweep_quarterchord);

end 
