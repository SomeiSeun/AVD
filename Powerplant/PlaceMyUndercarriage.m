function[x_NoseGear, x_MainGear] = PlaceMyUndercarriage(x_cg_max, x_cg_min, z_cg_max, Length_ac, W_NoseGear_Ratio_Max, W_NoseGear_Ratio_Min, x_ng_min, x_fuse_tapers, AoA_liftoff, AoA_landing, ground_clearance, overturn_angle, y_mg_max, x_mgjoint_min, x_mgjoint_max)
% This function is created in order to clean up the "main" undercarriage
% script. It takes in the assumed inputs and calculates the appropriate
% locations of the nose and main gears.

% Initialising arrays to use as axes in constraint space
x_mg = 0:0.001:Length_ac;                                                       
x_ng = 0:0.001:Length_ac;

% Calculate constraining arrays using the formulae available
x_ng_min = zeros(1, length(x_mg)) + x_ng_min;                                                                                   % For foremost nose gear position
x_mgjoint_min = x_mgjoint_min + zeros(1, length(x_mg));                                                                         % For ensuring main gear is placed on spar
x_mgjoint_max = x_mgjoint_max + zeros(1, length(x_mg));                                                                         % For ensuring main gear is placed on spar
Const_Max_NoseGearRatio = (x_cg_min - x_mg + W_NoseGear_Ratio_Max .* x_mg)./W_NoseGear_Ratio_Max;                               % For the maximum possible nose gear load, consider the foremost cg position
Const_Min_NoseGearRatio = (x_cg_max - x_mg + W_NoseGear_Ratio_Min .* x_mg)./W_NoseGear_Ratio_Min;                               % For the minimum possible nose gear load, consider the aftmost cg position
x_mg_min = zeros(1, length(x_mg)) + x_fuse_tapers - ground_clearance/(tand(max([AoA_liftoff, AoA_landing])));                   % For preventing tailstrike due to liftoff or landing angles
x_mg_min2 = zeros(1, length(x_mg)) + tand(max([AoA_liftoff, AoA_landing]))*z_cg_max + x_cg_max;                                 % For preventing tipping the CG back too far when rotating to liftoff
x_overturnpos = real(sqrt((((y_mg_max*tand(overturn_angle))^2 .* (x_cg_min - x_ng).^2)./(z_cg_max^2)) - y_mg_max^2) + x_ng);    % For preventing overturn
x_overturnneg = real(-sqrt((((y_mg_max*tand(overturn_angle))^2 .* (x_cg_min - x_ng).^2)./(z_cg_max^2)) - y_mg_max^2) + x_ng);   % For preventing overturn
Const_OptimumNoseGearRatio = (x_cg_max - x_mg + 0.08 .* x_mg)./0.08;                                                            % For calculating "optimum" x positions of nose and main gear

% Trying what happens when you try and equate the wheel loads
% x_ng_WWMGequalsWWNG_MaxCG = 5*x_cg_max - 4.*x_mg;
% x_ng_WWMGequalsWWNG_MinCG = 5*x_cg_min - 4.*x_mg;
% x_mg_WWNGequalsWDNG_maxCG = 0.1770138042*z_cg_max + x_cg_max + zeros(1, length(x_mg));
% x_mg_WWNGequalsWDNG_minCG = 0.1770138042*z_cg_max + x_cg_min + zeros(1, length(x_mg));
% x_ng_WWMGequalsWDNG_maxCG = x_cg_max - 0.7080552167*z_cg_max + zeros(1, length(x_mg));
% x_ng_WWMGequalsWDNG_minCG = x_cg_min - 0.7080552167*z_cg_max + zeros(1, length(x_mg));

% Plotting constraint space
figure(1)
plot(x_mg, x_ng, '--r', 'LineWidth', 1.5)                                                                                       % For ensuring tricycle configuration
hold on
plot(x_mgjoint_min, x_ng, '--k', 'LineWidth', 1.5)
plot(x_mgjoint_max, x_ng, '--k', 'LineWidth', 1.5)
plot(x_mg, x_ng_min, '--g', 'LineWidth', 1.5)
plot(x_mg, Const_Min_NoseGearRatio, '--b', 'LineWidth', 1.5)
plot(x_mg, Const_Max_NoseGearRatio, '--c', 'LineWidth', 1.5)
plot(x_mg_min, x_ng, '--y', 'LineWidth', 1.5)
plot(x_mg_min2, x_ng, '--m', 'LineWidth', 1.5)
plot(x_overturnpos, x_ng, '--k', 'LineWidth', 1.5)
plot(x_overturnneg, x_ng, '--k', 'LineWidth', 1.5)
plot(x_mg, Const_OptimumNoseGearRatio, ':', 'LineWidth', 2)

% Plotting trials
% plot(x_mg, x_ng_WWMGequalsWWNG_MinCG, ':', 'LineWidth', 1)
% plot(x_mg, x_ng_WWMGequalsWWNG_MaxCG, ':', 'LineWidth', 1)
% plot(x_mg_WWNGequalsWDNG_minCG, x_ng, ':', 'LineWidth', 1)
% plot(x_mg_WWNGequalsWDNG_maxCG, x_ng, ':', 'LineWidth', 1)
% plot(x_mg, x_ng_WWMGequalsWDNG_minCG, ':', 'LineWidth', 1)
% plot(x_mg, x_ng_WWMGequalsWDNG_maxCG, ':', 'LineWidth', 1)

% Graph settings
legend('Tricycle arrangement (stay below)', 'Spar', 'Spar', 'Foremost nose gear placement (stay above)', 'Minimum nose gear load (stay right)', ...
     'Maximum nose gear load (stay left)', 'Tailstrike prevention (stay right)', 'CG tipback prevention (stay right)', ...
     'Overturn prevention (stay within cone)', 'Overturn prevention (stay within cone)', 'Common (8%) load on nose gear')
xlim([0 Length_ac])
ylim([0 Length_ac])
xlabel('Main gear x position')
ylabel('Nose gear x position')
grid on
axis equal
hold off

% Design point selection

% Once the constraint space is plotted, the immediate next step is to
% select the "design point" which would provide the relative geometry of
% the undercarriage and help calculate loads.

% As a rough guide, it is known that the nose gear should carry around 8%
% of the MTOW. To prepare the constraint space, we plotted for a range of
% MTOW that are acceptable. One way to simplify the problem would be to
% plot another line at 8% MTOW and take its intersection point with the
% foremost nose gear placement line. This essentially means that we put the
% nose gear as forward as possible and accordingly place the main gear
% assuming the 8% figure.

x_NoseGear = x_ng_min(1);
x_MainGear = x_mg(abs(Const_OptimumNoseGearRatio-x_NoseGear) == min(abs(Const_OptimumNoseGearRatio-x_NoseGear)));
end