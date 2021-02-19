function tail =  bendingTail(Nz, numSections, liftReq, components, span, cRoot, taper)
% This function calculates the bending moment and shear force distributions
% along the wing, assuming a clamped beam and symmetric flight.

% Defining width of structural components in m (rough values!)
fuseWidth = 1;

% Discretising wing into sections
cTip = cRoot*taper;
cFuse = cRoot + 2*fuseWidth/span*(cRoot*taper - cRoot);
taper = cTip/cFuse;
tail.chord = linspace(cTip, cFuse, numSections);
tail.span = linspace(span/2, fuseWidth, numSections);

% Tail Lift (assuming no tail lift)
tail.lift = zeros(1, numSections);
tail.lift = 4*(Nz*liftReq)/(pi*(span-2*fuseWidth))*sqrt(1 - (2*(tail.span - fuseWidth)/(span-2*fuseWidth)).^2);

% Tail Self-weight (assumed quadratic variation)
tail.selfWeight =  Nz*6*0.5*components(2).weight/((span-2*fuseWidth)*(taper^2 + taper + 1))*(tail.chord/cFuse).^2;

tail.engineWeight = zeros(1, numSections);
tail.Thrust = zeros(1, numSections);

% Overall Wing Loading
tail.loading = tail.lift - tail.selfWeight;

% Calculating shear force and bending moment distributions
tail.shearForce = zeros(1, numSections);
tail.bendingMoment = zeros(1, numSections);
for i = 2:numSections
    tail.shearForce(i) = tail.shearForce(i-1) + trapz(tail.span(i-1:i), tail.loading(i-1:i));
    tail.bendingMoment(i) = tail.bendingMoment(i-1) + trapz(tail.span(i-1:i), tail.shearForce(i-1:i));
end

end