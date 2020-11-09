function [WS, TW] = Landing(C_LMaxLanding, Kr, Alpha)
% This function would provide an array of values of TW and WS which can be
% used to plot the landing constraints.

LDA = 2200;
LDR = LDA;
ALD = 0.6*LDR;
Sa = 305;

[~,~,~,rho] = atmosisa(0);

% ALD = 0.51(W/S)/(rho*C_LMaxLanding) * Kr  + Sa as seen in slides. This
% can be rearranged for W/S and applying correction to get W0/S;
TW = [0:0.01:1];
WS = zeros(1, length(TW));
WS = WS + (rho * C_LMaxLanding * (ALD - Sa))/(0.51 * Kr * Alpha);
end