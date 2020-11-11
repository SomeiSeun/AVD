%code for wing design and parameters 
clear 
clc

%% load values from Palash's script
% load('C:\Users\Nutha\OneDrive - Imperial College London\3rd Year\AVD\Wing design\Github\AVD\Initial Sizing & Constraints\InitialSizing.mat', 'AspectRatio', 'W0', 'WingLoading', 'ThrustToWeight', 'V_Cruise')

load('../Initial Sizing/InitialSizing.mat', 'AspectRatio', 'W0', 'WingLoading', 'ThrustToWeight', 'V_Cruise')
%variables loaded include the design point, aspect ratio, takeoff weight,
%cruise speed, 

%% calculate design Cl (sectional)
[~,~,~,rho_cruise]= atmosisa(distdim(35000,'ft','m'));
q_cruise=0.5*rho_cruise*V_Cruise^2;
Cl_design_sectional = WingLoading/q_cruise;

%% airfoil
Airfoil_ThicknessRatio=0.138; %from historical trend line in Raymer (this is the value
% for the airfoil and not planform)


%% planform

Sref=W0/WingLoading;
b=sqrt(Sref*AspectRatio);

%wing geometry
TaperRatio= 0.38;       %from Raymer's graph
Sweep_LE= 29;           %degrees --> from the graph in Raymer
% Sweep_quarterchord= ;  %need to check
Dihedral=5;             %degrees --> between 3 and 7; 5 chosen (midpoint)
% Twist=                %use historical data for initial selection
Wing_incidence =1;      %degrees --> initial approx as per Raymer

%planform coordinates
y_root=0;
y_tip=b/2;
 
root_chord=(2*Sref)/(b*(1+TaperRatio));
tip_chord=root_chord*TaperRatio;

MAC= (2/3)*root_chord*(1+TaperRatio+TaperRatio^2)/(1+TaperRatio);
y_MAC=(b/6)*(1+2*TaperRatio)/(1+TaperRatio);
x_AC=y_MAC*tan(sweep_quarterchord)+0.25*MAC;


save('wingDesign.mat')