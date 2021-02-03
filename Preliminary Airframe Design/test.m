% TEST Script

clear
clc

load('ConceptualDesign.mat','rho_cruise','V_Cruise')
n = 1;
K_s = 8.1;
rho = rho_cruise;
V = V_Cruise;
E = 73*10^9;
b1 = 0.25;
b2 = 0.75;
flex_ax = 0.5;
cm0 = -0.2;
cg = 0.6;
[tw1,tw2] = shear_flow(n, K_s, rho, V, E, b1, b2, flex_ax, cm0, cg);