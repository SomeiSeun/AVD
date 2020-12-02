%% Engine and nacelle sizing script version 2
%{
This script should hopefully finally solve all issues with engine and
provide a function which can be used to calculate the engine performance,
size, location based on the inputs it takes.
%}

%% Housekeeping
clear
clc
close all

%% How much thrust is required
%{
As per initial sizing (and its assumptions), there is a minimum requirement
for the thrust to weight ratio at sea level, which when combined with the
MTOW gives us the installed thrust required to be bare bones mission capable.

However, initial sizing does not take into account the various sources of
losses that occur in the engine due to installation effects. There are two
major sources of losses:

Systems losses
    Pressurisation losses
    Pneumatic losses
    Hydraulic losses
    Electrical losses
    Cowl Thermal Anti Icing losses
    Wing leading edge thermal losses
    etc.
Values for systems losses are probably just to be estimated at this stage
as a percent increase required for thrust.

Engine losses
    Nacelle intake losses
    Spillage drag
    Boundary layer removal losses
Such losses are to be calculated as part of the engine itself because these
very directly impact the engine thrust and are inseperable from the engine
itself.
%}

load('../Initial Sizing/InitialSizing.mat', 'ThrustToWeight', 'W0', 'C_Cruise', 'C_Divert', 'C_Loiter', 'V_Cruise')
InstalledThrustTotalReq = ThrustToWeight * W0;
SystemsLossFactor = 1.08;
NacelleLossFactor = 1.02;
UninstalledThrustTotalReq = InstalledThrustTotalReq * SystemsLossFactor * NacelleLossFactor;
UninstalledThrustPerEngineReq = UninstalledThrustTotalReq/2;

%% Thrust lapse model
Mach_numbers = 0:0.1:1;
Altitudes = 0:1000:42000;
beta = zeros(length(Mach_numbers), length(Altitudes));
for i = 1:length(Mach_numbers)
    for ii = 1:length(Altitudes)
        beta(i,ii) = ThrustLapseModel(Mach_numbers(i), Altitudes(ii));
    end
end

for i = 1:length(Mach_numbers)
    plot(Altitudes, beta(i,:), 'k', 'LineWidth', sqrt(i))
    hold on
end









