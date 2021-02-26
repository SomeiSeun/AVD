function [wing, frontSpar, rearSpar] = analyseWingBox(file, wing, tcRatio)

% Loading NACA aerofoil coorinates
fID = fopen(file, 'r');
NACA.coords = fscanf(fID, '%f %f', [2 Inf]);
numPoints = length(NACA.coords);

NACA.upper = NACA.coords(:,1:numPoints/2);
NACA.lower = NACA.coords(:,numPoints/2+1:end);

% Interpolating upper and lower surfaces to common x-values.
x = linspace(0,1,100);
upper = zeros(1, length(x));
lower = zeros(1, length(x));
j = 2;
k = 2;
for i = 1:length(x)
    while NACA.upper(1,j) < x(i)
        j = j+1;
    end
    m = (NACA.upper(2,j) - NACA.upper(2,j-1))/(NACA.upper(1,j) - NACA.upper(1,j-1));
    upper(i) = m*(x(i) - NACA.upper(1,j)) + NACA.upper(2,j);
    
    while NACA.lower(1,k) < x(i)
        k = k+1;
    end
    m = (NACA.lower(2,k) - NACA.lower(2,k-1))/(NACA.lower(1,k) - NACA.lower(1,k-1));
    lower(i) = m*(x(i) - NACA.lower(1,k)) + NACA.lower(2,k); 
end

%determining the chordwise thickness distribution
tc = upper - lower;

% Interpolating spar locations on upper surface
i = 1;
while tc(i) < tcRatio
    i = i + 1;
end
m = (tc(i) - tc(i-1))/(x(i) - x(i-1));
upperFront(1,1) = x(i-1) + (tcRatio - tc(i-1))/m;
m = (upper(i) - upper(i-1))/(x(i) - x(i-1));
upperFront(2,1) = upper(i-1) + m*(upperFront(1,1) - x(i-1));

while tc(i) > tcRatio
    i = i + 1;
end
m = (tc(i) - tc(i-1))/(x(i) - x(i-1));
upperRear(1,1) = x(i-1) + (tcRatio - tc(i-1))/m;
m = (upper(i) - upper(i-1))/(x(i) - x(i-1));
upperRear(2,1) = upper(i-1) + m*(upperRear(1,1) - x(i-1));


% Interpolating spar locations on lower surface
i = 1;
while tc(i) < tcRatio
    i = i + 1;
end
m = (tc(i) - tc(i-1))/(x(i) - x(i-1));
lowerFront(1,1) = x(i-1) + (tcRatio - tc(i-1))/m;
m = (lower(i) - lower(i-1))/(x(i) - x(i-1));
lowerFront(2,1) = lower(i-1) + m*(lowerFront(1,1) - x(i-1));

while tc(i) > tcRatio
    i = i + 1;
end
m = (tc(i) - tc(i-1))/(x(i) - x(i-1));
lowerRear(1,1) = x(i-1) + (tcRatio - tc(i-1))/m;
m = (lower(i) - lower(i-1))/(x(i) - x(i-1));
lowerRear(2,1) = lower(i-1) + m*(lowerRear(1,1) - x(i-1));

% Assembling overall wingbox coordinates
boxUpper = [upperFront, [x(:, tc > tcRatio); upper(:, tc > tcRatio)], upperRear];
boxLower = [lowerFront, [x(:, tc > tcRatio); lower(:, tc > tcRatio)], lowerRear];

% Evaluating wingbox area for unit chord aerofoil
wingBoxArea = trapz(boxUpper(1,:), boxUpper(2,:)) - trapz(boxLower(1,:), boxLower(2,:));

% Scaling wingbox area and length along the span
wing.boxArea = wingBoxArea*wing.chord.^2;
wing.boxLength = (upperRear(1,1) - upperFront(1,1))*wing.chord;
frontSpar.h = tcRatio*wing.chord;
rearSpar.h = tcRatio*wing.chord;
frontSpar.coords = [upperFront, lowerFront];
rearSpar.coords = [upperRear, lowerRear];
end