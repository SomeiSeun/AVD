function spar = sparSizing(wing, SparMaterial, spar, IxxCutoff)

n = 1e4;
numSections = length(wing.span);

% Determining target Ixx values for front and rear spars for each spar
% material TYS available
spar.Ixx = 0.5*wing.bendingMoment.*spar.h./(2*SparMaterial.TYS);
spar.Ixx(spar.Ixx < spar.Ixx(floor(IxxCutoff*numSections))) = spar.Ixx(floor(IxxCutoff*numSections));

% Initialising arrays
spar.tf = zeros(1, numSections);
spar.b = zeros(1, numSections);
spar.Area = zeros(1, numSections);

for i = 1:numSections
    % Defining range of values for flange thickness tf (m)
    tf = linspace(1e-3, 0.5*spar.h(i), n);
    b = (12*spar.Ixx(i) - spar.tw(i).*(spar.h(i) - 2*tf).^3)./(2*tf.^3 + 6*tf.*(spar.h(i) - tf).^2);
    
    % Checking which flange breadth values (m) are manufacturable
    b(b>0.5*spar.h(i)) = NaN;
    b(b<0.001) = 0.001;
    Area = 2*b.*tf + spar.tw(i).*(spar.h(i) - 2*tf);
    
    % Finding minimum combination of b and tf that meets Ixx requirement
    [~,I] = min(Area);
    
    % Preparing function output
    spar.tf(i) = tf(I);
    spar.b(i) = b(I);
    spar.Area(i) = Area(I);
end

spar.mass = -1000*SparMaterial.Density*trapz(wing.span, spar.Area);

end