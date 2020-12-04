function CG_Envelope(CG_empty, CG_all, CG_all_noPay, sumWeight_empty, weight_all, weight_all_noPay, totalLength, xNPOff)

% PLOTTING ENVELOPE
x_coords        = [CG_empty(1), CG_all(1,:),CG_empty(1)]/totalLength;
x_coords_noPay  = [CG_empty(1), CG_all_noPay(1,1:3),CG_empty(1)]/totalLength;

y_coords        = [sumWeight_empty, weight_all, sumWeight_empty];
y_coords_noPay  = [sumWeight_empty, weight_all_noPay(1:3), sumWeight_empty];

fig3 = figure(7);
hold on
grid on
box on
grid minor

plot(x_coords,y_coords, 'r-', 'LineWidth', 1.2)
plot(x_coords_noPay,y_coords_noPay, 'b--', 'LineWidth', 1.2)
plot([xNPOff(1)/totalLength,xNPOff(1)/totalLength],[5*10^5,13*10^5],'g:', 'LineWidth', 2)
plot([xNPOff(4)/totalLength,xNPOff(4)/totalLength],[5*10^5,13*10^5],'m-.', 'LineWidth', 1.2)
legend('MTOW envelope',...
    'No payload envelope',...
    'x_{np} Take-off ','x_{np} Landing',...
    'Location','northwest','FontSize', 10);
title('CG envelope and Static Margin position across flight')
axis([0.4465 0.461 5*10^5 13*10^5])
xlabel('CG Position along Total Length [x/L]')
ylabel('Weight [N]')
%

fig3.Units = 'inches';   
fig3.Position(3) = 8;
fig3.Position(4) = 3;
set(fig3.Children, 'FontName', 'Arial', 'FontSize', 10);
print('CG_envelope', '-depsc')
hold off
%}
