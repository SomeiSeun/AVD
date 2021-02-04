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
1. Need the CG value for NACA 64-215
2. Need to confirm distance a in Torque calculations
3. Need the spar height (Make this an input)(a more accurate value from Thiago)
4. Need to take into account the torque due to the engine
5. Find the overall twist
%}

% Loading in the .mat file to get the required variables
load('WingDistributions.mat')

% Initialising the matrices
tw1 = zeros(1,length(wing.span));
tw2 = zeros(1,length(wing.span));
q1 = zeros(1,length(wing.span));
q0 = zeros(1,length(wing.span));
h = zeros(1,length(wing.span));
pitchingmoment = zeros(1,length(wing.span));
qweb1 = zeros(1,length(wing.span));
qweb2 = zeros(1,length(wing.span));

% This loop is used to find multiple variables
for i = 1:length(wing.span)
    h(i) = 0.12 * wing.chord(i);                                              % Approx height of the spars
    pitchingmoment(i) = 0.5 * rho * V^2 * wing.chord(i)^2 * cm0;              % Pitching moment for this aerofoil
    wing.torque(i) = (wing.lift(i) * abs(flex_ax - b1) * wing.chord(i)) +...
        (n * wing.selfWeight(i) * abs(flex_ax - cg))- pitchingmoment(i);      % Torque distribution along the wing
    wing.sparwebarea(i) = abs(b1 - b2) * wing.chord(i) * h(i);                % Area of spar web approximately
    q1(i) = -wing.shearForce(i) / (2 * h(i));                                 % q1 shear flow component
    q0(i) = wing.torque(i) / (2 * wing.sparwebarea(i));                       % q0 shear flow component
    qweb1(i) = abs(q1(i) + q0(i));                                            % Front spar shear flow
    qweb2(i) = abs(q1(i) - q0(i));                                            % Rear spar shear flow
    x1 = (qweb1(i) * h(i)^2)/ (K_s * E);                                      % Value to be cube rooted for front spar
    x2 = (qweb2(i) * h(i)^2)/ (K_s * E);                                      % Value to be cube rooted for rear spar
    tw1(i) = nthroot(x1,3);                                                   % Thickness for front spar
    tw2(i) = nthroot(x2,3);                                                   % Thickness for rear spar
end

% Converting the thicknesses to mm
tw1 = tw1 * 1000;
tw2 = tw2 * 1000;

% Plotting the torque distribution
figure 
plot(wing.span,wing.torque,'.r')
grid on
xlabel('Wing span (m)')
ylabel('Torque (Nm)')
title('Torque Spanwise Distribution')

% Plotting wingbox area variation
figure
plot(wing.span,wing.sparwebarea,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Area (m^2)')
title('Wingbox area Spanwise Distribution')

% Plotting shear flow component variation
figure
plot(wing.span,q1,'.r')
hold on
plot(wing.span,q0,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Shear flow (N/m)')
legend({'q1','q0'},'Location','northeast')
title('Shear flow component spanwise distribution')

% Plotting the thickness variations
figure
plot(wing.span,tw1,'.r')
hold on
plot(wing.span,tw2,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Thickness (mm)')
legend({'Front spar','Rear spar'},'Location','northeast')
title('Thickness of spars spanwise distribution')

% Plotting the front and rear spar shear flow
figure
plot(wing.span,qweb1,'.r')
hold on
plot(wing.span,qweb2,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Shear flow (N/m)')
legend({'Front spar','Rear spar'},'Location','northeast')
title('Front and rear spar shear flow spanwise distribution')

end