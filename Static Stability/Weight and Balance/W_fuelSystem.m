function W_fuelSystem = W_fuelSystem(numTanks, volumeTankTotal, volumeSelfSealingTank, volumeIntegralTank)
% this function calculates the weight of the fuel system in lb

% INPUT
% volumeTankTotal = total volume of fuel tanks (gal)
% volumeSelfSealingTank = self sealing fuel tank volume (gal)
% volumeIntegralTank = integral fuel tank volume (gal)
% numTanks = total number of fuel tanks

W_fuelSystem = 2.405 * volumeTankTotal^0.606 * numTanks^0.5;
end