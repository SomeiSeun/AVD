function [wing, frontSpar, rearSpar] = analyseWingBox(file, wing, frontSparLocation, rearSparLocation)

% Loading NACA aerofoil coorinates
fID = fopen(file, 'r');
NACA.coords = fscanf(fID, '%f %f', [2 Inf]);

NACA.upper = NACA.coords(:,1:26);
NACA.lower = NACA.coords(:,27:end);

% Interpolating spar locations on upper surface
i = 1;
while NACA.upper(1,i) < frontSparLocation
    i = i + 1;
end
upperFront(1,1) = frontSparLocation;
upperFront(2,1) = NACA.upper(2,i-1) + (frontSparLocation - NACA.upper(1,i-1))*(NACA.upper(2,i) - NACA.upper(2,i-1))/(NACA.upper(1,i) - NACA.upper(1,i-1));

while NACA.upper(1,i) < rearSparLocation
    i = i + 1;
end
upperRear(1,1) = rearSparLocation;
upperRear(2,1) = NACA.upper(2,i-1) + (rearSparLocation - NACA.upper(1,i-1))*(NACA.upper(2,i) - NACA.upper(2,i-1))/(NACA.upper(1,i) - NACA.upper(1,i-1));


% Interpolating spar locations on lower surface
i = 1;
while NACA.lower(1,i) < frontSparLocation
    i = i + 1;
end
lowerFront(1,1) = frontSparLocation;
lowerFront(2,1) = NACA.lower(2,i-1) + (frontSparLocation - NACA.lower(1,i-1))*(NACA.lower(2,i) - NACA.lower(2,i-1))/(NACA.lower(1,i) - NACA.lower(1,i-1));

while NACA.lower(1,i) < rearSparLocation
    i = i + 1;
end
lowerRear(1,1) = rearSparLocation;
lowerRear(2,1) = NACA.lower(2,i-1) + (rearSparLocation - NACA.lower(1,i-1))*(NACA.lower(2,i) - NACA.lower(2,i-1))/(NACA.lower(1,i) - NACA.lower(1,i-1));

% Assembling overall wingbox coordinates
boxUpper = [upperFront, NACA.upper(:,NACA.upper(1,:) > frontSparLocation & NACA.upper(1,:) < rearSparLocation), upperRear];
boxLower = [lowerFront, NACA.lower(:,NACA.lower(1,:) > frontSparLocation & NACA.lower(1,:) < rearSparLocation), lowerRear];

% Evaluating wingbox area for unit chord aerofoil
wingBoxArea = trapz(boxUpper(1,:), boxUpper(2,:)) - trapz(boxLower(1,:), boxLower(2,:));

% Scaling wingbox area and length along the span
wing.boxArea = wingBoxArea*wing.chord.^2;
wing.boxLength = (rearSparLocation - frontSparLocation)*wing.chord;
frontSpar.h = (upperFront(2,1) - lowerFront(2,1))*wing.chord;
rearSpar.h = (upperRear(2,1) - lowerRear(2,1))*wing.chord;
end