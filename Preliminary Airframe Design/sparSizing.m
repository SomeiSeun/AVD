function [spar] = sparSizing(wing, SparMaterial, spar)

n = 1e4;
numSections = length(wing.span);

% Determining target Ixx values for front and rear spars for each spar
% material TYS available
spar.Ixx = 0.5*wing.bendingMoment.*spar.h./(2*SparMaterial.TYS);
spar.IxxMax = 1/12*0.5*spar.h.*spar.h.^3;

spar.curvature = zeros(1,numSections);
spar.displacement = zeros(1,numSections);
for i = 2:numSections
    spar.curvature(i) = spar.curvature(i-1) + trapz(wing.span(i-1:i), 2*SparMaterial.TYS./(SparMaterial.YM*spar.h(i-1:i)));
    spar.displacement(i) = spar.displacement(i-1) + trapz(wing.span(i-1:i), spar.curvature(i-1:i));
end
spar.curvature = spar.curvature - spar.curvature(end);
spar.displacement = spar.displacement(end) - spar.displacement;

spar.tf = zeros(1, numSections);
spar.b = zeros(1, numSections);
spar.Area = zeros(1, numSections);
% Initialising arrays
for i = 1:numSections
    clc
    disp(['Progress: ' num2str(i) '/' num2str(numSections)])

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