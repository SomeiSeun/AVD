function LoadCase4 = fuselage_distributions_LC4(components, n4, numSections, ~, mainLength, wingRootLE, cRootWing,  SWing, LC1WtSumIn);

%discretize main section of fuselage (without nose and tail sections)
fusSections_x=linspace(0,mainLength, numSections);
%get weights of other components
ComponentWeights=extractfield(components,'weight');
ComponentWeights=n4*ComponentWeights;
%get x_cg positions for each component
x_cg=zeros(1,25); 
for i=1:25
    x_cg(i)=components(i).cog(1); 
end

weightSum4=LC1WtSumIn; %same as inertial in LC1
totalLoad=sum(weightSum4);
gear_cg=x_cg(5);
HTail_cg=x_cg(2);

gearLoad=n4*totalLoad;
%superimpose gear load into weights array at gear cg
[~,I6] = min(abs(fusSections_x -gear_cg));
weightSum4(I6)=weightSum4(I6)+gearLoad;

%calculate tail load that counteracts large gear load
TailLoad=(gearLoad*gear_cg)/(HTail_cg);

%add tail trim load onto weights array at tail xcg
[~,I7] = min(abs(fusSections_x -HTail_cg));
weightSum4(I7)=weightSum4(I7)+TailLoad;

SF4=zeros(1,numSections);
for i=2:numSections
    SF4(i)=SF4(i-1)+weightSum4(i);
end
SF4=-SF4;
dBM4=zeros(1,numSections);BM4=zeros(1,numSections);
for i=2:numSections
    dBM4(i)=SF4(i-1)*(fusSections_x(i)-fusSections_x(i-1))+(SF4(i)+SF4(i-1))*(fusSections_x(i)-fusSections_x(i-1))/2;
    BM4(i)=BM4(i-1)+dBM4(i);
end

%save in a structure
LoadCase4.SF4=SF4;
LoadCase4.BM4=BM4;
LoadCase4.Sections=fusSections_x;
end 