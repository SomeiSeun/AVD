% TEST Script

clear
clc
close all

load('NACA 64215.txt')
x = NACA_64215(:,1);
y = NACA_64215(:,2);

figure
plot(x,y)
axis equal
grid on