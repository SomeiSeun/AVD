function[Radial_Ww] = GimmeTiresRaymer()
% This function will run through the entire database of tires available and
% select the ones which satisfy the load requirements and then pick the one
% with the smallest dimensions from those.

%% Load entire database
load('Wheels_Radial.mat') 

%% Calculate the maximum Ww carried by each tire

% 1. Radial wheels:

Radial_Ww = Radial_RatedInflationPSI .* 2.3 .* ((Radial_SectionWidthMaxGrown .* Radial_OutsideDiamMaxGrown).^0.5) .* ( (Radial_OutsideDiamMaxGrown./2) - ((Radial_StaticLoadedRadiusMax + Radial_StaticLoadedRadiusMin)/2) );
figure(2)
plot(Radial_Ww)
hold on
plot(Radial_RatedLoadLbs, '--')


end