% Creating a programme to do the shear flow calculations

clear
clc

% Loading in the .mat files to get the required variables
load('ConceptualDesign.mat')
load('WingDistributions.mat')

% First calculating the Torque at each discretised cross section
% T = L*a + nW*b - M0
% The worst case is when there is no fuel in the tanks and safety factor of
% 1.5 is applied.
for i = 1:length(wing.lift)
    wing.pitchingmoment(i) = 0.5 * rho_cruise * v^2 * wing.chord(i)^2 * wing.pitchingmomentcoeff(i);
    wing.torque(i) = (wing.lift(i) * 0.25 * wing.chord(i)) + (wing.selfWeight(i) * b) - wing.pitchingmoment(i);  
end