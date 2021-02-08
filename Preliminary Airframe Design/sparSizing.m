function [spar] = sparSizing(wing, SparMaterial, spar)

n = 500;
numSections = length(wing.span);

% Determining target Ixx values for front and rear spars for each spar
% material TYS available
spar.Ixx = wing.bendingMoment.*spar.h./(2*SparMaterial.TYS);

spar.curvature = zeros(1,numSections);
spar.displacement = zeros(1,numSections);
for i = 2:numSections
    spar.curvature(i) = spar.curvature(i-1) + trapz(wing.span(i-1:i), 2*SparMaterial.TYS./(SparMaterial.YM*spar.h(i-1:i)));
    spar.displacement(i) = spar.displacement(i-1) + trapz(wing.span(i-1:i), spar.curvature(i-1:i));
end
spar.curvature = spar.curvature - spar.curvature(end);
spar.displacement = spar.displacement(end) - spar.displacement;

% Defining range of values for flange thickness tf and flange breadth b (m)
tf = linspace(1e-3, 0.5, n)';
b = linspace(1e-3, 0.5, n);

spar.tf = zeros(1, numSections);
spar.b = zeros(1, numSections);
spar.Area = zeros(1, numSections);
% Initialising arrays
for i = 1:numSections
    clc
    disp(['Progress: ' num2str(i) '/' num2str(numSections)])

    Ixx = 1/6*b.*tf.^3 + 1/2*b.*tf.*(spar.h(i) - tf).^2 + 1/12*spar.tw(i).*(spar.h(i) - 2*tf).^3;
    Area = 2*b.*tf + spar.tw(i).*(spar.h(i) - 2*tf);  
    
    % Checking if calculated Ixx values meet minimum required Ixx
    Ixx(Ixx < spar.Ixx(i)) = NaN;
    Area(isnan(Ixx)) = NaN;
    
    % Finding minimum combination of b and tf that meets Ixx requirement
    [~,I] = min(Area,[],[1 2], 'linear');
    [I1, I2] = ind2sub(size(Area), I);
    
    % Preparing function output
    spar.tf(i) = tf(I1);
    spar.b(i) = b(I2);
    spar.Area(i) = Area(I1,I2);
end

spar.mass = -1000*SparMaterial.Density*trapz(wing.span, spar.Area);

end