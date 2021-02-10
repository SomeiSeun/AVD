% Master code for Fuselage

clear
clc
close all

load('ConceptualDesign.mat', 'W0',  'components', 'rho_cruise', 'V_Cruise', 'mainLength')
%load('Materials.mat', 'SparMaterial', 'UpperSkinMaterial')
%^ Using same materials for fuselage as the wings?

Nz = 1.5*2.5;
numSections = 10000;

fuselage = fuselage_distributions(components, Nz, numSections, W0, mainLength);