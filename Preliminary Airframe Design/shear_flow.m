function [frontsparweb,rearsparweb,wing] = shear_flow(wing, K_s, rho, V, E, b1, b2, flex_ax, cm0, cg)

% This function is used to find the thicknesses for the spar web

% The inputs are:
% wing = structure with all the relevant variables needed
% K_s = buckling coefficient
% rho = density of air in kg/m^3
% V = velocity in m/s
% E = Youngs Modulus in N/m^2
% b1 = front spar position non-dimensionalised
% b2 = rear spar position non-dimensionalised
% flex_ax = position of flexural axis non-dimensionalised
% cm0 = Aerofoil zero AOA pitching moment
% cg = centre of gravity for the aerofoil used
% x = array of x coordinates of the aerofoil used
% y = array of y coordinates of the aerofoil used

% The outputs are:
% frontsparweb = structure with all the required values for the front spar web
% rearsparweb = structure with all the required values for rear spar web
% wing = structure with an additional variable

%{
TO DO LIST:
1. Need the CG value for NACA 64-215
2. Need to take into account the torque due to the engine
3. Find the overall twist (Need skin thicknesses for that)
%}


% Initialising the matrices
frontsparweb.tw = zeros(1,length(wing.span));
rearsparweb.tw = zeros(1,length(wing.span));
q1 = zeros(1,length(wing.span));
q0 = zeros(1,length(wing.span));
frontsparweb.h = zeros(1,length(wing.span));
rearsparweb.h = zeros(1,length(wing.span));
pitchingmoment = zeros(1,length(wing.span));
frontsparweb.qweb = zeros(1,length(wing.span));
rearsparweb.qweb = zeros(1,length(wing.span));

% This loop is used to find multiple variables
for i = 1:length(wing.span)
    frontsparweb.h(i) = 0.12 * wing.chord(i);                                       % Approx height of front spar
    rearsparweb.h(i) = 0.07 * wing.chord(i);                                        % Approx height of rear spar
    pitchingmoment(i) = 0.5 * rho * V^2 * wing.chord(i)^2 * cm0;                    % Pitching moment for this aerofoil
    wing.torque(i) = (wing.lift(i) * (flex_ax - 0.25) * wing.chord(i)) +...
        (wing.selfWeight(i) * (cg - flex_ax)) * wing.chord(i) - pitchingmoment(i);  % Torque distribution along the wing
    wing.sparwebarea(i) = abs(b1 - b2) * wing.chord(i) * 0.5 *...
        (frontsparweb.h(i) + rearsparweb.h(i));                                     % Approx area of central wing box
    q1(i) = -wing.shearForce(i) / (2 * frontsparweb.h(i));                          % q1 shear flow component
    q0(i) = wing.torque(i) / (2 * wing.sparwebarea(i));                             % q0 shear flow component
    frontsparweb.qweb(i) = abs(q1(i) + q0(i));                                      % Front spar shear flow
    rearsparweb.qweb(i) = abs(q1(i) - q0(i));                                       % Rear spar shear flow
    x1 = (frontsparweb.qweb(i) * frontsparweb.h(i)^2)/ (K_s * E);                   % Value to be cube rooted for front spar
    x2 = (rearsparweb.qweb(i) * rearsparweb.h(i)^2)/ (K_s * E);                     % Value to be cube rooted for rear spar
    frontsparweb.tw(i) = nthroot(x1,3);                                             % Thickness for front spar
    rearsparweb.tw(i) = nthroot(x2,3);                                              % Thickness for rear spar
    frontsparweb.shearstress(i) = frontsparweb.qweb(i) / frontsparweb.tw(i);        % Front spar shear stress
    rearsparweb.shearstress(i) = rearsparweb.qweb(i) / rearsparweb.tw(i);           % Rear spar shear stress
    wing.wingboxlength(i) = abs(b1 - b2) * wing.chord(i);                           % Central wing box length
end

% Converting the thicknesses to mm
% frontsparweb.tw1 = frontsparweb.tw1 * 1000;
% rearsparweb.tw1 = rearsparweb.tw1 * 1000;
%{
% Plotting the aerofoil with the relevant points
figure
plot(x,y,'r')
grid on
axis equal
hold on
plot(b1,0,'xb')
plot(b2,0,'xg')
plot(flex_ax,0,'xm')
title('Aerofoil with relevant points of interest')
legend({'Aerofoil','Front spar','Rear spar','Flexural Axis'},'Location','Northeast')
%}
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
legend({'q1','q0'},'Location','Northeast')
title('Shear flow component spanwise distribution')

% Plotting the thickness variations
figure
plot(wing.span,frontsparweb.tw,'.r')
hold on
plot(wing.span,rearsparweb.tw,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Thickness (m)')
legend({'Front spar','Rear spar'},'Location','Northeast')
title('Thickness of spars spanwise distribution')

% Plotting the front and rear spar shear flow
figure
plot(wing.span,frontsparweb.qweb,'.r')
hold on
plot(wing.span,rearsparweb.qweb,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Shear flow (N/m)')
legend({'Front spar','Rear spar'},'Location','Northeast')
title('Front and rear spar shear flow spanwise distribution')

% Plotting front and rear spar shear stress
figure
plot(wing.span,frontsparweb.shearstress,'.r')
hold on
plot(wing.span,rearsparweb.shearstress,'.b')
grid on
xlabel('Wing span (m)')
ylabel('Shear stress (N/m^2)')
legend({'Front spar','Rear spar'},'Location','Northeast')
title('Front and rear spar shear stress spanwise distribution')
end