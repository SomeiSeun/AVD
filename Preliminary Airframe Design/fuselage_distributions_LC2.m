function LoadCase2 = fuselage_distributions_LC2(components, n, numSections, W0,...
    mainLength, wingRootLE, cRootWing, CL_trimHoriz,rho_cruise, V_Cruise, CL_trimWings, etaH, SHoriz, SWing)

% Creating a function which finds the bending moment and shear force
% distributions along the fuselage

% The inputs are:
% components = structure containing all the weights
% n = load factor
% numSections = number of discretisations
% W0 = MTOW of the aircraft
% mainLength = length of the middle section of the fuselage
%wingRootLE = position of LE of wing along fuselage
%cRootWing=root chord of wing

% The outputs are:
% fuselage = structure containing shear force and bending moment distributions


%discretize main section of fuselage (without nose and tail sections)
fusSections_x=linspace(0,mainLength, numSections);
%get weights of other components
ComponentWeights=extractfield(components,'weight');
ComponentWeights=n*ComponentWeights;
%get x_cg positions for each component
x_cg=zeros(1,25); 
for i=1:25
    x_cg(i)=components(i).cog(1); 
end

% inertial load distribution for load case 1
%distribute weights of different components as point forces acting at their x_cg
weightDistributions=zeros(length(ComponentWeights),numSections); %initialise array

%weight distributions of other components- modelled as point loads
for i=1:length(ComponentWeights)
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
weightSum(I1)=-Reactions(1);

[~,I3] = min(abs(fusSections_x -RS_pos_fus));
weightSum(I3)=-Reactions(2);

%SF
SF=zeros(1,numSections);
for i=2:numSections
    SF(i)=SF(i-1)+weightSum(i);
end
SF=-SF;
BM=zeros(1,numSections);
for i=2:numSections
    dBM(i)=SF(i-1)*(fusSections_x(i)-fusSections_x(i-1))+(SF(i)+SF(i-1))*(fusSections_x(i)-fusSections_x(i-1))/2;
    BM(i)=BM(i-1)+dBM(i);
end

% tail trim load for Load Case 1

%zero inertial load
WtDisTT=zeros(1,numSections); 
%aero load: 
%tail trim load - calculated in conceputal design. it must balance the 2.5g pitching moment of the
%wing
TT_Load=CL_trimHoriz(2)*0.5*rho_cruise*V_Cruise^2*SHoriz*etaH;

%add wing lift 
% wingLift=CL_trimWings(2)*0.5*rho_cruise*V_cruise*SWing;
%now superimpose tail load case onto weightdistributions


%calculate new reactions at spars for this tail load case
C_TT=[CL_trimHoriz(2); TT_Load*x_cg(2) ]; 
Reactions_TT=A\C_TT;

%reactions from TTL at FS and RS, acting upwards
[~,I4] = min(abs(fusSections_x -x_cg(2)));
WtDisTT(I4)=-TT_Load; WtDisTT(I1)=-Reactions_TT(1); WtDisTT(I3)=-Reactions_TT(2);

SF_TT=zeros(1,numSections);
for i=2:numSections
    SF_TT(i)=SF_TT(i-1)+WtDisTT(i);
end

SF_TT=-SF_TT;
dBM_TT=zeros(1,numSections);BM_TT=zeros(1,numSections);
for i=2:numSections
    dBM_TT(i)=SF_TT(i-1)*(fusSections_x(i)-fusSections_x(i-1))+(SF_TT(i)+SF_TT(i-1))*(fusSections_x(i)-fusSections_x(i-1))/2;
    BM_TT(i)=BM_TT(i-1)+dBM_TT(i);
end

% LOAD CASE 1: inerial load+tail trim load superimposition
%symm flight+ TT load
SF_Total_LC1=SF+SF_TT;
BM_Total_LC1=BM+BM_TT;

%save into a structure
LoadCase2.sections=fusSections_x;
LoadCase2.TotalSF1=SF_Total_LC1; %sum of inertial and tail load
LoadCase2.TotalBM1=BM_Total_LC1; %sum of inertial and tail load
LoadCase2.SFTT=SF_TT; %just tail load
LoadCase2.BMTT=BM_TT; %just tail load
LoadCase2.SF_IN=SF; %just inertial
LoadCase2.BM_IN=BM; %just inertial
LoadCase2.weightDistributionIN=weightSum;
LoadCase2.Reactions=Reactions;
end