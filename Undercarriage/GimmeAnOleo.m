function [Oleo] = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire, W_landing, N_oleos, percent)
% This function calculates the length of the strut

g = 32.185039; %ft/s2
Oleo.Stroke = 12 * ( ((V_Vertical * V_Vertical)/(2 * g * eta_oleo * N_g)) - ((eta_tire/eta_oleo)*Stroke_tire) ) + 1; %inch
Oleo.TotalLength = Oleo.Stroke * 2.5; %inch, to get total size
L_oleo = N_g * W_landing*(2.20462262/9.81) * (1/N_oleos) * percent;
Oleo.Diameter = 0.04 * sqrt(L_oleo);
end