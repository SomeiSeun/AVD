%% Stall Speeds
function [V_Stall_Landing]=StallSpeed(W0,WF1,WF2,WF3,WF4,WF5,WF6,CL_max_landing,rho_landing,Sref)
W_Landing=W0*WF1*WF2*WF3*WF4*WF5*WF6;
V_Stall_Landing=sqrt((2*W_Landing)/(CL_max_landing*rho_landing*Sref));
end 
