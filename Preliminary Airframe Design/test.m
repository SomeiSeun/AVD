% TEST Script

clear
clc
close all

load('NACA 0012 plotting purposes.txt')
x = NACA_0012_plotting_purposes(:,1);
y = NACA_0012_plotting_purposes(:,2);

figure
plot(x,y,'r')
hold on
axis equal
xlabel('x/c')
ylabel('y/c')
plot(0.41,0,'xb','MarkerSize',10)
legend({'NACA 0012','cg'},'Location','Northeast')
grid minor