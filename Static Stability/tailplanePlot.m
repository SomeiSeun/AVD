function tailplanePlot(vertRootLE, cRootVert, xnp, sweepVertRudder, sweepVertTE, heightVert, CG, wingPlanform, horizPlanform, vertPlanform, aftLength, mainLength, frontLength, fusDiamOuter, aftDiameter)

totalLength = aftLength + mainLength + frontLength;

theta = linspace(0, pi, 100);
frontCoords(2,:) = 0.5*fusDiamOuter*cos(theta);
frontCoords(1,:) = frontLength*sin(theta);

%plotting top view
fig1 = figure(1);
hold on
plot([frontLength, frontLength+mainLength], [fusDiamOuter/2, fusDiamOuter/2], 'k-')%fuselage main
plot([frontLength, frontLength+mainLength], [-fusDiamOuter/2, -fusDiamOuter/2], 'k-')%fuselage main
plot([frontLength+mainLength, totalLength, totalLength, frontLength+mainLength],...
    [fusDiamOuter/2, aftDiameter/2, -aftDiameter/2, -fusDiamOuter/2], 'k-'); %fuselage aft
plot(frontLength - frontCoords(1,:), frontCoords(2,:), 'k-') %fuselage front
plot(horizPlanform(1,:), horizPlanform(2,:), 'b-') %starboard horizontal stabiliser
plot(horizPlanform(1,:), [horizPlanform(2,1), -horizPlanform(2,2), -horizPlanform(2,3), horizPlanform(2,4)], 'b-') %port horizontal stabiliser
plot(wingPlanform(1,:), wingPlanform(2,:), 'k-') %staring wing
plot(wingPlanform(1,:), [wingPlanform(2,1), -wingPlanform(2,2), -wingPlanform(2,3), wingPlanform(2,4)], 'k-') %port wing
plot(vertPlanform(1,:), vertPlanform(2,:), 'r-') %vertical tail
plot(CG(1),CG(2),'bo')
plot(xnp(1),CG(2),'ro')
grid minor
title('Reference Lifting Surfaces - Top View')
xlabel('x-direction (m)')
ylabel('y-direction (m)')
fig1.Units = 'normalized';
fig1.Position = [0 0.05 0.5 0.85];
axis equal
hold off

%plotting side view
fig2 = figure(2);
hold on
plot([frontLength, frontLength+mainLength], [fusDiamOuter/2, fusDiamOuter/2], 'k-')%fuselage main
plot([frontLength, frontLength+mainLength], [-fusDiamOuter/2, -fusDiamOuter/2], 'k-')%fuselage main
plot([frontLength+mainLength, totalLength, totalLength, frontLength+mainLength],...
    [fusDiamOuter/2, fusDiamOuter/2, fusDiamOuter/2-aftDiameter, -fusDiamOuter/2], 'k-'); %fuselage aft
plot(frontLength - frontCoords(1,:), frontCoords(2,:), 'k-') %fuselage front
plot(horizPlanform(1,:), horizPlanform(3,:), 'k-') %wing
plot(wingPlanform(1,:), wingPlanform(3,:), 'k-') %horizontal stabiliser
plot(vertPlanform(1,:), vertPlanform(3,:), 'r-') %vertical tail
plot([horizPlanform(1,1), horizPlanform(1,1)+12*cosd(60)], [horizPlanform(3,1), horizPlanform(3,1)+12*sind(60)], 'm:') %60 degree line
plot([horizPlanform(1,4), horizPlanform(1,4)+5*cosd(30)], [horizPlanform(3,4), horizPlanform(3,4)+5*sind(30)], 'm:') %30 degree line
plot(CG(1),CG(3),'bo')
plot(xnp(1),CG(3),'ro')
plot([vertRootLE(1) + cRootVert + 0.05*heightVert*tand(sweepVertTE),...
    vertRootLE(1) + 0.8*cRootVert + 0.05*heightVert*tand(sweepVertRudder),...
    vertRootLE(1) + 0.8*cRootVert + 0.95*heightVert*tand(sweepVertRudder),...
    vertRootLE(1) + cRootVert + 0.95*heightVert*tand(sweepVertTE)],...
    [vertRootLE(3) + 0.05*heightVert, vertRootLE(3) + 0.05*heightVert,...
    vertRootLE(3) + 0.95*heightVert, vertRootLE(3) + 0.95*heightVert], 'k-')
grid minor
title('Reference Lifting Surfaces - Side View')
xlabel('x-direction (m)')
ylabel('z-direction (m)')
fig2.Units = 'normalized';
fig2.Position = [0.5 0.5 0.5 0.4];
axis equal
hold off

%plotting front view
fig3 = figure(3);
hold on
plot(fusDiamOuter/2*cos(2*theta), fusDiamOuter/2*sin(2*theta), 'k-') %fuselage main
plot(horizPlanform(2,:), horizPlanform(3,:), 'k-') %starboard horizontal stabiliser
plot([horizPlanform(2,1), -horizPlanform(2,2), -horizPlanform(2,3), horizPlanform(2,4)], horizPlanform(3,:), 'b-') %port horizontal stabiliser
plot(wingPlanform(2,:), wingPlanform(3,:), 'k-') %staring wing
plot([wingPlanform(2,1), -wingPlanform(2,2), -wingPlanform(2,3), wingPlanform(2,4)], wingPlanform(3,:), 'k-') %port wing
plot(vertPlanform(2,:), vertPlanform(3,:), 'r-') %vertical tail
plot(CG(2),CG(3),'bo')
grid minor
title('Reference Lifting Surfaces - Front View')
xlabel('y-direction (m)')
ylabel('z-direction (m)')
fig3.Units = 'normalized';
fig3.Position = [0.5 0.05 0.5 0.4];
axis equal
hold off
end

