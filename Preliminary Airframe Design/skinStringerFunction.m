function [c_alongSpan,N_alongSpan,t2_alongSpan,sigma] = skinStringerFunction(numSections, wing.chord,wing.bendingMoment,YM)
    

%load material data
load('WingDistributions.mat')
load('Materials.mat')

%extract structure of materials
YM_of_Materials=extractfield(UpperSkinMaterial,'YM');

%initialise FS and RS location
FS_pos=0.25;
RS_pos=0.75;

%skin-stringer panel calculations
b2=12*wing.chord; %thickness of the aerofoil used as height of wing box

%length of wing box at each station 
c_alongSpan=(RS_pos-FS_pos)*wing.chord; %length of wing box
N_alongSpan=wing.bendingMoment./(c_alongSpan.*b2); %bending moment per unit length at each station
t2_alongSpan= ((((N_alongSpan.*(c_alongSpan.^2))./(3.62*YM_of_Materials(1))).^(1/3)))*1000;

%enforce a minimum thickness of 1mm
for i=1:numSections
    if t2_alongSpan(i)<1.0
        t2_alongSpan(i)=1.0;
    end
end

sigma=N_alongSpan/t2_alongSpan/1000;