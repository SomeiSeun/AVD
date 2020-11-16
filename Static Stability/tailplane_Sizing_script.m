% Creating a script to find out the tail plane geometry values and
% storing those values in a .mat file

clear
clc

% Loading in the data required
load('../Aerodynamics/wingDesign.mat');

% Using the function to find some of the geometries for the tail plane
[S_HT, S_VT, b_HT, b_VT, C_avg_HT, C_avg_VT] = tailplaneSizing(4, 1.5, Sref, MAC, b, 1.5, 4);

% I will list the variables here for reference, (ALL SI UNITS)
% S_HT is the area of the Horizontal tail
% S_VT is the area of the Vertical tail
% b_HT is the span of Horizontal tail
% b_VT is the span of Vertical tail
% C_avg_HT is average chord of Horizontal tail
% C_avg_VT is average chord of Vertical tail

% ^ A little unsure about using the Mean Aerodynamic Chord value instead of
% Mean Geometric Chord like it was given in GUDMUNDSSON. Maybe they are not
% very different? 

TaperRatioTailplane = 0.4;                 % Taper Ratio is chosen to be 0.4 for both vertical and horizontal tail plane
Horizontal_tailplane_sweep = Sweep_LE + 5; % Horizontal tail plane sweep in degrees
Vertical_tailplane_sweep = Sweep_LE + 5;   % Vertical tail plane sweep in degrees
twist_tailplane = 0;                       % 0 deg twist for both Horizontal and Vertical tail planes
Dihedral_tailplane = 0;                    % 0 dihedral for both Horizontal and Vertical tail plane
Vertical_tailplane_thickness_ratio = Airfoil_ThicknessRatio; % Same thickness ratio for vertical tail plane as for the main wing
Horizontal_tailplane_thickness_ratio = Airfoil_ThicknessRatio - 0.02; % Thickness ratio for the Horizontal tail plane
