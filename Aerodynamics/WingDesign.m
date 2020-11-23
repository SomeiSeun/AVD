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
%in this function, why is the second input 0 if it is meant to be a
%fraction

Sweep_TE= sweepConverter(29,0,1 ,AspectRatio, TaperRatio);
Sweep_maxt= sweepConverter(29,0,0.349 ,AspectRatio, TaperRatio);
Dihedral=5;             %degrees --> between 3 and 7; 5 chosen (midpoint)
Twist=-3;                %use historical data for initial selection
Wing_incidence_initialapprox =1;      %degrees --> initial approx as per Raymer



%planform coordinates
y_root=0;
y_tip=b/2;
 
root_chord=(2*Sref)/(b*(1+TaperRatio));
tip_chord=root_chord*TaperRatio;

MAC= (2/3)*root_chord*(1+TaperRatio+TaperRatio^2)/(1+TaperRatio);
y_MAC=(b/6)*(1+2*TaperRatio)/(1+TaperRatio);
x_AC=y_MAC*tan(Sweep_quarterchord)+0.25*MAC;


%various wing areas
fuselage_diameter= 4.175556; %from Structures

c_fuselage = root_chord - fuselage_diameter*( tand(Sweep_LE) - tand(Sweep_TE) );
WingArea_fuselage=0.5*fuselage_diameter*(root_chord+c_fuselage);
S_exposed= Sref-WingArea_fuselage;
S_wetted= S_exposed*(1.997+0.52*Airfoil_ThicknessRatio_used);            %check--> depends on t/c of airfoil


%% wing incidence
i_w_approx=2.28;

%% wing incidence from Gudmundsson
alpha_zl= -1.8; %zero lift AoA
CL_alpha=6.7913; %lift curve slope
fus_angle =1.5; %fuselage upsweep angle
alpha_c=(1.1358e+06+1.1244e+06)/(CL_alpha*rho_cruise*(V_Cruise^2)*Sref) + alpha_zl;

twist_correction=(1+2*TaperRatio)*(-3)/(3+3*TaperRatio);
i_w_GMS=alpha_c+fus_angle-twist_correction;


%% HLD selection: LE
CLmax_required=2.2;
CLmax_clean=1.283;
Delta_CLmax=0.9170;
%% everything below this TO CHANGE
Sflapped_over_Sref=0.9; %HLD to cover 90% of LE
Sweep_hingeline_LE= Sweep_LE;

deltaClmax_HLD_LE = Delta_CLmax/ (0.9*Sflapped_over_Sref*cosd(Sweep_hingeline_LE));

% SLATS chosen as HLD at LE
save('WingDesign.mat')