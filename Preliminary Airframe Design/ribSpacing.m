%% Rib Sizing, Spacing and Optimisation

function[rSpacing,optRibSpacing,massWingBox,massEffRib,massEffSS,ribThickness,minMassPosition]=ribSpacing(wing,Optimum,boxHeight,skinThicknessDist,N_alongSpan,noStringersDist,LskinThicknessDist,LnoStringersDist,LWSSOptimum)
%Inputs to add to function later...
F=0.75;
E=71.8e9;
boxLength=wing.boxLength;
% Calculate effective skin thickness and second moment of Area of panel
aStringer=ones(1,length(wing.span));
aLStringer=ones(1,length(wing.span));
aStringer=Optimum.aStringer*aStringer;
aLStringer=LWSSOptimum.aStringer*aLStringer;
T=0.5*((skinThicknessDist+LskinThicknessDist)+(aStringer./(noStringersDist*Optimum.stringerPitch))+(aLStringer./(LnoStringersDist*LWSSOptimum.stringerPitch))); 
IxxPanel=2*boxLength.*((T.^3)/12 + T.*(0.5*boxHeight).^2);

%% Determining Optimum Rib Spacing 
discSpan=wing.span(1)/1000; % Discretise wing into sections
rSpacing=0.1:0.001:3; 
effectiveRT=zeros(length(rSpacing),length(wing.span));
effectiveSST=zeros(length(rSpacing),length(wing.span));
ribThickness=zeros(length(rSpacing),length(wing.span));


for i=1:length(rSpacing)

        ribThickness(i,:)=(((wing.bendingMoment.^2)*(rSpacing(i)).*(boxHeight.^3).*(T))./(7.24*E^2*IxxPanel.^2)).^(1/3);
        BC1=ribThickness<0.001;
        ribThickness(BC1)=0.001;
        
       %% Optimise
        nAlongSpan=abs(N_alongSpan);
        effectiveSST(i,:)=(1/F)*sqrt(rSpacing(i)*nAlongSpan/E);                           % Effective Thickness calculated from mean stress realised by the skin and stringer at failure.
        effectiveRT(i,:)=(boxHeight.*ribThickness(i,:))/(rSpacing(i));
        massEffSS(i)=sum((effectiveSST(i,:).*boxLength.*discSpan),2);
        massEffRib(i)=sum((effectiveRT(i,:).*boxLength.*discSpan),2);
end
massWingBox=massEffRib + massEffSS;
[minMass,minMassPosition]=min(massWingBox); 
optRibSpacing=rSpacing(minMassPosition);
end


