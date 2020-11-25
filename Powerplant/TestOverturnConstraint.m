% Cuando de la fuck

% Housekeeping
clear
clc
close all

% Get inputs
x_cg = 30;
x_rs = 35;
angles = 0.4693224485;
grc = 1.5;
radius = 4.7/2;
z_cg = 0.1;
h_cg = grc + radius + z_cg;

% Initialise x array, initialise main gear x.mg array
x = [0:0.001:60];
x_mg = x;

% Calculate array of y.mg given the x.mg values
y_mg = (x_mg - x_rs)./angles;

% Calculate alpha, beta and gamma
alpha = (tand(63)^2 .*y_mg.^2) - h_cg^2;
beta = (2.*x_mg.*h_cg^2) - (2.*x_cg.*tand(63).*tand(63).*y_mg.*y_mg);
gamma = (h_cg.*h_cg.*y_mg.*y_mg) + (h_cg.*h_cg.*x_mg.*x_mg) - (x_cg.*x_cg.*tand(63).*tand(63).*y_mg.*y_mg);

% Calculate x.ng based on the quadratic solution
x_ng_plus = (-beta + (beta.*beta - 4.*alpha.*gamma))./(2.*alpha);
x_ng_minus = (-beta - (beta.*beta - 4.*alpha.*gamma))./(2.*alpha);

% Plot
plot(x_mg, x_ng_plus, x_mg, x_ng_minus)
xlim([0 100])
ylim([0 100])
axis equal
grid on
