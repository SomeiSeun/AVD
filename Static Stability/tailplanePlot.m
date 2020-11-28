function tailplanePlot(spanHoriz, heightVert, sweepHorizLE, sweepVertLE, cRootHoriz, cRootVert, cTipHoriz, cTipVert)
% plot made by connecting the four points for each trapezoidal wing section
% points are in the format [x-coord, y-coord]
% x-coord - chord-wise direction
% y-coord - span-wise direciton

%horizontal tailplane
rootLE{1} = [0;0];
tipLE{1} = [0.5*spanHoriz*tand(sweepHorizLE); 0.5*spanHoriz];
tipTE{1} = tipLE{1} + [cTipHoriz; 0];
rootTE{1} = rootLE{1} + [cRootHoriz; 0];

%vertical tailplane
rootLE{2} = [0;0];
tipLE{2} = [heightVert*tand(sweepVertLE); heightVert];
tipTE{2} = tipLE{2} + [cTipVert; 0];
rootTE{2} = rootLE{2} + [cRootVert; 0];

%plotting horizontal tailplane
fig1 = figure(1);
hold on
plot([rootLE{1}(1), tipLE{1}(1), tipTE{1}(1), rootTE{1}(1)], [rootLE{1}(2), tipLE{1}(2), tipTE{1}(2), rootTE{1}(2)], 'k-')
plot([rootLE{1}(1), tipLE{1}(1), tipTE{1}(1), rootTE{1}(1)], [rootLE{1}(2), -tipLE{1}(2), -tipTE{1}(2), rootTE{1}(2)], 'k-')
grid minor
title('Horizontal Tailplane Reference Planform')
xlabel('Chord-wise direction (m)')
ylabel('Span-wise direction (m)')
fig1.Units = 'normalized';
fig1.Position = [0.1 0.5 0.3 0.4];
axis equal


%plotting vertical tailplne
fig2 = figure(2);
hold on
plot([rootLE{2}(1), tipLE{2}(1), tipTE{2}(1), rootTE{2}(1)], [rootLE{2}(2), tipLE{2}(2), tipTE{2}(2), rootTE{2}(2)], 'b-')
grid minor
title('Vertical Tailplane Reference Planform')
xlabel('Chord-wise direction (m)')
ylabel('Span-wise direction (m)')
fig2.Units = 'normalized';
fig2.Position = [0.6 0.5 0.3 0.4];
axis equal
end