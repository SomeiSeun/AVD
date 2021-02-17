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

%discretize main section of fuselage (without nose and tail sections)
fusSections_x=linspace(0,mainLength, numSections);
%model fus weight as a load per unit length
weights=extractfield(components,'weight');
% FusWeightDistribution(1, 1: numSections ) = weights(4)/ numSections ;

%get x_cg positions for each component
x_cg=zeros(1,25);
for i=1:25
    x_cg(i)=components(i).cog(1);
end
% weightDistributions=zeros(length(weights)+1,numSections);

%distribute weights of different components as point forces acting at their x_cg

%wing weight distribution- modelled as a distributed load
wing_x1=wingRootLE(1); wing_x2=wingRootLE(1)+cRootWing;
[~,I1] = min(abs(fusSections_x -wing_x1));
[~,I2] = min(abs(fusSections_x -wing_x2 ));
weightDistributions(2,I1:I2)=weights(1)/(fusSections_x(I1)-fusSections_x(I2));

%weight distributions of other components- modelled as point loads
for i=3:length(weights)
I1=1;
% [~,I1] = min(abs(fusSections_x -x_cg(i)));
[~,I2] = min(abs(fusSections_x -x_cg(i) ));
weightDistributions(i,I2)=weights(i); %repeat for all components
end 

%shear force
% SF=zeros(1,length(fusSections_x);

%BM


%create structure fuselage with everything
fuselage.sections=fusSections_x;
fuselage.weightDist=weightDistributions;
% fuselage.SF=; %shear force distribution
% fuselage.BM=; %BM distribution
end