function W_electrical = W_electrical(electricRating, lengthElectrical, numGenerators)
%this function calculates the weight of the electrical system in lb

INPUTS
electricRating = System electrical rating (typically 40 − 60 for transports (kVA))
lengthElectrical = Electrical routing distance, generators to avionics to cockpit (ft)
numGenerators = number of generators (typicall = numEngines)

W_electrical = 7.291 * electricRating^0.782 * lengthElectrical^0.346 * numGenerators^0.1;
end