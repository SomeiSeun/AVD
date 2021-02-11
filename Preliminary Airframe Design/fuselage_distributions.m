function fuselage = fuselage_distributions(components, Nz, numSections, W0, mainLength)

% Creating a function which finds the bending moment and shear force
% distributions along the fuselage

% The inputs are:
% components = structure containing all the weights
% Nz = load factor
% numSections = number of discretisations
% W0 = MTOW of the aircraft
% mainLength = length of the fuselage

% The outputs are:
% fuselage = structure containing shear force and bending moment distributions

% Discretise the length of the fuselage
fuselage.length = linspace(0, mainLength, numSections);


end