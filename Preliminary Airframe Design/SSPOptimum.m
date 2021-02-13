function[Optimum]=SSPOptimum(wing,N_alongSpan)
noStringersMax=100;                                                         
noPanelsMax=noStringersMax+1;
K=3.62;                                                                    
ESkin=71.8e9;

% Initialize
b=length(noPanelsMax); 
tSkin=length(noPanelsMax);
aSkin=length(noPanelsMax);
aEffective=length(noPanelsMax);
numberofStringers=1:noPanelsMax-1;
boxHeight=0.15*wing.chord; 
%% Effective Area Calculations for a number of different 
x=1;
for As_bt=0.5:0.005:1.0                                                     % Runs through a range of different Stringer Area to Skin Area Ratios
    y=1;
    for ts_t=0.5:0.005:1.0                                                  % Runs through a range of different Stringer Thickness to Skin Thickness Ratios
        for i=1:noPanelsMax                                                 % Find the skin and stringer areas respectively for a number of different panel sizes
             b(i)=wing.boxLength(end)/i;                                    % Calculate stringer pitch           
             tSkin(i)= ((N_alongSpan(end)*(b(i))^2)/(K*ESkin))^(1/3);       % Thickness of the skin
             aSkin(i)=wing.boxLength(end)*tSkin(i);                            % Area of Skin 
             noStringers=i-1;
            if noStringers>=1   
               tStringer(i)=ts_t*tSkin(i);                                  % Thickness of stringer
               aStringer(i)=(tSkin(i)*b(i)*As_bt)*noStringers;              % Area of Stringer
               heightStringer(i)=(aStringer(i))/(noStringers*1.6*tStringer(i)); % Height Stringer
               depthStringer(i)=0.3*heightStringer(i);                          % depth of stringer based on d/h=0.3

            else  % No stringers 
               tStringer(i)=0;
               aStringer(i)=0;
               heightStringer(i)=0;
               depthStringer(i)=0;
            end 
            aEffective(i)=aSkin(i)+aStringer(i);
        end
        stringerIndex=0:noPanelsMax-1;
        
        % Apply Boundary Conditions to ensure stringer dimensions obtained
        % are practical
        bC1=heightStringer<(0.1*boxHeight(end));                            % height of the stringer must be less than 10% of the wingbox
        bC2=b>(8*depthStringer);                                            % stringer pitch must be at least 8 times the depth of the stringer 
        bC3=heightStringer>0.0225;                                          % stringer height must be more than 2 centimeters
        bC4=tSkin>0.00125;
        bC5=tStringer>0.00125;
       

        stringerIndex=stringerIndex(bC1 & bC2 & bC3 & bC4 & bC5);
        heightStringer=heightStringer(bC1 & bC2 & bC3 & bC4 & bC5);
        tSkin=tSkin(bC1 & bC2 & bC3 & bC4 & bC5);
        tStringer=tStringer(bC1 & bC2 & bC3 & bC4 & bC5);
        aStringer=aStringer(bC1 & bC2 & bC3 & bC4 & bC5);
        aEffective=aEffective(bC1 & bC2 & bC3 & bC4 & bC5);
        b=b(bC1 & bC2 & bC3 & bC4 & bC5);
        
        %Store all passed values in structure
        if isempty(stringerIndex)                                           %
        stringerGeometry.AStoBT(x,y)=NaN;
        stringerGeometry.TStoT(x,y)=NaN;
        stringerGeometry.tStringer(x,y)=NaN;
        stringerGeometry.aStringer(x,y)=NaN;
        stringerGeometry.aEffective(x,y)=NaN;
        stringerGeometry.stringerIndex(x,y)=NaN;
        stringerGeometry.tSkin(x,y)=NaN;
        stringerGeometry.heightStringer(x,y)=NaN;
        stringerGeometry.b(x,y)=NaN;


        else 
        stringerGeometry.AStoBT(x,y)=As_bt;
        stringerGeometry.TStoT(x,y)=ts_t;
        stringerGeometry.tStringer(x,y)=tStringer(end);
        stringerGeometry.aStringer(x,y)=aStringer(end);
        stringerGeometry.aEffective(x,y)=aEffective(length(tStringer));
        stringerGeometry.numberStringer(x,y)=stringerIndex(end);
        stringerGeometry.tSkin(x,y)=tSkin(end);
        stringerGeometry.heightStringer(x,y)=heightStringer(end);
        stringerGeometry.b(x,y)=b(end);
        end
        y=y+1;
    end
    x=x+1;
end

% Optimum Stringer Sizing based of minimum area
[~,index]= min(stringerGeometry.aEffective(:));
[min_x,min_y]=ind2sub(size(stringerGeometry.aEffective),index);
Optimum.AStoBT=stringerGeometry.AStoBT(min_x,min_y);
Optimum.TStoT=stringerGeometry.TStoT(min_x,min_y);
Optimum.tStringer=stringerGeometry.tStringer(min_x,min_y);
Optimum.tSkin=stringerGeometry.tSkin(min_x,min_y);
Optimum.aStringer=stringerGeometry.aStringer(min_x,min_y);
Optimum.aEffective=stringerGeometry.aEffective(min_x,min_y);
Optimum.numberStringer=stringerGeometry.numberStringer(min_x,min_y);
Optimum.heightStringer=stringerGeometry.heightStringer(min_x,min_y);
Optimum.stringerPitch=stringerGeometry.b(min_x,min_y);


save('SkinStringerPanelOpt.mat','Optimum')


% Using Optimum As/bt and Ts/t ratio, use Catchpole diagram to find
% correction factor and find optimum number of stringers

K=4.2;
for j=1:noPanelsMax
            b(j)=wing.boxLength (end)/j; 
             tSkin(j)= ((N_alongSpan(end)*(b(j))^2)/(K*ESkin))^(1/3);
             aSkin(j)=wing.boxLength (end)*tSkin(j);
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
save('SkinStringerPanelOpt.mat','Optimum')
end 
