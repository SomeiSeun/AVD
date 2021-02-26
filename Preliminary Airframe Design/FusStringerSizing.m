function Stringers = FusStringerSizing(BendingMoment, diameter,

%% bending
Circ=pi*diameter;
StringerSpacing=convlength(7,'in','m');  % Use value from notes as a starting point; range is 6.5-9 inches
NumStringers=
SkinThickness= %t_f
TtlStringerArea=
EquivBoomArea=(SkinThickness*StringerSpacing/6)*(2+1); %Boom area from skin can also be considered as 15*t
SingleBoomArea=TtlStringerArea+EquivBoomArea; %S
x_centroid=
I_xx=
EdgeStress_max= %c
sigma= %max principle stress


%% shear


%% check stringer stress with yield and Euler buckling

%% 4.Check bay area between stringers  with yield and local plate buckling stress.


%%extra: not sure where this goes (AB)
% StringerShape: Z stringers
FrameDepth=convlength(4.0, 'in','m');    % Range is 3.5-4.4
FrameSpacing=convlength(20, 'in','m');

% Materials to use: 2000 series for skin and 7000 series for stringer

% Aassume constant stringer pitch for both tensile side and compression side


%create structure of outputs
Stringers.spacing=StringerSpacing;
Stringers.