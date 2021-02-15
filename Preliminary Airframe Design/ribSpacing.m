%% Rib Sizing, Spacing and Optimisation

function[rSpacing,optRibSpacing,massWingBox,massEffRib,massEffSS]=ribSpacing(wing,Optimum,boxHeight,skinThicknessDist,N_alongSpan)
%Inputs to add to function later...
densitySS=2.7;
densityRibs=2.7;
F=0.95;
E=71.8e9;
boxLength=wing.boxLength;
% Calculate effective skin thickness and second moment of Area of panel
T=skinThicknessDist+(Optimum.aStringer/(Optimum.numberStringer*Optimum.stringerPitch));
IxxPanel=(boxLength.*(T.^3)/12) +(boxLength.* T.*(0.5*boxHeight).^2);

%% Determining Optimum Rib Spacing 
discSpan=wing.span(1)/1000; % Discretise wing into sections
rSpacing=0.1:0.001:1.3; % Array of rib spacings

% Loop runs through a range of rib spacings and calculates the total mass
% of wing box
for i=1:length(rSpacing)
        fCrush(i,:)=((wing.bendingMoment.^2)*(rSpacing(i)).*(boxHeight).*(T).*boxLength)/(2*E*(IxxPanel.^2)); 
        num=(fCrush(i,:).*(boxHeight.^2));
        den=3.62*E*boxLength;
        ribThickness(i,:)=(num/den).^1/3;

        % Apply boundary conditions to ensure rib thickness is greater than 1mm
        BC1=ribThickness<0.001;
        ribThickness(BC1)=0.001;
        
       %% To Optimise, consider achieving optimum mass: 
        nAlongSpan=abs(N_alongSpan);
        effectiveSST(i,:)=(1/F)*(rSpacing(i)*(nAlongSpan/E)).^(1/2);                           % Effective Thickness calculated from mean stress realised by the skin and stringer at failure.
        effectiveRT(i,:)=(boxHeight.*ribThickness(i,:))/(rSpacing(i));
        massEffSS(i,:)=sum((densitySS*effectiveSST(i,:).*boxLength.*discSpan),2);
        massEffRib(i,:)=sum((densityRibs*effectiveRT(i,:).*boxLength.*discSpan),2);
end
massWingBox=massEffRib + massEffSS;
[~,minMassIndex]=min(massWingBox); 
optRibSpacing=rSpacing(minMassIndex);
end


