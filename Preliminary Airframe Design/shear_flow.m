function [tw1,tw2] = shear_flow(n, K_s, rho, V, E, b1, b2, flex_ax, cm0, cg)

% This function is used to find the thicknesses for the spar web

% The inputs are:
% n = load factor
% K_s = buckling coefficient
% rho = density of air in kg/m^3
% V = velocity in m/s
% E = Youngs Modulus in N/m^2
% b1 = front spar position non-dimensionalised
% b2 = rear spar position non-dimensionalised
% flex_ax = position of flexural axis non-dimensionalised
% cm0 = Aerofoil zero AOA pitching moment
% cg = centre of gravity for the aerofoil used

% The outputs are:
% tw1 = array of thicknesses for front spar
% tw2 = array of thicknesses for rear spar

%{
TO DO LIST:
1. Need pitching moment coefficient for NACA 64-215
2. Need the CG value for NACA 64-215
3. Need to confirm distance a in Torque calculations
4. Need the spar height (Make this an input)(a more accurate value from Thiago)
5. Need to take into account the torque due to the engine
%}

% Loading in the .mat file to get the required variables
load('WingDistributions.mat')

% Initialise
tw1 = zeros(1,length(wing.lift));
tw2 = zeros(1,length(wing.lift));

% This loop is used to find multiple variables
for i = 1:length(wing.lift)
    h = 0.12 * wing.chord(i);                                                    % Approx height of the spars
    pitchingmoment = 0.5 * rho * V^2 * wing.chord(i)^2 * cm0;                    % Pitching moment for this aerofoil
    wing.torque(i) = (wing.lift(i) * abs(flex_ax - b1) * wing.chord(i)) +...
        (n * wing.selfWeight(i) * abs(flex_ax - cg))- pitchingmoment;            % Torque distribution along the wing
    wing.sparwebarea = abs(b1 - b2) * wing.chord(i) * h;                         % Area of spar web approximately
    q1 = wing.shearForce(i) / (2 * h);                                           % q1 shear flow component
    q0 = wing.torque(i) / (2 * wing.sparwebarea);                                % q0 shear flow component
    qweb1 = q1 + q0;                                                             % Front spar shear flow
    qweb2 = q1 - q0;                                                             % Rear spar shear flow
    x1 = (qweb1 * h^2)/ (K_s * E);                                               % Value to be cube rooted for front spar
    x2 = (qweb2 * h^2)/ (K_s * E);                                               % Value to be cube rooted for rear spar
    tw1(i) = nthroot(x1,3);                                                      % Thickness for front spar
    tw2(i) = nthroot(x2,3);                                                      % Thickness for rear spar
end