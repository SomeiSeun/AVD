function[noStringersDist,skinThicknessDist,stringerThicknessDist]=skinStringerDistribution(N_alongSpan,lengthWingBox,Optimum)
K=4.2;
ESkin=71.8e9;
stringerPitch=Optimum.stringerPitch;
stringerThickness=Optimum.tStringer;
noPanelsDist=floor(lengthWingBox/stringerPitch); 
noStringersDist=noPanelsDist-1;
a=N_alongSpan(1:end)*(stringerPitch^2);
b=K*ESkin;
skinThicknessDist=(a/b).^(1/3);
stringerThicknessDist=stringerThickness*ones(1,length(lengthWingBox));

% Set Boundary Conditions
na1=skinThicknessDist<0.001;
skinThicknessDist(na1)=0.001;
end 