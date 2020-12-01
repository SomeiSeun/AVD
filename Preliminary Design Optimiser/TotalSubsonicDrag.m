%% Total Drag on A/C

function [CD_0_Total,CD_min]=TotalSubsonicDrag(CD_Parasitic_Total_Takeoff,CD_Misc_Takeoff,CD_LandP_Takeoff,CD_Parasitic_Total_Cruise,CD_Misc_Cruise,CD_LandP_Cruise,CD_Parasitic_Total_Landing,CD_Misc_Landing,CD_LandP_Landing)
CD_0_Takeoff=CD_Parasitic_Total_Takeoff+CD_Misc_Takeoff+CD_LandP_Takeoff;
CD_0_Cruise=CD_Parasitic_Total_Cruise+CD_Misc_Cruise+CD_LandP_Cruise;
CD_0_Landing=CD_Parasitic_Total_Landing+CD_Misc_Landing+CD_LandP_Landing;
CD_0_Total=[CD_0_Takeoff,CD_0_Cruise,CD_0_Landing];
CD_min=2*CD_0_Total;
end 
