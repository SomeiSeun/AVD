%% Calculate Total Aircraft Max Lift during Take-Off and Landing

function [maxLiftLanding,maxLiftTakeoff,AoA_Stall_Wing,AoA_Stall_Tail]=TotalLift(CL_max_landing,CL_max_takeoff,CL_max_clean,CL_a_Total,CL_ah,CL_max_h,SHoriz,Sref,rho_landing,V_landing,rho_takeoff,V_takeoff,alpha_zero_takeoff,alpha_zero_landing)
CL_max_Total_Landing=CL_max_landing+(0.9*CL_max_h*(SHoriz/Sref));
CL_max_Total_Takeoff=CL_max_takeoff+(0.9*CL_max_h*(SHoriz/Sref));
maxLiftLanding=0.5*(rho_landing)*(V_landing^2)*Sref*CL_max_Total_Landing;
maxLiftTakeoff=0.5*(rho_takeoff)*(V_takeoff^2)*Sref*CL_max_Total_Takeoff;
AoA_Stall_Wing_Clean=rad2deg((CL_max_clean/CL_a_Total(2))+(-1.8*pi/180));
AoA_Stall_Wing_Takeoff=rad2deg(CL_max_takeoff/CL_a_Total(1)+(alpha_zero_takeoff*pi/180));
AoA_Stall_Wing_Landing=rad2deg(CL_max_landing/CL_a_Total(3)+(alpha_zero_landing*pi/180));
AoA_Stall_Tail_Clean=rad2deg(CL_max_h/CL_ah(2));
AoA_Stall_Tail_Takeoff=rad2deg(CL_max_h/CL_ah(1));
AoA_Stall_Tail_Landing=rad2deg(CL_max_h/CL_ah(3));
AoA_Stall_Wing=[AoA_Stall_Wing_Takeoff,AoA_Stall_Wing_Clean,AoA_Stall_Wing_Landing];
AoA_Stall_Tail=[AoA_Stall_Tail_Takeoff,AoA_Stall_Tail_Clean,AoA_Stall_Tail_Landing];
end 