function [] = specific_energy_plot(W_tow, S, Clmax, Cd, Thrust_sl)

% This function can be used to plot Specific Excess Energy plots
% The INPUTS are:
% W_tow is the Maximum Take off weight in Newtons
% S is the reference wing area in m^2
% Clmax is the max lift coefficient in clean configuration
% Cd is the drag coefficient FOR WHICH AN EQUATION IS REQUIRED
% Thrust_sl is the sea level max thrust in Newtons

% The OUTPUTS are:
% The contour plot is the output



g = 9.81;                   % Gravitational Acceleration in m/s
T0 = 288;                   % Sea level temperature in Kelvin
R = 287;                    % Gas Constant
rho0 = 1.225;               % Sea level density in kg/m^3
P0 = 101325;                % Sea level pressure in Pa
gamma = 1.4;                % Heat Capacity ratio

h = (0:500:42000);          % Range of height
M = (0:(41/4200):0.82);     % Range for Mach number
vals = (0:1:50);            % Not sure why this goes up to 50

for i = 1:85
    alt = h(i)*0.3048;        % Converting altitude from feet to metres to do temp/pressure calculations
    if alt <= 10000
        temp = T0 - (alt*0.0065); % Finding out the temperature variation in the Troposphere
    else
        temp = 223;           % Setting the temperature at 223 Kelvin in the Stratosphere
    end
    press = P0 * (temp / T0)^(gamma / (gamma - 1));   % Finding out the pressure at that height CHECK THIS EQU
    rho = press/(R*temp);     % Finding out the density at the height
    Thrust = ; %??????????? NEED THRUST VARIATION WITH ALTITUDE EQUATION HERE
    a = sqrt(gamma*R*temp); % Speed of sound at that height
    for j = 1:85
        velocity = M(j) * sqrt(gamma*R*temp);
        Cl = W_tow/(0.5*S*rho*velocity^2);
        beta = sqrt(1 - M(j)^2);   % Compressibility correction
        Cd = ;  % NEED AN EQAUTION FOR THIS
        D = ;  % NEED AN EQUATION FOR THIS
        Ps(i,j) = (velocity / W_tow) * (Thrust - D);  % Finding out specific excess power
        he(i,j) = alt + velocity^2/(2*g);   % WHAT IS THIS???
    end
    vstall(i) = sqrt((2 * W_tow / S) / (rho * Clmax));   % Stall speed to be plotted
end
end

% Plotting the Contour plot
figure(1); 
[cl,hl] = contour(M,h,Ps,vals)
clabel(cl,hl);
title('Specific Excess Power');
xlabel('Mach number');
ylabel('Altitude (m)');
hold on
plot(vstall, h, '-r')
legend('Ps', 'stall boundary')