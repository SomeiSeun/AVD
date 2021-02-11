function wing =  bendingWing(Nz, fuelInTank, numSections, W0, components, spanWing, cRootWing, taperWing, Thrustline_position, isWing)
% This function calculates the bending moment and shear force distributions
% along the wing, assuming a simply supported beam and symmetric flight.

% Discretising wing into sections
wing.chord = linspace(cRootWing*taperWing, cRootWing, numSections);
wing.span = linspace(spanWing/2, 0, numSections);

% Defining width of structural components in m (rough values!)
fuseWidth = 1.5;
pylonWidth = 0.5;
ucWidth = 1;

% Wing Lift (assuming no tail lift)
wing.lift = zeros(1, numSections);
[~,I2] = min(abs(wing.span - fuseWidth));
I1 = 1;
wing.lift(I1:I2) = Nz*4*(W0 + (fuelInTank-1)*components(25).weight)/...
    (pi*(spanWing-2*fuseWidth))*sqrt(1 - (2*(wing.span(I1:I2)-fuseWidth)/(spanWing-2*fuseWidth)).^2);

% Wing Self-weight (assumed quadratic variation)
wing.selfWeight =  Nz*6*0.5*components(1).weight/(spanWing*(taperWing^2 + taperWing + 1))*(wing.chord/cRootWing).^2;

% Wing Fuel Weight (currently assuming uniform from y=1.5m to 75% span)
wing.fuelWeight = zeros(1, numSections);
[~,I1] = min(abs(wing.span - 0.75*0.5*spanWing));
[~,I2] = min(abs(wing.span - fuseWidth));
wing.fuelWeight(I1:I2) = fuelInTank*Nz*0.5*components(25).weight/(wing.span(I1) - wing.span(I2));

% Wing Engine + Nacelle Weight
wing.engineWeight = zeros(1, numSections);
[~,I1] = min(abs(wing.span - Thrustline_position(2) - 0.5*pylonWidth));
[~,I2] = min(abs(wing.span - Thrustline_position(2) + 0.5*pylonWidth));
wing.engineWeight(I1:I2) = Nz*0.5*(components(7).weight + components(8).weight)/(wing.span(I1) - wing.span(I2));

% Wing Undercarriage Weight (currently assuming u/c @ y=5m)
wing.ucWeight = zeros(1, numSections);
[~,I1] = min(abs(wing.span - 5 - 0.5*ucWidth));
[~,I2] = min(abs(wing.span - 5 + 0.5*ucWidth));
wing.ucWeight(I1:I2) = Nz*0.5*components(5).weight/(wing.span(I1) - wing.span(I2));

% Remaining Aircraft Weight (currently assuming between y=0m and y=1.5m)
wing.fuseWeight = zeros(1, numSections);
[~,I1] = min(abs(wing.span - fuseWidth));
I2 = numSections;
wing.fuseWeight(I1:I2) = Nz*0.5*(W0 - components(1).weight - components(7).weight - components(5).weight -...
    components(8).weight - components(25).weight)/(wing.span(I1) - wing.span(I2));

% Overall Wing Loading
wing.loading = wing.lift - wing.selfWeight - wing.engineWeight - wing.ucWeight...
    - wing.fuelWeight - wing.fuseWeight;

% Calculating shear force and bending moment distributions
wing.shearForce = zeros(1, numSections);
wing.bendingMoment = zeros(1, numSections);
for i = 2:numSections
    wing.shearForce(i) = wing.shearForce(i-1) + trapz(wing.span(i-1:i), wing.loading(i-1:i));
    wing.bendingMoment(i) = wing.bendingMoment(i-1) + trapz(wing.span(i-1:i), wing.shearForce(i-1:i));
end

end