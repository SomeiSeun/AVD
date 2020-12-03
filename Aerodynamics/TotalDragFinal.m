function [CL_Target,CD_Total,LtoDMax,CLmD,Drag_Landing]=TotalDragFinal(W0,WF1,WF2,WF3,WF4,WF5,WF6,WF7,WF8,WF9,WF10,rho_takeoff,rho_cruise,rho_landing,V_Cruise,V_Stall_Landing,Sref,CD_0_Total,AspectRatio)
K=0.04096652332;
e=1/K;
CL_Takeoff=(W0*WF1*WF2*WF3)/(0.5*rho_takeoff*(1.15*V_Stall_Landing)^2*Sref);
CL_Cruise=(W0*WF1*WF2*WF3*WF4)/(0.5*rho_cruise*(V_Cruise)^2*Sref);
CL_Landing=(W0*WF1*WF2*WF3*WF5*WF6*WF7*WF8*WF9*WF10)/(0.5*rho_landing*(1.3*V_Stall_Landing)^2*Sref);
CL_Target=[CL_Takeoff,CL_Cruise,CL_Landing];
CD_Total=CD_0_Total+(K.*(CL_Target).^2);
LtoDMax=0.5*sqrt((pi.*AspectRatio.*0.85)./CD_0_Total);
CLmD=sqrt((AspectRatio*pi*0.85).*CD_0_Total);
% K=0.04096652332;
% K_h=0.09205;
% e=0.85;
% CD_iw=K*((CL_trimWings).^2);
% CD_ih=0.9.*(SHoriz/Sref).*K_h.*((CL_trimHoriz).^2);
% CD_Total=CD_0_Total+CD_iw+CD_ih;
Drag_Landing=0.5*rho_landing*(1.3*(V_Stall_Landing)^2)*Sref*CD_Total(3);
end 