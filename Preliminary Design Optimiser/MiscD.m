%% Inputs Required: 
% Area_ucfrontal undercarriage frontal area 
% d=diameter of fuselage;
% Sref=Reference Area
% flapspan
% wingspan
% beta-upsweep angle
% flap deflection => Typically 60-70 degrees for landing and 20-40 degrees
% for takeoff. This is measured in degrees 
function [CD_Misc_Takeoff,CD_Misc_Cruise,CD_Misc_Landing,C_Dfu]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flap_deflection_takeoff,flap_deflection_landing,A_eff,d,beta)
C_Duc=2.25*(Area_ucfrontal/Sref);                                            % same value for take-off and landing. Nothing for cruise
C_Dflaps_takeoff=0.0023*(flapspan/wingspan)*20;            %flaps and slats are not deployed during cruise. Only take-off and values will be calculated.
C_Dflaps_landing=0.0023*(flapspan/wingspan)*40;
C_Dwe=0.3*(A_eff/Sref);                                                         % Same value for take-off,cruise and landing. Will be calculated for no enginer failure, one engine failure and all engine failure
C_Dfu=3.83*((pi*d^2)/(4*Sref))*(beta)^2.5;                                      % one value for all three segments
CD_Misc_Takeoff=C_Duc+C_Dflaps_takeoff+C_Dwe+C_Dfu;
CD_Misc_Cruise=C_Dfu;
CD_Misc_Landing=C_Duc+C_Dflaps_landing+C_Dwe+C_Dfu;
end 