function [] = specific_energy_plot(W_tow, S, Clmax)

% This function can be used to plot Specific Excess Energy plots

% The INPUTS are: (ALL SI UNITS)
% W_tow is the Maximum Take off weight in Newtons
% S is the reference wing area in m^2
% Clmax is the max lift coefficient in clean configuration

% The OUTPUTS are: 
% The contour plot is the output

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = (0:100:60000);              % Height in feet
height_metres = h*0.3048;       % Height in metres
M = (0:(1/(length(h) - 1)):1);  % Mach number
vals = (0:1:length(h));
K=0.04096652332;

for i = 1 : length(h)
    alt = height_metres(i);     % Converting altitude from feet to metres to do temp/pressure calculations
    [T, a, P, rho] = atmosisa(alt);
    
    for j = 1 : length(h)
        velocity = M(j) * a;                         % Finding out the velocity
        beta_thrust_ratio_cruise = ThrustLapseModel(M(j), alt/0.3048, 0.8, 35000);
        Thrust = W_tow * ThrustToWeightTakeOff * beta_thrust_ratio_cruise; 
        CL_Cruise = (W_Cruise) / (0.5 * rho * (V_Cruise)^2 * S);
        CD_Total = CD_0_Total(2) + (K * (CL_Cruise)^2);
        D = 0.5 * rho * S * velocity^2 * CD_Total;
        Ps(i,j) = (velocity / W_tow) * (Thrust - D); % Finding out specific excess power
    end
    
    vstall(i) = sqrt((2 * W_tow / S) / (rho * Clmax)) / a;   % Stall speed to be plotted in Mach
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Plotting the Contour plot
% figure(1)
% [cl,hl] = contour(M,height_metres,Ps,vals);
% clabel(cl,hl)
% title('Specific Excess Power')
% xlabel('Mach number')
% ylabel('Altitude (feet)')
% hold on
% plot(vstall, height_metres, '-r')
% legend('Specific Excess Energy', 'Stall Boundary')

end