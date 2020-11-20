%% Weight and Balance

% This is a rough script which would be later used to properly make a
% weight and balance code.

% Aims of this code:
    % Ensure that the x cg is placed approximately at 30% MAC
    % Sufficient static margin 

%% Housekeeping
clear
clc
close all

%% Define origin

% Origin for this purpose is placed at the centre of the foremost plane of
% the cylindrical part of the fuselage. This gives a nice reference point
% as it is the exact centre of the circle. 

% x axis runs aft (backwards to tail)
% y axis runs laterally (sideways)
% z axis runs up

% Placement of components then begins using this as the origin. Placements
% would be indicated by small x, y, z and centres of mass would be
% indicated by capital X, Y, Z.

x.origin = 0;
y.origin = 0;
z.origin = 0;

%% Fuselage

% Fuselage structure (with reference to its foremost plane)
x.fuselage.structure = 0;
y.fuselage.structure = 0;
z.fuselage.structure = 0;













