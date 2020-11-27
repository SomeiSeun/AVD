%code for wing design and parameters 
clear 
clc

%% load values from Palash's script
load('../Initial Sizing/InitialSizing.mat', 'AspectRatio', 'W0', 'WingLoading', 'ThrustToWeight', 'V_Cruise')
%variables loaded include the design point, aspect ratio, takeoff weight,
%cruise speed, 

%% calculate design Cl (sectional)
[~,~,~,rho_cruise]= atmosisa(distdim(35000,'ft','m'));
q_cruise=0.5*rho_cruise*V_Cruise^2;
Cl_design_sectional = WingLoading/q_cruise;

%% airfoil
Airfoil_ThicknessRatio_Required=0.138; %from historical trend line in Raymer (this is the value
% for the airfoil and not planform)

Airfoil_ThicknessRatio_used =0.15; %depends on the airfoil selected. For NACA 64215 t/c=0.15

%% planform

Sref=W0/WingLoading;
b=sqrt(Sref*AspectRatio);

%wing geometry
TaperRatio= 0.38;       %from Raymer's graph
Sweep_LE= 29;           %degrees --> from the graph in Raymer
Sweep_quarterchord= sweepConverter(29, 0, 0.25, AspectRatio, TaperRatio);%need to check

Sweep_TE= sweepConverter(29,0,1 ,AspectRatio, TaperRatio);
Sweep_maxt= sweepConverter(29,0,0.349 ,AspectRatio, TaperRatio);
Dihedral=5;             %degrees --> between 3 and 7; 5 chosen (midpoint)
Twist=-3;                %use historical data for initial selection

%planform coordinates
y_root=0;
y_tip=b/2;
 
root_chord=(2*Sref)/(b*(1+TaperRatio));
tip_chord=root_chord*TaperRatio;

MAC= (2/3)*root_chord*(1+TaperRatio+TaperRatio^2)/(1+TaperRatio);
y_MAC=(b/6)*(1+2*TaperRatio)/(1+TaperRatio);
x_AC=y_MAC*tand(Sweep_quarterchord)+0.25*MAC;


%various wing areas
fuselage_diameter= 4.175556; %from Structures

c_fuselage = root_chord - fuselage_diameter*( tand(Sweep_LE) - tand(Sweep_TE) );
WingArea_fuselage=0.5*fuselage_diameter*(root_chord+c_fuselage);
S_exposed= Sref-WingArea_fuselage;
S_wetted= S_exposed*(1.997+0.52*Airfoil_ThicknessRatio_used);            

%% wing incidence
i_w_approx=2.28;


%% HLDs
CLmax_required=2.2;
CLmax_clean=1.283;
Delta_CLmax=0.9170;
%% using double slotted flaps at TE
Sflapped_over_Sref=0.487; %dependent on aileron span
Sweep_hingeline_TE= Sweep_TE;

flap_deflection= Delta_CLmax/(1.6*Sflapped_over_Sref*cosd(Sweep_hingeline_TE));

save('WingDesign.mat')