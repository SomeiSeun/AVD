%% Optimisation of Skin Stringer Panels: not complete yet 
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
load('b2.mat')

%% Calculate Effective Area for a range of As_bt and ts_t values

noStringersMax=70;                                                         % Note these values are not realistic and have simply been chosen to test the code
noPanelsMax=noStringersMax+1;
K=4.2;                                                                    
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
for As_bt=0.5:0.005:1.2
    y=1;
    for ts_t=0.5:0.005:1.2
        for i=1:noPanelsMax
             noStringers=i-1;
            if noStringers>=1
               tStringer(i)=ts_t*tSkin(i);
               aStringer(i)=(tSkin(i)*b(i)*As_bt)*noStringers;             % Calculate stringer area
               heightStringer(i)=(aStringer(i))/(noStringers*1.6*tStringer(i));
            else 
               tStringer(i)=0;
               aStringer(i)=0;
            end 
            aEffective(i)=aSkin(i)+aStringer(i);
        end 
    stringerGeometry.AStoBT(x,y)=As_bt;
    stringerGeometry.TStoT(x,y)=ts_t;
    stringerGeometry.tStringer(x,y)=tStringer(end);
    stringerGeometry.aEffective(x,y)=aEffective(end);
    y=y+1;
    end
    x=x+1;
end

%% Find Optimum Combination of As_bt and Ts_t ratio to Minimise Area

[~,index]= min(stringerGeometry.aEffective(:));
[min_x,min_y]=ind2sub(size(stringerGeometry.aEffective),index);
Optimum.AStoBT=stringerGeometry.AStoBT(min_x,min_y);
Optimum.TStoT=stringerGeometry.TStoT(min_x,min_y);
Optimum.tStringer=stringerGeometry.tStringer(min_x,min_y);
Optimum.aEffective=stringerGeometry.aEffective(min_x,min_y);












%% To do on Monday: Apply Boundary Conditions and Apply
% BC1=heightStringer<=0.06;
%         BC2=tSkin>0.001;
%         BC3=tStringer>0.001;
%         heightStringer=heightStringer(BC1&BC2&BC3);
%         tSkin=tSkin(BC1&BC2&BC3);
%         tStringer=tStringer(BC1&BC2&BC3);
%         aEffective=aEffective(BC1&BC2&BC3);

