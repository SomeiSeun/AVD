function [spar, Ixx, Area] = sparSizing(wing, SparMaterial, spar)

n = 200;
numSections = length(wing.span);

% Determining target Ixx values for front and rear spars for each spar
% material TYS available
spar.Ixx = wing.bendingMoment.*spar.h./(2*SparMaterial.TYS);

% Defining range of values for flange thickness tf and flange breadth b (m)
tf = linspace(0.001, 0.1, n)';
b = linspace(0.001, 0.5, n);

% Initialising arrays
Ixx = zeros(n, n, numSections);
Area = zeros(n, n, numSections);
for i = 1:numSections
    Ixx(:,:,i) = 1/6*b.*tf.^3 + 1/2*b.*tf.*(spar.h(i) - tf).^2 + 1/12*spar.tw(i).*(spar.h(i) - 2*tf).^3;
    Area(:,:,i) = 2*b.*tf + spar.tw(i).*(spar.h(i) - 2*tf);  
    
    % Checking if calculated Ixx values meet minimum required Ixx
    for j = 1:n
        for k = 1:n
            if Ixx(j,k,i) < spar.Ixx(i)
                Ixx(j,k,i) = NaN;
                Area(j,k,i) = NaN;
            end
        end
    end
    
    [~,I] = min(Area(:,:,i),[],[1 2], 'linear', 'omitnan');
    [I1(i), I2(i)] = ind2sub(size(Area(:,:,i)), I);
    
    spar.tf(i) = tf(I1(i));
    spar.b(i) = b(I2(i));
end


end