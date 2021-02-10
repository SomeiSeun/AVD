%% Optimisation of Skin Stringer Panels: values look a bit too good to be correct
clear
clc
close all 

%% TO DO still: 


%% Load Data
load('WingDistributions.mat')
load('Materials.mat')
load('skinStringerpanel.mat')  % Load Load per unit width distribution across span


%% Calculate Effective Area for a range of As_bt and ts_t values

noStringersMax=65;                                                         % Note these values are not realistic and have simply been chosen to test the code
noPanelsMax=noStringersMax+1;
K=3.62;                                                                    
ESkin=71.8e9;

% Initialize
b=length(noPanelsMax); 
tSkin=length(noPanelsMax);
aSkin=length(noPanelsMax);
aEffective=length(noPanelsMax);
numberofStringers=1:noPanelsMax-1;
% Determine Skin Thickness and Skin Area for different panel sizes
 


%% Determine Stringer Thickness for different panels 
for i=1:noPanelsMax
             b(i)=c_alongSpan(10000)/i; 
             tSkin(i)= ((N_alongSpan(10000)*(b(i))^2)/(K*ESkin))^(1/3);
             aSkin(i)=c_alongSpan(10000)*tSkin(i);
end 

x=1;
for As_bt=0.5:0.005:1.0
    y=1;
    for ts_t=0.5:0.005:1.0
        for i=1:noPanelsMax
             b(i)=c_alongSpan(10000)/i; 
             tSkin(i)= ((N_alongSpan(10000)*(b(i))^2)/(K*ESkin))^(1/3);
             aSkin(i)=c_alongSpan(10000)*tSkin(i);
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
        stringerIndex=0:noPanelsMax-1;
        
        % Apply Boundary Conditions
        boundaryCondition1=heightStringer<(0.1*b2(10000));
        boundaryCondition2=b>(8*depthStringer);

        stringerIndex=stringerIndex(boundaryCondition1 & boundaryCondition2);
        heightStringer=heightStringer(boundaryCondition1 & boundaryCondition2);
        tSkin=tSkin(boundaryCondition1 & boundaryCondition2);
        tStringer=tStringer(boundaryCondition1 & boundaryCondition2);
        aEffective=aEffective(boundaryCondition1 & boundaryCondition2);
        
        if isempty(stringerIndex) 
        stringerGeometry.AStoBT(x,y)=NaN;
        stringerGeometry.TStoT(x,y)=NaN;
        stringerGeometry.tStringer(x,y)=NaN;
        stringerGeometry.aEffective(x,y)=NaN;
        stringerGeometry.stringerIndex(x,y)=NaN;
        stringerGeometry.tSkin(x,y)=NaN;
        stringerGeometry.heightStringer(x,y)=NaN;
        else 
        stringerGeometry.AStoBT(x,y)=As_bt;
        stringerGeometry.TStoT(x,y)=ts_t;
        stringerGeometry.tStringer(x,y)=tStringer(1,end);
        stringerGeometry.aEffective(x,y)=aEffective(length(tStringer));
        stringerGeometry.numberStringer(x,y)=stringerIndex(end);
        stringerGeometry.tSkin(x,y)=tSkin(end);
        stringerGeometry.heightStringer(x,y)=heightStringer(end);
        end
        y=y+1;
    end
    x=x+1;
end


[~,index]= min(stringerGeometry.aEffective(:));
[min_x,min_y]=ind2sub(size(stringerGeometry.aEffective),index);
Optimum.AStoBT=stringerGeometry.AStoBT(min_x,min_y);
Optimum.TStoT=stringerGeometry.TStoT(min_x,min_y);
Optimum.tStringer=stringerGeometry.tStringer(min_x,min_y);
Optimum.tSkin=stringerGeometry.tSkin(min_x,min_y);
Optimum.aEffective=stringerGeometry.aEffective(min_x,min_y);
Optimum.numberStringer=stringerGeometry.numberStringer(min_x,min_y);
Optimum.heightStringer=stringerGeometry.heightStringer(min_x,min_y);
Optimum.b=min(b);
disp(Optimum)




%% Using Optimum As/bt and Ts/t ratio, find stringer parameters


for j=1:noPanelsMax
            b(j)=c_alongSpan(10000)/j; 
             tSkin(j)= ((N_alongSpan(10000)*(b(j))^2)/(K*ESkin))^(1/3);
             aSkin(j)=c_alongSpan(10000)*tSkin(j);
             noStringers=j-1;
            if noStringers>=1
               tStringer(j)=0.75*tSkin(j);
               aStringer(j)=(tSkin(j)*b(j)*0.5)*noStringers;             % Calculate stringer area
               heightStringer(j)=(aStringer(j))/(noStringers*1.6*tStringer(j));
               depthStringer(j)=0.3*heightStringer(j);
            else 
               tStringer(j)=0;
               aStringer(j)=0;
               heightStringer(j)=0;
               depthStringer(j)=0;
            end 
            aEffective(j)=aSkin(j)+aStringer(j);
end


%% Apply Boundary Conditions
boundaryCondition1=heightStringer<(0.1*b2(10000));
boundaryCondition2=b>(8*depthStringer);









