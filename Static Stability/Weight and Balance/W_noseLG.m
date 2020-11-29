function W_noseLG = W_noseLG(W_Landing, Ngear, lengthNoseLG, NumNoseWheels, Knp)
% this function calculates the main landing gear weight in lbs

% INPUTS
% W_Landing = landing design gross weight aka max landing weight (lb)
% Ngear = ratio of landing load on main gear to max landing weight (typically 2.7-3)
% lengthNoseLG = length of nose landing gear (in)
% NumNoseWheels = number of nose wheels

W_noseLG = 0.032 * W_Landing^0.646 * (1.5*Ngear)^0.2 * lengthNoseLG^0.5 * NumNoseWheels^0.45;
end