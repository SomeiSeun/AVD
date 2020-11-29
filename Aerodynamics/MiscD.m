%% Inputs Required: 
% undercariage frontal area 
% d=diameter of fuselage;
% Sref=Reference Area
% flapspan
% wingspan
% flap deflection => Typically 60-70 degrees for landing and 20-40 degrees
% for takeoff. This is measured in degrees 
function [C_Duc,C_Dwe,C_Dfu,CD_Misc]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta)
C_Duc=2.25*(Area_ucfrontal/Sref);   % same value for take-off and landing. Nothing for cruise
C_Dflaps=0.0023*(flapspan/wingspan)*flapdeflection; %flaps and slats are not deployed during cruise. Only take-off and values will be calculated.
C_Dwe=0.3*(A_eff/Sref); % Same value for take-off,cruise and landing. Will be calculated for no enginer failure, one engine failure and all engine failure
C_Dfu=3.83*((pi*d^2)/(4*Sref))*(beta)^2.5 % one value for all three segments
CD_Misc=C_Duc+C_Dflaps+C_Dwe+C_Dfu;
end 