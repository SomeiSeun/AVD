%% This function calculates the maximum lift in the clean configuration given a set of inputs. 
%The maximum lift coefficient of a clean wing will usually be about 90% of
%the airfoild maximum lift as determined from the 2-D Aerofoil data at
%similar reynolds numbers. 
%% Inputs required:
% Cl_max=maximum lift coefficient of the airfoil: determined from 2-D airfoil data at a similar reynolds number
% sweep_quarterchord=quarter-chord sweep
% S_flapped=flapped planform areas
% S_ref=planform reference area

%% Outputs: 
% Maximum Lift Coefficient 
% Addition of CLmax due to HLD
% Change in zero lift angle of attack due to HLD

function [CL_max_clean,delta_CL_max, delta_alpha_zero]=MaxLift(Cl_max,sweep_quarterchord,S_flapped,S_ref,sweep_HLD)
%MaxLift uses a sweep correction to estimate the maximum lift coefficient:
CL_max_clean=0.9*Cl_max*cosd(sweep_quarterchord);
%The effect of HLD may be estimated using: 
% delta_CL_max=Cl_max*(S_flapped/S_ref)*cos(sweep_HLD);
% delta_alpha_zero=delta_alpha_zeroairfoil*(S_flapped/S_ref)*cos(sweep_HLD);
end 