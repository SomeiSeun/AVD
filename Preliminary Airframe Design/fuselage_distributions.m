function fuselage = fuselage_distributions(components, Nz, numSections, W0, mainLength)

% Creating a function which finds the bending moment and shear force
% distributions along the fuselage

% The inputs are:
% components = structure containing all the weights
% Nz = load factor
% numSections = number of discretisations
% W0 = MTOW of the aircraft
% mainLength = length of the fuselage

% The outputs are:
% fuselage = structure containing shear force and bending moment distributions



fusSections_x=linspace(0,mainLength, numSections);
%get weights of other components
ComponentWeights=extractfield(components,'weight');

%get x_cg positions for each component
x_cg=zeros(1,25); 
for i=1:25
    x_cg(i)=components(i).cog(1); 
end

%distribute weights of different components as point forces acting at their x_cg
weightDistributions=zeros(length(ComponentWeights),numSections); %initialise array

%wing weight distribution- modelled as a distributed load
wing_x1=wingRootLE(1); wing_x2=wingRootLE(1)+cRootWing;
[~,I1] = min(abs(fusSections_x -wing_x1));
[~,I2] = min(abs(fusSections_x -wing_x2 ));
weightDistributions(1,I1:I2)=ComponentWeights(1)/(fusSections_x(I1)-fusSections_x(I2));

%weight distributions of other components- modelled as point loads
for i=2:length(ComponentWeights)
[~,I2] = min(abs(fusSections_x -x_cg(i) ));
weightDistributions(i,I2)=ComponentWeights(i); %repeat for all components
end

%fuselage weight (index 4 in weights array) distribution- model as a distributed load per unit length
weightDistributions(4,1:numSections)=ComponentWeights(4)/ numSections;

%now for the aero loads
FS_pos_fus=wingRootLE(1)+0.25*cRootWing;
RS_pos_fus=wingRootLE(1)+0.70*cRootWing;

%sum inertial weights at each station 
for i=1:numSections
    weightSum(i)=sum(weightDistributions(:,i));
end

%solve a set of simultaneous equations to find reactions at FS and RS
totalF=sum(weightSum); %force eqm
%moment eqm
for i=1:numSections
    M(i)= weightSum(i)*fusSections_x(i);
end
M_0= sum(M);
A=[1 1; FS_pos_fus RS_pos_fus]; C=[totalF;M_0];
Reactions=A\C;

%now add the aero loads onto the weights array, into the FS and RS
%positions
[~,I1] = min(abs(fusSections_x -FS_pos_fus));
weightSum(I1)=Reactions(1);

[~,I2] = min(abs(fusSections_x -RS_pos_fus));
weightSum(I2)=Reactions(2);

%SF
SF=zeros(1,numSections);
for i=2:numSections
    SF(i)=SF(i-1)+weightSum(i);
end
SF=-SF;
% BM=trapz(fusSections_x,SF);

%plot inertial load distributions

BM=zeros(1,numSections);


%create structure fuselage with everything
fuselage.sections=fusSections_x;
fuselage.weightDist=weightDistributions;
% fuselage.SF=; %shear force distribution
% fuselage.BM=; %BM distribution
end