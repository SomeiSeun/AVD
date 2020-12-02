function [CD_iw,CD_ih,CD_Total,Drag_Landing,LtoDMax,CLmD]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,Sref,CD_0_Total,rho_landing,V_landing,AspectRatio)
K=0.04096652332;
K_h=0.09205;
e=0.85;
CD_iw=K*((CL_trimWings).^2);
CD_ih=0.9.*(SHoriz/Sref).*K_h.*((CL_trimHoriz).^2);
CD_Total=CD_0_Total+CD_iw+CD_ih;
Drag_Landing=0.5*rho_landing*(V_landing^2)*Sref*CD_Total(3);
LtoDMax=0.5*sqrt((pi.*AspectRatio.*e)./CD_0_Total);
CLmD=sqrt((AspectRatio*pi*e).*CD_0_Total);
end 