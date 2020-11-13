%% This function calculates the subsonic parasite drag component. It will be evaluated at three different mission segments: Take-Off, Cruise and Landing. 
% Enter values in the order: Main Wing, Fuselage, Nacelle, Horizontal Tail, Vertical Tail : 
 
function [CD_Parasitic,Cf,f,FF]=Parasitic(rho,v,l,nu,M,xtocmax,ttoc,theta_max,d,S_wet,Sref)
%% Determine the Reynolds number for each component:
Re=(rho.*v.*l)./nu;
% %Define the skin roughness value for each component-depends of polish on
% %plane:eg. smooth paint: 2.08*10^-5
k=2.08*10^-5;
%Determine the Cut-off Reynolds number for each component;
Re_cutoff=38.21*((distdim(53.5896,'m','ft'))/k).^1.053;
%Take cut-off Reynolds number if RE>cutoff Re
if Re>Re_cutoff
    Re=Re_cutoff;
end
% Determine whether flow is turbulent or laminar
if Re>5*10^5
Cf=0.455/(((log10(Re))^2.58)*(1+(0.144*M^2))^0.65);
else 
Cf=1.328./sqrt(Re);    
end

%% Determine Form Factor for each component

%For Wing,Tail,Strut and Pylon (use industry design for pylon-talk to fuselage and nacelle groups)
%FF1=(1+((0.6/(xtocmax))*(ttoc))+(100*(ttoc)^4))*(1.34*(M^0.18)*(cos(theta_max))^0.28);
%Note : For tail surface with hinged rudder or elevator will have form factor 10 percent higher than FF1

%For fuselage
f=l/d;
FF=(1+(60/f^3)+(f/400));

%For nacelle and smooth external store
%FF3=1+(0.35/f);

%% Component Interference Factors
% Estimates have been made below: 

Q=1; %(fuselage has negligible interference)
%Q_mainwing=1 (for a well filletted low wing)
%Q_nacelles=1.3 (if it is mounted less than one diameter away, if greater
%than one diameter it can be reduced to near 1)
%Q_conv=1.045 (average between 4 and 5 %)

%% Areas of component 
%Swet- obtained from design groups
%For Wing and Tail
%S_wet=S_exposed*(1.997+0.52*(ttoc));
%For Fuselage
%For Nacelle
%% Calculation of Parasitic Drag 
CD_Parasitic=(Cf*FF*Q*S_wet)/Sref;
end% Parasitic(0.3796,237.2284,53.5896,0.000014389,0.8,0,0,0,5.12039,654.4325,277.4934)
