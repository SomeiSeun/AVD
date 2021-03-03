function spar = sparSizing(wing, SparMaterial, spar, bMin, ribPositions)

n = 1e4;
numSections = length(wing.span);

% Determining target Ixx values for front and rear spars for each spar
% material TYS available
spar.IxxReq = 0.5*wing.bendingMoment.*spar.h./(2*SparMaterial.TYS);

% Initialising arrays
spar.tfReq = zeros(1, numSections);
spar.bReq = zeros(1, numSections);
spar.AreaReq = zeros(1, numSections);

for i = 1:numSections
    % Defining range of values for flange thickness tf (m)
    tf = linspace(1e-3, 0.1*spar.h(i), n);
    b = (12*spar.IxxReq(i) - spar.tw(i).*(spar.h(i) - 2*tf).^3)./(2*tf.^3 + 6*tf.*(spar.h(i) - tf).^2);
    
    % Checking which flange breadth values (m) are manufacturable
    b(b>0.5*spar.h(i)) = NaN;
    b(b<bMin) = bMin;
    Area = 2*b.*tf + spar.tw(i).*(spar.h(i) - 2*tf);
    
    % Finding minimum combination of b and tf that meets Ixx requirement
    [~,I] = min(Area);
    
    % Preparing function output
    spar.tfReq(i) = tf(I);
    spar.bReq(i) = b(I);
    spar.AreaReq(i) = Area(I);
end

spar.tf = zeros(1, numSections);
spar.b = zeros(1, numSections);
spar.Area = zeros(1, numSections);

ribPositions = [0, ribPositions];

for i = 2:length(ribPositions)
    section = wing.span <= ribPositions(i) & wing.span >= ribPositions(i-1);
    spar.tf(section) = max(spar.tfReq(section));
    spar.b(section) = max(spar.bReq(section));
end

spar.b(spar.b == 0) = bMin;
spar.tf(spar.tf == 0) = 1e-3;

spar.Area =  2*spar.b.*spar.tf + spar.tw.*(spar.h - 2*spar.tf);
spar.Ixx = 1/6*spar.b.*spar.tf.^3 + 1/2*spar.b.*spar.tf.*(spar.h - spar.tf).^2 + 1/12*spar.tw.*(spar.h - 2*spar.tf).^3;

spar.mass = -1000*SparMaterial.Density*trapz(wing.span, spar.Area);

end