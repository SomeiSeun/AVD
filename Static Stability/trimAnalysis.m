function [iH_trim, AoA_trim] = trimAnalysis(CG, wingAC, horizAC, enginePosition, cBarWing, SWing, SHoriz, CMoW, CMalphaF, CLtarget, CDtotal, CL_a_Total, CL_ah, twistWing, alpha0W, alpha0H, downwash, etaH)

%wing setting angle to ensure horizontal fuselage during cruise
iW = 180/pi*CLtarget(2)/CL_a_Total(2) + alpha0W - 0.4*twistWing;

%wing and horizontal stabiliser lift coefficients
syms iH AoA
CLwing = CL_a_Total*(AoA + iW - alpha0W)*pi/180;
CLhoriz = CL_ah.*((AoA + iW - alpha0W).*(1-downwash) + (iH-iW) - (alpha0H - alpha0W))*pi/180;

%aircraft total lift and moment coefficient about cg
CLtotal = CLwing + etaH*SHoriz/SWing*CLhoriz;
CMtotal = -CLwing.*(wingAC(1) - CG(1,:))/cBarWing + CMoW + CMalphaF*AoA ...
    - etaH*CL_ah*SHoriz/SWing.*(horizAC(1) - CG(1,:))/cBarWing ...
    - CDtotal.*(enginePosition(3) - CG(3,:))/cBarWing;

for i = 1:length(CLtotal)
    eqns = [CLtotal(i) == CLtarget(i); CMtotal(i) == 0];
    vars = [iH, AoA];
    [iH_trim(i), AoA_trim(i)] = solve(eqns, vars);
end

iH_trim = double(iH_trim);
AoA_trim = double(AoA_trim);
end