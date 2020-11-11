%% Inputs Required: 
% undercariage frontal area 
% d=diameter of fuselage;
% Sref=Reference Area
% flapspan
% wingspan
% flap deflection => Typically 60-70 degrees for landing and 20-40 degrees
% for takeoff. This is measured in degrees 
function [C_Duc,C_Dflaps,C_Dwe,C_Dfu,CD_Misc]=MiscD(Area_ucfrontal,Sref,flapspan,wingspan,flapdeflection,A_eff,d,beta)
C_Duc=2.25*(Area_ucfrontal/Sref);
C_Dflaps=0.0023*(flapspan/wingspan)*flapdeflection;
C_Dwe=0.3*(A_eff/Sref);
C_Dfu=3.83*((pi*d^2)/4*Sref)*beta^2.5;
CD_Misc=C_Duc+C_Dflaps+C_Dwe+C_Dfu;
end 