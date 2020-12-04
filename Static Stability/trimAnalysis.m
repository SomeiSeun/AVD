function [iH_trim, iW_trim, AoA_trim, AoA_trimWings, AoA_trimHoriz, CL_trimWings, CL_trimHoriz] =...
    trimAnalysis(CG, wingAC, horizAC, enginePosition, y_MAC, spanWing, cBarWing, SWing, SHoriz, CMoW, CMalphaF,...
    CLtarget, CDtotal, CL_a_Total, CL_ah, twistWing, alpha0W, alpha0H, downwash, etaH)

syms iH AoA iW

%wing and horizontal stabiliser lift coefficients
iW_MAC = iW + twistWing*y_MAC/(spanWing/2); %wing MAC setting angle

%doubling up cruise parameter into [takeoff, cruise start, cruise end, landing]
CMoW = doubleCruise(CMoW);
CLtarget = doubleCruise(CLtarget);
CDtotal = doubleCruise(CDtotal);
CL_a_Total = doubleCruise(CL_a_Total);
CL_ah = doubleCruise(CL_ah);
alpha0W = doubleCruise(alpha0W);
downwash = doubleCruise(downwash);

%defining the lift coefficients of the wing and horizontal tailplane
CLwing = CL_a_Total.*(AoA + iW_MAC - alpha0W)*pi/180;
CLhoriz = CL_ah.*((AoA + iW_MAC - alpha0W).*(1-downwash) + (iH-iW_MAC) - (alpha0H - alpha0W))*pi/180;

%defining the overall lift and moment coefficients
CLtotal = CLwing + etaH*SHoriz/SWing*CLhoriz;
CMtotal = -CLwing.*(wingAC(1) - CG(1,:))/cBarWing + CMoW + CMalphaF*AoA*pi/180 ...
    - etaH*CLhoriz*SHoriz/SWing.*(horizAC(1) - CG(1,:))/cBarWing ...
    - CDtotal.*(enginePosition(3) - CG(3,:))/cBarWing;

eqns = [CLtotal(2) == CLtarget(2), CMtotal(2) == 0, AoA == 0];
vars = [iH, AoA, iW];
[iH_trim(2), AoA_trim(2), iW_trim] = solve(eqns, vars);

CLtotal = subs(CLtotal, iW, iW_trim);
CMtotal = subs(CMtotal, iW, iW_trim);
CLwing = subs(CLwing, iW, iW_trim);
CLhoriz = subs(CLhoriz, iW, iW_trim);

CL_trimWings(2) = subs(CLwing(2), AoA, AoA_trim(2));
CL_trimHoriz(2) = subs(CLhoriz(2), {iH, AoA}, {iH_trim(2), AoA_trim(2)});

%aircraft total lift and moment coefficient about cg
for i = [1,3,4] 
    eqns = [CLtotal(i) == CLtarget(i); CMtotal(i) == 0];
    vars = [iH, AoA];
    [iH_trim(i), AoA_trim(i)] = solve(eqns, vars);
    
    CL_trimWings(i) = subs(CLwing(i), AoA, AoA_trim(i));
    CL_trimHoriz(i) = subs(CLhoriz(i), {iH, AoA}, {iH_trim(i), AoA_trim(i)});
end

iW_trim = double(iW_trim);
iH_trim = double(iH_trim);
AoA_trim = double(AoA_trim);

CL_trimWings = double(CL_trimWings);
CL_trimHoriz = double(CL_trimHoriz);

AoA_trimWings = AoA_trim + iW_trim;
AoA_trimHoriz = (AoA_trim + iW_trim - alpha0W).*(1-downwash) + (iH_trim-iW_trim) + alpha0W;
end