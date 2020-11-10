function [WS, TW] = SEP(H_Segment, Vinf, dhdt, dVinfdt, alpha, beta, n, AspectRatio, e, C_D0)
% This is the specific excess power equation which can be used for point
% performance. This can be applied to cruise, diversion and loiter
% segments. Could probably be applied to climb segments as well once we can
% figure the correct inputs for them.

[~,~,~,rho] = atmosisa(H_Segment * 0.3048);

WS = [0:10:12500];

TW = (alpha/beta) .* ( (1/Vinf)*dhdt  +  (1/9.81)*dVinfdt  +  (0.5*rho*Vinf*Vinf*C_D0)./(alpha.*WS)  +  (alpha*n*n.*WS)./(0.5*rho*Vinf*Vinf*pi*AspectRatio*e) );

end