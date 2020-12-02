function beta_thrust_ratio = ThrustLapseModel(M_flight, A_flight, M_design, A_design)

%% High BPR Turbofan thrust lapse calculator
%{
This function takes in flight Mach number and altitude and outputs the
maximum thrust output available as a percentage of thrust at sea level.

Altitude required in ft.
%}

%% Step 1: Calculate design throttle ratio TR
%{
This requires selecting the flight Mach number and altitude at which we
wish our engine to perform the best. In our case, that would be cruise
altitude and speed (35000ft and Mach 0.8)
%}

[T_design, ~, ~, ~] = atmosisa(A_design*0.3048);
[T_sealvl, ~, P_sealvl, ~] = atmosisa(0);

TR = (T_design*(1 + ((1.4-1)/2)*M_design*M_design) )/T_sealvl;

%% Step 2: Calculate temperature and pressure ratio in flight
[T_flight, ~, P_flight, ~] = atmosisa(A_flight.*0.3048);
TempRatio = (T_flight.*(1 + ((1.4-1)/2).*M_flight.*M_flight) )./T_sealvl;
PressureRatio = (P_flight .* ((1 + ((1.4-1)/2).*M_flight.*M_flight).^(3.5)) )./P_sealvl;

%% Step 3: Calculate beta

if TempRatio <= TR
    beta_thrust_ratio = PressureRatio .* (1 - 0.49.*sqrt(M_flight) );
elseif TempRatio > TR
    beta_thrust_ratio = PressureRatio .* (1 - 0.49.*sqrt(M_flight) - ((3.*(TempRatio-TR))./(1.5+M_flight)) );
end


end
