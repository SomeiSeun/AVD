function [iH_trim, AoA_trim, AoA_trimWings, AoA_trimHoriz, CL_trimWings, CL_trimHoriz] =...
    trimAnalysis(CG, wingAC, horizAC, enginePosition, cRootWing, cBarWing, SWing, SHoriz, CMoW, CMalphaF,...
    CLtarget, CDtotal, CL_a_Total, CL_ah, twistWing, iW, alpha0W, alpha0H, downwash, etaH)

%wing and horizontal stabiliser lift coefficients

iW_MAC = iW + twistWing*cBarWing/cRootWing; %wing MAC setting angle

syms iH AoA
CLwing = CL_a_Total*(AoA + iW_MAC - alpha0W)*pi/180;
CLhoriz = CL_ah.*((AoA + iW_MAC - alpha0W).*(1-downwash) + (iH-iW_MAC) - (alpha0H - alpha0W))*pi/180;

%aircraft total lift and moment coefficient about cg
CLtotal = CLwing + etaH*SHoriz/SWing*CLhoriz;
CMtotal = -CLwing.*(wingAC(1) - CG(1,:))/cBarWing + CMoW + CMalphaF*AoA ...
    - etaH*CL_ah*SHoriz/SWing.*(horizAC(1) - CG(1,:))/cBarWing ...
    - CDtotal.*(enginePosition(3) - CG(3,:))/cBarWing;

for i = 1:length(CLtotal)
    eqns = [CLtotal(i) == CLtarget(i); CMtotal(i) == 0];
    vars = [iH, AoA];
    [iH_trim(i), AoA_trim(i)] = solve(eqns, vars);
    
    CL_trimWings(i) = subs(CLwing(i), AoA, AoA_trim(i));
    CL_trimHoriz(i) = subs(CLhoriz(i), {iH, AoA}, {iH_trim(i), AoA_trim(i)});
end

iH_trim = double(iH_trim);
AoA_trim = double(AoA_trim);

CL_trimWings = double(CL_trimWings);
CL_trimHoriz = double(CL_trimHoriz);

AoA_trimWings = AoA_trim + iW_MAC;
AoA_trimHoriz = (AoA_trim + iW_MAC - alpha0W).*(1-downwash) + (iH_trim-iW_MAC) + alpha0W;
end