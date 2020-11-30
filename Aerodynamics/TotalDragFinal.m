function [CD_iw,CD_ih,CD_Total]=TotalDragFinal(CL_trimWings,CL_trimHoriz,SHoriz,Sref,CD_0_Total)
K=0.04096652332;
K_h=0.09205;
CD_iw=K*((CL_trimWings).^2);
CD_ih=0.9.*(SHoriz/Sref).*K_h.*((CL_trimHoriz).^2);
CD_Total=CD_0_Total+CD_iw+CD_ih;
end 