%% This function calculates the subsonic parasite drag component. It will be evaluated at three different mission segments: Take-Off, Cruise and Landing. 
% Enter values in the order: Main Wing, Fuselage, Nacelle, Horizontal Tail, Vertical Tail : 


function [CD_Parasitic,CD_Parasitic_Total,CD_LandP,Re,Cfc]=Parasitic(rho,v,l,nu,M,xtocmax,ttoc,theta_max,fuselage_length,fuselage_diameter,nacelle_length,nacelle_diameter,SWET,Sref)
%% Determine the Skin Friction Coefficient for Each Component
Re=(rho.*v.*l)./nu;
% %Define the skin roughness value for each component-depends of polish on
% %plane:eg. smooth paint: 2.08*10^-5
k=2.08*10^-5;
%Determine the Cut-off Reynolds number for each component;
Re_cutoff=38.21*((distdim(l,'m','ft'))/k).^1.053;
%Take cut-off Reynolds number if RE>cutoff Re
if Re>Re_cutoff
    Re=Re_cutoff;
end
%Flow is Turbulent over surfaces so below eq is used
x=(1+0.144*(M)^2)^0.65;
y=(log10(Re)).^2.58;
Cfc=(0.455)./(x.*y);


%% Determine Form Factor for each component

%For Wing,Tail,Strut and Pylon (use industry design for pylon-talk to fuselage and nacelle groups)
%Note : For tail surface with hinged rudder or elevator will have form factor 10 percent higher than FF1
i=((0.6./xtocmax).*(ttoc));
j=100.*(ttoc).^4;
FF=(1+i+j).*(1.34.*((M).^0.18).*(cosd(theta_max)).^0.28);
%For fuselage
fd=fuselage_length/fuselage_diameter;
FF(2)=(1+(60/(fd)^3)+(fd/400));
%For nacelle and smooth external store
fn=nacelle_length/nacelle_diameter;
FF(3)=1+(0.35/fn);

%% Component Interference Factors
% Estimates have been made below: 

Q=[1,1,1.3,1.045,1.045]; 

%(fuselage has negligible interference)
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
CD_Parasitic=(Cfc.*FF.*Q.*SWET)/Sref;
CD_Parasitic_Total=sum(CD_Parasitic);
CD_LandP=1.035*CD_Parasitic_Total;
end
