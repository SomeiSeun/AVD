%% Determining the Rib Thickness at each station 
% Assume Ribs are perpendicular to the Leading Edge (Most Efficient
% Configuration) 
optimumSpacing=0.5;
i=1;
j=1;
spanwise(1)=optimumSpacing; 
% Find out how many ribs the optimum spacing allows for:
while i==1 
    condition=optimumSpacing*(i+1); 
    if condition <=semispan % check is b is semispan...
      spanwise(i+1)=optimumSpacing*(i+1)
      i=i+1;
    else 
        break;
    end
end 

numberOfRibs=length(spanwise); 
% Determine Rib Thickness at stations

for i=1:length(numberofRibs)
position=abs(y-spanwise(i))
finalRibThickness=ribThickness(minindex,position)
end 

end 
