function[W_WheelMainGear, W_WheelNoseGear, W_DynamNoseGear, LbsReqMainGear, LbsReqNoseGearStatic, LbsReqNoseGearDynamic] = WheelLoads(W0, x_NoseGear, x_MainGear, x_cg_min, x_cg_max, z_cg_max)
% This function is used to calculate the wheel loads

% Going off of the rough guidelines, we can decide to have the main gear
% split into two struts each carrying a twin tandem bogey configuration of
% wheels. For the dynamic load we are assuming a 10ft/s2 deceleration. That
% is the value 10 input there. This figure comes from assuming a breaking
% coefficient of 0.3 which is typical for hard runways. This gives a
% typical value of 10ft/s2.

W_WheelMainGear = (1.07/8)*W0*( ((x_cg_min+x_cg_max)/2) - x_NoseGear )/(x_MainGear - x_NoseGear);   % With 7% safety factor. Removing this can show true load.
W_WheelNoseGear = (1.07/2)*W0*( x_MainGear - ((x_cg_min+x_cg_max)/2) )/(x_MainGear - x_NoseGear);   % With 7% safety factor. It adds up correctly.
W_DynamNoseGear = (10*z_cg_max*W0)/( 32.1850394*(1/0.3048)*(x_MainGear-x_NoseGear) );               % Need to take MTOW because this can occur during takeoff run.

LbsReqMainGear = (W_WheelMainGear/9.81) * 2.20462262;
LbsReqNoseGearStatic = (W_WheelNoseGear/9.81) * 2.20462262;
LbsReqNoseGearDynamic = (W_DynamNoseGear/9.81) * 2.20462262;
end