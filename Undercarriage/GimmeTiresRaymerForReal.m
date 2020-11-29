function[Wheel] = GimmeTiresRaymerForReal(LoadReq, OptimiseFor)
% Example: [BestWheelType, BestWheelReferenceNumber,
% BestWheelRatedInflationPSI] = GimmeTiresRaymerForReal(LoadReq,
% OptimiseFor) where:
    % LoadReq is the load required for that single wheel
    % OptimiseFor = 1 to find wheel with smallest diameter
    % OptimiseFor = 2 to find wheel with smallest width
    % OptimiseFor = 3 to find wheel with smallest PSI
% This function would sort tires that work for requested load and find the
% one with the smallest value for requested parameter.

%% Load entire wheel database
load('Wheels_All.mat')

%% Find the wheels that fit load requirements
Index1 = find(RatedLoadLBS > LoadReq)
Index1 = find(RatedInflationPSI(Index1) < 200)
plot(RatedInflationPSI(Index1))

%% Based on optimising requirement, find wheel with smallest width or diam
if OptimiseFor == 1
    MinDiam = min(InflatedOuterDiamMaxINCH(Index1));
    Index2 = find(InflatedOuterDiamMaxINCH(Index1) == MinDiam);
    A = Index1(Index2);
elseif OptimiseFor == 2
    MinWidth = min(InflatedSectionWidthMaxINCH(Index1));
    Index2 = find(InflatedSectionWidthMaxINCH(Index1) == MinWidth);
    A = Index1(Index2);
elseif OptimiseFor == 3
    MinPSI = min(RatedInflationPSI(Index1));
    Index2 = find(RatedInflationPSI(Index1) == MinPSI);
    A = Index1(Index2);
elseif OptimiseFor == 4
    MinFactor = min(RatedInflationPSI(Index1).*InflatedOuterDiamMaxINCH(Index1));
    Index2 = find(RatedInflationPSI(Index1).*InflatedOuterDiamMaxINCH(Index1) == MinFactor);
    A = Index1(Index2);
end
A = A(1);
Wheel.Index = A;
Wheel.Type = TypeOfTire(A);
Wheel.ReferenceNumber = ReferenceNumber(A);
Wheel.TTorTL = TTorTL(A);
Wheel.RatedSpeedMPH = RatedSpeedMPH(A);
Wheel.RatedLoadLBS = RatedLoadLBS(A);
Wheel.RatedInflationPSI = RatedInflationPSI(A);
Wheel.MaxBrakingLoadLBS = MaxBrakingLoadLBS(A);
Wheel.MaxBottomingLoadLBS = MaxBottomingLoadLBS(A);
Wheel.OuterDiamMaxINCH = InflatedOuterDiamMaxINCH(A);
Wheel.OuterDiamMinINCH = InflatedOuterDiamMinINCH(A);
Wheel.SectionWidthMaxINCH = InflatedSectionWidthMaxINCH(A);
Wheel.SectionWidthMinINCH = InflatedSectionWidthMinINCH(A);
Wheel.ShoulderDiamMaxINCH = ShoulderDiamMaxINCH(A);
Wheel.ShoulderWidthMaxINCH = ShoulderWidthMaxINCH(A);
Wheel.StaticLoadedRadiusINCH = StaticLoadedRadiusINCH(A);
Wheel.FlatTireRadiusINCH = FlatTireRadiusINCH(A);
Wheel.AspectRatio = TireAspectRatio(A);
Wheel.RimSize = WheelRimSize(A);
Wheel.WidthBetweenFlangesINCH = WheelWidthBetweenFlangesINCH(A);
Wheel.SpecifiedRimDiamINCH = WheelSpecifiedRimDiamINCH(A);
Wheel.FlangeHeightINCH = WheelFlangeHeightINCH(A);
Wheel.MinLedgeWidthINCH = WheelMinLedgeWidthINCH(A);

end