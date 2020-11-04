%% T/W for a Level Constant-Velocity Turn
% The following code uses an expression obtained from Gudmunson to
% determine the T/W Ratio required to maintain a specific banking load.

%you can enter the following inputs
%rho=1.055(interpolated)
%theta=30
%v=depends on what segment- eg: loiter=112.02m/s

function [Toverw]= ConsVT(rho, theta, v);
%Bank Angle 
%Density (depends on altitude)
%Velocity (depends on segment)
%Cd minimum(Defined below as Cd_Min)
%Lift Induced Drag (Defined below as k)
%Outputs:
% T/W for different W/S

k=0.0407;
Cd_min=0.02;

% Determine Dynamic Pressure
q=0.5*rho*v^2;

% Determined Load factor
n=1/cos(theta*(pi/180));
 
%Array for Wo/Sref
Wo=[0.1:10:11000];

Toverw=q*((Cd_min./(Wo)+k*((n/q)^2).*(Wo)));
plot(Wo,Toverw)
ylim([0,1]);
xlim([0,11000]);
end 
