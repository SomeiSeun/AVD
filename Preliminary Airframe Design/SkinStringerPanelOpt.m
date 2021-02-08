%% Optimisation of Skin Stringer Panels: values look a bit too good to be correct
clear
clc
close all 

%% TO DO still: 
% Enforce Boundary Conditions
% Comparison for Weight Reduction
% Compare FARRAR Ratio


%% Load Data
load('WingDistributions.mat')
load('Materials.mat')
load('skinStringerpanel.mat')


%% Calculate Effective Area for a range of As_bt and ts_t values

noStringersMax=100;                                                         % Note these values are not realistic and have simply been chosen to test the code
noPanelsMax=noStringersMax+1;
K=4.163;                                                                    
ESkin=71.8e9;

%% Initialize
b=length(noPanelsMax); 
tSkin=length(noPanelsMax);
aSkin=length(noPanelsMax);

% Determine Skin Thickness and Skin Area for different panel sizes
 


%% Determine Stringer Thickness for different panels 
for i=1:noPanelsMax
             b(i)=c_alongSpan(10000)/i; 
             tSkin(i)= ((N_alongSpan(10000)*(b(i))^2)/(K*ESkin))^(1/3);
             aSkin(i)=c_alongSpan(10000)*tSkin(i);
end 

x=1;
for As_bt=0.5:0.025:1.0
    y=1;
    for ts_t=0.5:0.025:1.0
        for i=1:noPanelsMax
             noStringers=i-1;
            if noStringers>=1
               tStringer(i)=ts_t*tSkin(i);
               aStringer(i)=(tSkin(i)*b(i)*As_bt)*noStringers;             % Calculate stringer area
               heightStringer(i)=(aStringer(i))/(noStringers*1.6*tStringer(i));
               depthStringer(i)=0.3*heightStringer(i);
            else 
               tStringer(i)=0;
               aStringer(i)=0;
               heightStringer(i)=0;
               depthStringer(i)=0;
            end 
            aEffective(i)=aSkin(i)+aStringer(i);
        end
        numberStringer=0:noPanelsMax-1;
        boundaryCondition1=heightStringer<=(0.15*b2(10000));
        boundaryCondition2=b>7*depthStringer;
        numberStringer=numberStringer(boundaryCondition1 & boundaryCondition2);
        heightStringer=heightStringer(boundaryCondition1 & boundaryCondition2);
        tStringer=tStringer(boundaryCondition1 & boundaryCondition2);
        aEffective=aEffective(boundaryCondition1 & boundaryCondition2);


        stringerGeometry.AStoBT(x,y)=As_bt;
        stringerGeometry.TStoT(x,y)=ts_t;
        stringerGeometry.tStringer(x,y)=tStringer(1,end);
        stringerGeometry.aEffective(x,y)=aEffective(length(tStringer));
        stringerGeometry.numberStringer(x,y)=numberStringer(end);
        y=y+1;
    end
    x=x+1;
end

[~,index]= min(stringerGeometry.aEffective(:));
[min_x,min_y]=ind2sub(size(stringerGeometry.aEffective),index);
Optimum.AStoBT=stringerGeometry.AStoBT(min_x,min_y);
Optimum.TStoT=stringerGeometry.TStoT(min_x,min_y);
Optimum.tStringer=stringerGeometry.tStringer(min_x,min_y);
Optimum.aEffective=stringerGeometry.aEffective(min_x,min_y);
disp(Optimum)













