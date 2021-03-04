%% Determining the Rib Thickness at each station (assuming that Ribs will be positioned perpendicular to the leading edge)

function[optRibParameters]=RibThickness(optRibSpacing,wing,minMassIndex,ribThickness)
% Initialize 
i=1;
j=1;
ribPosition(1)=0.52; 
% Find out how many ribs the optimum spacing allows for:
while i==1 
    condition=0.52*(j+1); 
    if condition <=wing.span(1)
      ribPosition(j+1)=0.52*(j+1);
      j=j+1;
    else 
        break;
    end
end 
numberOfRibs=length(ribPosition);  

%Determine Rib Thickness at stations

for i=1:length(ribPosition)
position=abs(wing.span-ribPosition(i));
locate=find(position==min(position));
OptimumRibThickness(i)=ribThickness(minMassIndex,locate);
end 

optRibParameters.ribSpacing=0.52;
optRibParameters.ribThickness=OptimumRibThickness; 
optRibParameters.numberOfRibs=numberOfRibs;
optRibParameters.ribPositions=ribPosition;
end 