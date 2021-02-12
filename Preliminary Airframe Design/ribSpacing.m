%% Rib Sizing, Spacing and Optimisation

% function[IxxPanel,fCrush,ribThickness]=ribSpacing(skinThicknessDist,wing,Optimum,c_alongSpan,N_alongSpan)
% Calculate Second Moment of Area of Skin Panel (all values in metres)
E=71.8e9;
F=0.95;
densitySS=2.7;
densityRibs=2.7;
hWB=0.12*c_alongSpan;
boxLength=wing.boxLength;
boxArea=wing.boxArea;
T=skinThicknessDist+(Optimum.aStringer/(Optimum.numberStringer*Optimum.stringerPitch));
IxxPanel=(boxLength.*((T.^3)/12) + T.*(0.5*hWB).^2);

% Find Optimum Rib Spacing
rSpacing=0.3:0.001:1.0; 
for i=1:length(rSpacing)
        fCrush(i,:)=(wing.bendingMoment.*rSpacing(i).*(hWB).*(T).*boxLength)/(2*E*(IxxPanel).^2); 
        ribThickness(i,:)=(fCrush(i,:).*((hWB.*(wing.bendingMoment).^2)).^2)/(3.62.*boxLength*E);
        
        % Apply BC to ensure rib thickness is greater than 1mm 
        BC1=ribThickness<0.001; 
        ribThickness(BC1)=0.001;
        
       %% To Optimise, consider achieving optimum mass: 
          effectiveSST(i,:)=1/F*sqrt(rSpacing(i)*N_alongSpan/E);                                % Effective Thickness calculated from mean stress realised by the skin and stringer at failure.
          effectiveRT(i,:)=(hWB.*ribThickness(i,:))/rSpacing(i);
          massEffSS(i)=sum((densitySS*effectiveSST(i,:).*boxArea),2);
          massEffRib(i)=sum((densityRibs*effectiveRT(i,:).*boxArea),2);

end
massWingBox=massEffRib + massEffSS;
[optMass,minindex]=min(massWingBox); 
 optRibSpacing=rSpacing(minindex);
 
% end
 
save('ribSpacing.mat','optRibSpacing')

%% Plots of Results

figure
hold on 
plot(rSpacing,massEffRib)
hold off

