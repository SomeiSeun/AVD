function spar = sparSizing(wing, SparMaterial, spar, bMin)

n = 1e4;
numSections = length(wing.span);

% Determining target Ixx values for front and rear spars for each spar
% material TYS available
spar.IxxReq = 0.5*wing.bendingMoment.*spar.h./(2*SparMaterial.TYS);

% Initialising arrays
spar.tf = zeros(1, numSections);
spar.b = zeros(1, numSections);
spar.Area = zeros(1, numSections);

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
    spar.tf(i) = tf(I);
    spar.b(i) = b(I);
    spar.Area(i) = Area(I);
end

spar.Ixx = 1/6*spar.b.*spar.tf.^3 + 1/2*spar.b.*spar.tf.*(spar.h - spar.tf).^2 + 1/12*spar.tw.*(spar.h - 2*spar.tf).^3;

spar.mass = -1000*SparMaterial.Density*trapz(wing.span, spar.Area);

end