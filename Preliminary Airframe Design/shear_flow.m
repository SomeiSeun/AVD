function [wing,frontsparweb,rearsparweb] = shear_flow(wing, frontsparweb, rearsparweb,...
    K_s, rho, V, E, flex_ax, cm0, cg, Thrustline_position)

% This function is used to find the thicknesses for the spar web

% The inputs are:
% wing = structure containing all the relevant variables
% frontsparweb = structure containing the data for front spar web
% rearsparweb = structure containing the data for rear spar web
% K_s = buckling coefficient
% rho = density of air in kg/m^3
% V = velocity in m/s
% E = Youngs Modulus in N/m^2
% b1 = front spar position non-dimensionalised
% b2 = rear spar position non-dimensionalised
% flex_ax = position of flexural axis non-dimensionalised
% cm0 = Aerofoil zero AOA pitching moment
% cg = centre of gravity for the aerofoil used
% Thrustline_position = y distance between leading edge and thrust

% The outputs are:
% frontsparweb = structure with all the required values for the front spar web
% rearsparweb = structure with all the required values for rear spar web

% Initialising the matrices
frontsparweb.tw = zeros(1,length(wing.span));
rearsparweb.tw = zeros(1,length(wing.span));
q1 = zeros(1,length(wing.span));
q0 = zeros(1,length(wing.span));
pitchingmoment = zeros(1,length(wing.span));
frontsparweb.qweb = zeros(1,length(wing.span));
rearsparweb.qweb = zeros(1,length(wing.span));

% This loop is used to find multiple variables
for i = 1:length(wing.span)
    pitchingmoment(i) = 0.5 * rho * V^2 * wing.chord(i)^2 * cm0;                    % Pitching moment for this aerofoil
    wing.torque(i) = (wing.lift(i) * (flex_ax - frontsparweb.coords(1,1)) * wing.chord(i)) +...
        (wing.selfWeight(i) * (cg - flex_ax)) * wing.chord(i) +...
        pitchingmoment(i) - (wing.engineWeight(i) * ((0.5 * wing.chord(i)) + 3))...
        + (wing.Thrust(i) * abs(Thrustline_position));                              % Torque distribution along the wing
    q1(i) = -wing.shearForce(i) / (2 * frontsparweb.h(i));                          % q1 shear flow component
    q0(i) = wing.torque(i) / (2 * wing.boxArea(i));                                 % q0 shear flow component
    frontsparweb.qweb(i) = abs(q1(i) + q0(i));                                      % Front spar shear flow
    rearsparweb.qweb(i) = abs(q1(i) - q0(i));                                       % Rear spar shear flow
    x1 = (frontsparweb.qweb(i) * frontsparweb.h(i)^2)/ (K_s * E);                   % Value to be cube rooted for front spar
    x2 = (rearsparweb.qweb(i) * rearsparweb.h(i)^2)/ (K_s * E);                     % Value to be cube rooted for rear spar
    frontsparweb.tw(i) = nthroot(x1,3);                                             % Thickness for front spar
    rearsparweb.tw(i) = nthroot(x2,3);                                              % Thickness for rear spar
    
    if frontsparweb.tw(i) < 0.001
        frontsparweb.tw(i) = 0.001;               % Minimum thickness condition for the front spar web
    end
    
    if rearsparweb.tw(i) < 0.001
        rearsparweb.tw(i) = 0.001;                % Minimum thickness condition for the rear spar web
    end
    
    frontsparweb.shearstress(i) = frontsparweb.qweb(i) / frontsparweb.tw(i);        % Front spar shear stress
    rearsparweb.shearstress(i) = rearsparweb.qweb(i) / rearsparweb.tw(i);           % Rear spar shear stress
    
end

% Plotting the torque distribution
% figure 
% plot(wing.span,wing.torque,'.r')
% grid on
% xlabel('Wing span (m)')
% ylabel('Torque (Nm)')
% title('Torque Spanwise Distribution')
% 
% Plotting wingbox area variation
% figure
% plot(wing.span,wing.sparwebarea,'.b')
% grid on
% xlabel('Wing span (m)')
% ylabel('Area (m^2)')
% title('Wingbox area Spanwise Distribution')
% 
% Plotting shear flow component variation
% figure
% plot(wing.span,q1,'.r')
% hold on
% plot(wing.span,q0,'.b')
% grid on
% xlabel('Wing span (m)')
% ylabel('Shear flow (N/m)')
% legend({'q1','q0'},'Location','Northeast')
% title('Shear flow component spanwise distribution')
% 
% Plotting the thickness variations
% figure
% plot(wing.span,1000*frontsparweb.tw,'.r')
% hold on
% plot(wing.span,1000*rearsparweb.tw,'.b')
% grid on
% xlabel('Wing span (m)')
% ylabel('Thickness (mm)')
% legend({'Front spar','Rear spar'},'Location','Northeast')
% title('Thickness of spars spanwise distribution')
% 
% Plotting the front and rear spar shear flow
% figure
% plot(wing.span,frontsparweb.qweb,'.r')
% hold on
% plot(wing.span,rearsparweb.qweb,'.b')
% grid on
% xlabel('Wing span (m)')
% ylabel('Shear flow (N/m)')
% legend({'Front spar','Rear spar'},'Location','Northeast')
% title('Front and rear spar shear flow spanwise distribution')
% 
% Plotting front and rear spar shear stress
% figure
% plot(wing.span,frontsparweb.shearstress,'.r')
% hold on
% plot(wing.span,rearsparweb.shearstress,'.b')
% grid on
% xlabel('Wing span (m)')
% ylabel('Shear stress (N/m^2)')
% legend({'Front spar','Rear spar'},'Location','Northeast')
% title('Front and rear spar shear stress spanwise distribution')
end