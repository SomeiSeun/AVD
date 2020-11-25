%% Undercarriage v2

% The previous script never constrained the main gear to actually fit with
% the wing. That was an issue because the main gear position could end up
% fore or aft of the wing rear spar or even the wing. Also there were
% difficulties with deciding the height of the undercarriage and with
% deciding a good way to iterate.

% This new code now constrains the main joint to the rear spar of the wing
% right off the bat. Lets see where it goes.

%% Housekeeping
clear
clc
close all

%% Wing placement

% The wing is assumed to be placed in such a way that the trailing edge is
% coincident with the bottom of the fuselage. The quarter chord of the
% reference wing (the point being used to place wing) is then easily
% calculated using the root chord and setting angle. The following are
% taken with reference to the fuselage centreline, origin at the front of
% the fuselage cabin section.

xposwingrootmin = 32;           %m (from weight & balance, stability) (assumed for now)
xposwingrootmax = 34;           %m (from weight & balance, stability) (assumed for now)
radius_fuselage = 4.7/2;        %m (from fuselage)
length_root_chord = 7.4505;     %m (from wing design)
setting_angle = 2.2;            %deg (from wing design)

xpos.wingroot = [xposwingrootmin, xposwingrootmax];
ypos.wingroot = 0;
zpos.wingroot = (-radius_fuselage) + 0.75*length_root_chord*sind(setting_angle);

%% Rear spar placement

% The current assumption is that there are two spars in the wing, the front
% and the rear spars. Purely by assumption (as is valid at this stage), we
% can set the rear spar to be placed at 60% chord. Now using the wing
% geometry and this added assumption we can get the rear spar placement.
% Also keep in mind that I put 0.60 here but in reality if we want to place
% the main undercarriage joint elsewhere we can just find what the
% equivalent rear spar location would have been.

rear_spar_chord = 0.60;         %percent (assumed)

xpos.rearspar = xpos.wingroot + length_root_chord*(rear_spar_chord - 0.25)*cosd(setting_angle);
ypos.rearspar = 0;
zpos.rearspar = zpos.wingroot - length_root_chord*(rear_spar_chord - 0.25)*sind(setting_angle);

%% Main gear joint placement constraint

% This placement method is a bit shaky. Here I assume the y position of the
% main gear and then calculate what the x and z positions will be. I guess
% it makes sense because y is the variable that is the most free because x
% and z are constrained to follow the rear spar. Another assumption made is
% that the twist of the wing has a negligible effect on the x,y,z
% positions. This is just to make life easy.

yposmgmin = 3;                  %m (assumed)
yposmgmax = 10;                 %m (assumed)
sweep_angle = 24;               %deg (from wing design)
dihedral_angle = 5;             %deg (from wing design)

ypos.mgjoint = [yposmgmin, yposmgmax];
xpos.mgjoint = xpos.rearspar + ypos.mgjoint*( tand(sweep_angle)*cosd(setting_angle) + tand(dihedral_angle)*sind(setting_angle) );
zpos.mgjoint = zpos.rearspar + ypos.mgjoint*(-tand(sweep_angle)*sind(setting_angle) + tand(dihedral_angle)*cosd(setting_angle) );

% Now the main gear joint is constrained, with only one degree of freedom
% which comes from the yposmgoptimal. This variable can be iterated.

%% Constraint diagram planning

% A similar constraint diagram can be produced as the one earlier. Just
% like we took max and min values for the cg, we can take max and min
% values for the yposmgoptimal. Then we are able to normally plot the main
% gear xpos and nose gear xpos, with just the constraint called "place on
% rear spar".

%% Get data
load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF6')
disp(['The mass of aircraft is ', num2str(round(W0*2.20462262/9.81)), ' lbs'])

%% Step 1: Assume tire pressure, number of u/c struts and wheels per strut

% Decisions
% NoseTirePressure = 150;
% MainTirePressure = 150;
% NoseStruts = 1;
% NoseWheelsPerStrut = 2;
% MainStruts = 2;
% MainWheelsPerStrut = 4;




