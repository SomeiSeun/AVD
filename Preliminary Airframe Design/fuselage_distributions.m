function fuselage = fuselage_distributions(components, n, numSections, W0, mainLength, wingRootLE, cRootWing, CL_trimHoriz, rho_cruise, V_cruise, CL_trimWings, etaH, SHoriz, SWing)

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

%% inertial load distribution for load case 1
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

%% tail trim load superimposition for load case 1
%zero inertial load
WtDisTT=zeros(1,numSections); 
%aero load: 
%tail trim load - calculated in conceputal design. it must balance the 2.5g pitching moment of the
%wing
TT_Load=CL_trimHoriz(2)*0.5*rho_cruise*V_cruise*SHoriz*etaH

%add wing lift 
wingLift=CL_trimWings(2)*0.5*rho_cruise*V_cruise*SWing;
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

%% LOAD CASE 1: inerial load+tail trim load superimposition
%symm flight+ TT load
SF_Total_LC1=SF+SF_TT;
BM_Total_LC1=BM+BM_TT;

% % plot shear force distribution - must be 0 at the end
% figure(1)
% plot(fusSections_x, SF) %just symm flight
% xlabel('Distance along fuselage length (m)')
% ylabel('Shear Force (N)')
% title('Shear Force Distribution')
% hold on
% plot(fusSections_x, SF_TT) %just tail load
% plot(fusSections_x, SF_Total_LC1) %symm+tail load
% 
% %plot BM distribution
% figure(2)
% plot(fusSections_x, BM)
% xlabel('Distance along fuselage length (m)')
% ylabel('Bending Moment (Nm)')
% title('Bending Moment Distribution')
% hold on
% plot(fusSections_x, BM_TT)
% plot(fusSections_x, BM_Total_LC1)


%% load case 3: nose up landing - repeat BM and SF distributions- NOT DONE 
% gear_cg=x_cg(5);
% weightDistributions3=weightDistributions; %inertial load distribution is the same
% 
% %WHAT NEEDS TO BE DONE- FIND GEAR LOAD AND TAIL LOAD DISTRIBUTION IN THE
% %WEIGHTS ARRAY
% 
% %calculate gear load reactions
% C3=[ ; ];
% Reactions3=A\C3; %reactions are now at gear and tail (NOT FS AND RS!!!!)
% 
% [~,I5] = min(abs(fusSections_x -x_cg(5)));
% % weightSum3(I4)=-Reactions3(??); %TAIL LOAD
% % weightSum3(I5)=-Reactions3(??); %GEAR LOAD
% 
% SF3=zeros(1,numSections);
% for i=2:numSections
%     SF3(i)=SF3(i-1)+weightSum3(i);
% end
% SF3=-SF3;
% dBM3=zeros(1,numSections);BM3=zeros(1,numSections);
% for i=2:numSections
%     dBM3(i)=SF3(i-1)*(fusSections_x(i)-fusSections_x(i-1))+(SF3(i)+SF3(i-1))*(fusSections_x(i)-fusSections_x(i-1))/2;
%     BM3(i)=BM3(i-1)+dBM3(i);
% end
% 
% %plot
% figure(1)
% % plot(fusSections_x, SF3)
% legend('Load case 1','with TT', 'Load case 3')
% figure(2)
% % plot(fusSections_x, BM3)
% legend('Load case 1','just tail load''symm+ TT', 'Load case 3')
% %load case 3
% % n3=?
% % LoadCase3 = fuselage_distributions(components, n3, numSections, W0, mainLength, wingRootLE, cRootWing)

%% output distributions
%create structure fuselage with everything
fuselage.sections=fusSections_x;
fuselage.weightDist=weightDistributions;
fuselage.TotalSF1=SF_Total_LC1; %shear force distribution LC 1
fuselage.TotalBM1=BM_Total_LC1; %BM distribution LC 1
fuselage.TTSF=SF_TT;
fuselage.TTBM=BM_TT;
fuselage.InSF=SF;
fuselage.InBM=SF;
end