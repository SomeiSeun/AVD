function [MainOleo, NoseOleo, LocationMainGearJoint, LocationNoseGearJoint, LengthMainGearDeployed, ...
    LengthMainGearRetracted, LengthNoseGearDeployed, LengthNoseGearRetracted, ...
    GroundClearanceFuselage, GroundClearanceEngine, NoseGearLoadRatio, LandingLoadRatio, ...
    AngleTailstrike, AngleTipback, AngleOverturn, NoseWheel, MainWheel, FrontalAreaNoseGear, FrontalAreaMainGear] ...
    = UndercarriageFunction(W0, WFCumulative6, x_wingroot, z_wingroot, length_rootchord, ...
    theta_setting, theta_sweeprearspar, theta_dihedral, ...
    theta_maxground, chord_rearspar, length_aircraft, radius_fuselage, ...
    x_firsttailstrike, z_firsttailstrike, height_mgmax, length_mgmax, x_cgmin, x_cgmax, ...
    z_cg, y_enginestrike, z_enginestrike)

% This is the function-ified version of the undercarriage script.

%% Request inputs

% Initial sizing code
%load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF1', 'WF2', 'WF3', 'WF4', 'WF5', 'WF6')

% Wing design / aerodynamics
%x_wingroot = 29;
%z_wingroot = -2.1354937213;
%length_rootchord = 7.4505;
%theta_setting = 2.28;
%theta_sweeprearspar = 24.3048;
%theta_dihedral = 5;
%theta_maxground = 15;
%chord_rearspar = 0.60;

% Fuselage
%length_aircraft = 60;
%radius_fuselage = 2.0879;
%x_firsttailstrike = 42.38;
%z_firsttailstrike = -2.0879;
%height_mgmax = 1.5;
%length_mgmax = 3;

% Weight and balance
%x_cgmin = 28;
%x_cgmax = 29;
%z_cg = 0.1;

% Engine
%y_enginestrike = 8.1824;
%z_enginestrike = -5.5591;
grc_engine_min = 6*0.0254; % adding 6 inches of clearance. This should be the value that we have when standing still (loaded tire and oleo)

% Undercarriage assumptions
WNGRmin = 0.05;
WNGRmax = 0.20;

%% Initialise variables and arrays
x_ng = 0:0.001:length_aircraft;
y_mgjoint = 0:0.1:10;
haveUndercarriage = 0;

%% Loop 1: Picking lateral positions of landing gears

% Pick a y_mg and proceed
for i = 1:length(y_mgjoint)
    
    % Calculate x_mgjoint and z_mgjoint
    x_rearspar = x_wingroot + length_rootchord*(chord_rearspar - 0.25)*cosd(theta_setting);
    z_rearspar = z_wingroot - length_rootchord*(chord_rearspar - 0.25)*sind(theta_setting);
    x_mgjoint = x_rearspar + y_mgjoint(i)*( tand(theta_sweeprearspar)*cosd(theta_setting) + tand(theta_dihedral)*sind(theta_setting) );
    z_mgjoint = z_rearspar + y_mgjoint(i)*( -tand(theta_sweeprearspar)*sind(theta_setting) + tand(theta_dihedral)*cosd(theta_setting) );
    
    % Find tricycle constraint
    x_ng_tricycle_less = x_mgjoint;
    
    % Find min nose gear placement
    x_ng_place_more = 2;
    
    % Find min nose gear load constraint
    x_ng_minload_more = (x_cgmax + (WNGRmin-1)*x_mgjoint)/WNGRmin;
    
    % Find max nose gear load constraint
    x_ng_maxload_less = (x_cgmin + (WNGRmax-1)*x_mgjoint)/WNGRmax;
    
    % Find minimum ground clearance from tailstrike constraint
    grc_min_tailstrike = (x_firsttailstrike - x_mgjoint -1.5)*tand(theta_maxground) - z_firsttailstrike - radius_fuselage; %Fudge factor
    
    % Find minimum ground clearance from engine clearance constraint
    grc_min_engine = grc_engine_min - radius_fuselage - z_enginestrike;
    
    % Find maximum ground clearance from tipback constraint
    grc_max_tipback = ((x_mgjoint + 1.5  - x_cgmax)/(tand(theta_maxground))) - radius_fuselage - z_cg; %Fudge factor
    
    % Find maximum ground clearance from undercarriage max length
    grc_max_undercarriage_length = y_mgjoint(i) - z_mgjoint - radius_fuselage;
    
    % Find the more constraining minima and maxima for ground clearance
    grc_min_most_constraining = max(grc_min_tailstrike, grc_min_engine);
    grc_max_most_constraining = min(grc_max_tipback, grc_max_undercarriage_length);
    
    %% Condition 1: Check if ground clearance is possible
    
    % Check if ground clearance is possible
    if grc_min_most_constraining > grc_max_most_constraining
        
        haveUndercarriage = 0;
        
    else
        
        % Define ground clearance limits
        grc_chosen = grc_max_most_constraining; %OUTPUT
        h_cg = grc_chosen + radius_fuselage + z_cg; %OUTPUT
        a = (y_mgjoint(i)^2 * tand(63)^2) - (h_cg^2);
        b = (-2*x_cgmin*(y_mgjoint(i)^2)*(tand(63)^2)) - (-2*x_mgjoint*h_cg^2);
        c = (x_cgmin^2*y_mgjoint(i)^2*tand(63)^2) - (h_cg^2*(y_mgjoint(i)^2+x_mgjoint^2));
        x_ng1 = (-b+sqrt(b^2-4*a*c))/(2*a);
        x_ng2 = (-b-sqrt(b^2-4*a*c))/(2*a);
        x_ng_overturn_less = min(x_ng1, x_ng2);
        
        % Check if nose gear positioning is possible
        %clc
        x_ng_least = max(x_ng_minload_more, x_ng_place_more);
        x_ng_most = min([x_ng_tricycle_less, x_ng_maxload_less, x_ng_overturn_less]);
        %pause(0.05)
        
        %% Condition 2: Check if nose gear placement is possible
        
        if x_ng_least > x_ng_most
            
            haveUndercarriage = 0;
            
        else
            
            x_ng = x_ng_least:0.1:x_ng_most; % technically goes to x_ng_most but not much point
            
            %% Loop 2: Picking nose gear longitudinal positions
            
            % Pick an x_ng and proceed
            for ii = 1:length(x_ng)
                
                WNGR_actual = (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint); %OUTPUT
                theta_tailstrike_actual = atand( (grc_chosen + radius_fuselage + z_firsttailstrike) / (x_firsttailstrike - x_mgjoint - 1.5) ); %OUTPUT
                theta_tipback_actual = atand( (x_mgjoint + 1.5 -x_cgmax)/h_cg ); %OUTPUT
                theta_overturn_actual = atand( (h_cg*sqrt(y_mgjoint(i)^2+(x_mgjoint-x_ng(ii))^2))/(y_mgjoint(i)*(x_cgmin-x_ng(ii)))); %OUTPUT
                
                % Calculate wheel loads
                [~, ~, ~, LbsReqMainGear, ...
                    LbsReqNoseGearStatic, LbsReqNoseGearDynamic] = WheelLoads(W0, x_ng(ii), ...
                    x_mgjoint, x_cgmin, x_cgmax, h_cg); %OUTPUT can take W_(...) because they are metric. the Lbs(...) are just unit converted for ease
                
                % Pick tires
                [NoseWheel] = GimmeTires(LbsReqNoseGearStatic+LbsReqNoseGearDynamic, 500, 60); %OUTPUT
                [MainWheel] = GimmeTires(LbsReqMainGear, 200, length_mgmax*39.3700787/2); %OUTPUT
                
                
                % Calculate maximum width of main u/c (aka height in fus)
                y_mg_tire_dist_chosen = ((height_mgmax/2)*39.3700787) - (MainWheel.SectionWidthMaxINCH/2); %OUTPUT
                
                % While you're at it calculate this too:
                %x_mg_tire_dist_chosen = length_mgmax*39.3700787 - MainWheel.InflatedOuterDiamMaxINCH; %OUTPUT
                
                % Check if this maximum distance is sufficient for engine
                % clearance.
                grc_engine_actual = grc_chosen + radius_fuselage + z_enginestrike; %OUTPUT
                y_outer = y_enginestrike - (grc_engine_actual/tand(5));
                
                %% Condition 3: Is 5 degree engine clearance available?
                
                if y_outer-y_mgjoint(i) > (y_mg_tire_dist_chosen*0.0254)
                    
                    haveUndercarriage = 0;
                    
                else
                    
                    % Calculate oleo sizes required
                    V_Vertical = 10; %ft/s
                    eta_oleo = 0.9; %nondim
                    eta_tire = 0.1; %nondim
                    N_g = 2.7; %taken as lower bound to give largest stroke
                    Stroke_tire_main = ((MainWheel.InflatedOuterDiamMinINCH/2) - MainWheel.StaticLoadedRadiusINCH)/12; %ft
                    Stroke_tire_nose = ((NoseWheel.InflatedOuterDiamMinINCH/2) - NoseWheel.StaticLoadedRadiusINCH)/12; %ft
                    
                    MainOleo = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire_main, W0*WFCumulative6, 2, 1-( (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint) )); %ft %OUTPUT
                    NoseOleo = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire_nose, W0*WFCumulative6, 1, ( (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint) )); %ft %OUTPUT
                    
                    %% Condition 4: Is undercarriage height (so far) required less than distance between ground and joint?
                    
                    if ((MainOleo.TotalLength + MainWheel.StaticLoadedRadiusINCH) * 0.0254) > grc_chosen + radius_fuselage + z_mgjoint
                        
                        haveUndercarriage = 0;
                        
                    else
                        
                        % Calculate strut length required, using static
                        % loaded tire and static loaded oleo. Still need to
                        % reach the joint height.
                        mg_strut_length = grc_min_most_constraining + radius_fuselage + z_mgjoint - (MainWheel.StaticLoadedRadiusINCH*0.0254) - ( (MainOleo.TotalLength - 0 ) * 0.0254 ); %OUTPUT
                        mg_deployed_total_length = mg_strut_length + (MainWheel.StaticLoadedRadiusINCH*0.0254) + ( (MainOleo.TotalLength - 0 ) * 0.0254 ); %OUTPUT % instead of zero this should really be (MainOleo.Stroke*(2/3))
                        mg_retracted_total_length = mg_strut_length + (MainWheel.InflatedOuterDiamMaxINCH*0.0254) + (MainOleo.TotalLength*0.0254); %OUTPUT
                        
                        %% Condition 5: Can undercarriage fit into retraction bay
                        
                        if mg_retracted_total_length > y_mgjoint(i)
                            
                            haveUndercarriage = 0;
                            
                        else
                            
                            %% Condition 6: Do your ACN numbers work with chosen PCN numbers?
                            
                            % For now assume yes and move on
                            % Finalise the undercarriage
                            % To break out of outer nested loop
                            haveUndercarriage = 1;
                            % Break out of this loop
                            break
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

if haveUndercarriage == 0
    
    LocationMainGearJoint = 0;
    LocationNoseGearJoint = 0;
    
    LengthMainGearDeployed = 0;
    LengthMainGearRetracted = 0;
    LengthNoseGearDeployed = 0;
    LengthNoseGearRetracted = 0;
    
    GroundClearanceFuselage = 0;
    GroundClearanceEngine = 0;
    
    NoseGearLoadRatio = 0;
    LandingLoadRatio = 0;
    
    AngleTailstrike = 0;
    AngleTipback = 0;
    AngleOverturn = 0;
    
    FrontalAreaNoseGear = 0;
    FrontalAreaMainGear = 0;
    NoseWheel = 0;
    MainWheel = 0;
    
    disp('Undercarriage was not possible using current inputs')
    disp('Bruh')

else
    %% Outputs
    LocationMainGearJoint = [x_mgjoint, y_mgjoint(i), z_mgjoint]';
    LocationNoseGearJoint = [x_ng(ii), 0, z_mgjoint]';
    
    LengthMainGearDeployed = mg_deployed_total_length;
    LengthMainGearRetracted = mg_retracted_total_length;
    LengthNoseGearDeployed = mg_deployed_total_length;
    LengthNoseGearRetracted = mg_retracted_total_length;
    
    GroundClearanceFuselage = grc_chosen;
    GroundClearanceEngine = grc_engine_actual;
    
    NoseGearLoadRatio = WNGR_actual;
    LandingLoadRatio = N_g;
    
    AngleTailstrike = theta_tailstrike_actual;
    AngleTipback = theta_tipback_actual;
    AngleOverturn = theta_overturn_actual;
    
    FrontalAreaNoseGear = (NoseOleo.Diameter*0.0254*mg_retracted_total_length) + ...
        2*(NoseWheel.InflatedOuterDiamMaxINCH*0.0254*NoseWheel.SectionWidthMaxINCH*0.0254);
    FrontalAreaMainGear = (MainOleo.Diameter*0.0254*mg_retracted_total_length) + ...
        2*(MainWheel.InflatedOuterDiamMaxINCH*0.0254*MainWheel.SectionWidthMaxINCH*0.0254);
end
end