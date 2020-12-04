function [MainOleo, NoseOleo, LocationMainGearJoint, LocationNoseGearJoint, LengthMainGearDeployed, ...
    LengthMainGearRetracted, LengthNoseGearDeployed, LengthNoseGearRetracted, ...
    GroundClearanceFuselage, GroundClearanceEngine, NoseGearLoadRatio, LandingLoadRatio, ...
    AngleTailstrike, AngleTipback, AngleOverturn, NoseWheel, MainWheel, FrontalAreaNoseGear, FrontalAreaMainGear] ...
    = UndercarriageFunction2(fudge, W0, WFCumulative6, x_wingroot, z_wingroot, length_rootchord, ...
    theta_setting, theta_sweeprearspar, theta_dihedral, ...
    theta_maxground, chord_rearspar, length_aircraft, radius_fuselage, ...
    x_firsttailstrike, z_firsttailstrike, height_mgmax, length_mgmax, x_cgmin, x_cgmax, ...
    z_cg, y_enginestrike, z_enginestrike)

%% Undercarriage v2

%{
This code is an improved version which solves the issues that the previous
one left unnoticed. It should again be able to take inputs regarding
various different geometries and output (or warn the impossibility of) an
undercarriage that passes each constraint applied on it.
%}

grc_engine_min = 6*0.0254; % adding 6 inches of clearance. This should be the value that we have when standing still (loaded tire and oleo)

% Undercarriage assumptions
WNGRmin = 0.05;
WNGRmax = 0.20;

%% Initialise variables and arrays
x_ng = 0:0.01:length_aircraft;
y_mgjoint = 0:0.01:10;
haveUndercarriage = 0;

%% Loop 1: Picking lateral positions of landing gears

% Pick a y_mg and proceed
for i = 1:length(y_mgjoint)
    
    % Specify details
    disp(['Trying y_mg = ', num2str(y_mgjoint(i)), ':'])
    
    % Calculate x_mgjoint and z_mgjoint
    x_rearspar = x_wingroot + length_rootchord*(chord_rearspar - 0.25)*cosd(theta_setting);
    z_rearspar = z_wingroot - length_rootchord*(chord_rearspar - 0.25)*sind(theta_setting);
    x_mgjoint = x_rearspar + y_mgjoint(i)*( tand(theta_sweeprearspar)*cosd(theta_setting) + tand(theta_dihedral)*sind(theta_setting) );
    z_mgjoint = z_rearspar + y_mgjoint(i)*( -tand(theta_sweeprearspar)*sind(theta_setting) + tand(theta_dihedral)*cosd(theta_setting) );
    disp(['CG taken as ', num2str(x_cgmin)])
    disp(['Main gear joint xpos is therefore ', num2str(x_mgjoint)])
    disp(' ')
    
    % Find tricycle constraint
    x_ng_tricycle_less = x_mgjoint;
    disp(['Tricycle constraint: nose gear xpos less than ', num2str(x_ng_tricycle_less)])
    
    % Find min nose gear placement
    x_ng_place_more = 2;
    disp(['Min nose gear placement constraint: nose gear xpos more than ', num2str(x_ng_place_more)])
    
    % Find min nose gear load constraint
    x_ng_minload_more = (x_cgmax + (WNGRmin-1)*x_mgjoint)/WNGRmin;
    disp(['Min nose gear load constraint: nose gear xpos more than ', num2str(x_ng_minload_more)])
    
    % Find max nose gear load constraint
    x_ng_maxload_less = (x_cgmin + (WNGRmax-1)*x_mgjoint)/WNGRmax;
    disp(['Max nose gear load constraint: nose gear xpos less than ', num2str(x_ng_maxload_less)])
    
    % Find minimum ground clearance from tailstrike constraint
    grc_min_tailstrike = (x_firsttailstrike - x_mgjoint-fudge)*tand(theta_maxground) - z_firsttailstrike - radius_fuselage; %FUDGE DETAIL
    disp(['Tailstrike constraint: min ground clearance ', num2str(grc_min_tailstrike)])
    
    % Find minimum ground clearance from engine clearance constraint
    grc_min_engine = grc_engine_min - radius_fuselage - z_enginestrike;
    disp(['Engine constraint: min ground clearance ', num2str(grc_min_engine)])
    
    % Find maximum ground clearance from tipback constraint
    grc_max_tipback = ((x_mgjoint+fudge - x_cgmax)/(tand(theta_maxground))) - radius_fuselage - z_cg; %FUDGE DETAIL
    disp(['Tipback constraint: max ground clearance ', num2str(grc_max_tipback)])
    
    % Find maximum ground clearance from undercarriage max length
    grc_max_undercarriage_length = y_mgjoint(i) - z_mgjoint - radius_fuselage; % Keep in mind that the undercarriage height from this is the squished height not the retracted height
    disp(['Undercarriage fitting constraint: max ground clearance ', num2str(grc_max_undercarriage_length)])
    
    % Find the more constraining minima and maxima for ground clearance
    grc_min_most_constraining = max(grc_min_tailstrike, grc_min_engine); % was grc_min_engine
    grc_max_most_constraining = min(grc_max_tipback, grc_max_undercarriage_length);
    
    %% Condition 1: Check if ground clearance is possible
    
    % Check if ground clearance is possible
    if grc_min_most_constraining > grc_max_most_constraining
        
        % BAD
        disp('Ground clearance range not possible')
        haveUndercarriage = 0;
        % Exits into y_mg selection loop
        
    else
        
        % Define ground clearance limits
        % The second part ensures that the undercarriage isnt too long to
        % fit back into the fuselage
        % grc = grc_min_tailstrike:0.00001:min(grc_max_tipback, y_mgjoint(i)-z_mgjoint-radius_fuselage);
        
        % Find most constraining nose gear overturn due to max ground
        % clearance. This is the ground clearance we will choose for
        % further calculations. Make note that this value is almost exactly
        % equal to the minimum ground clearance available because the code
        % reached here from a direction where grcmin was larger than
        % grcmax. This means that if you've reached here, you've barely
        % just opened a margin for ground clearance to exist. Also we want
        % to pick maximum ground clearance possible in order to have the
        % best chance of fitting the engines in place.
        grc_chosen = grc_max_most_constraining; %OUTPUT
        h_cg = grc_chosen + radius_fuselage + z_cg; %OUTPUT
        a = (y_mgjoint(i)^2 * tand(63)^2) - (h_cg^2);
        b = (-2*x_cgmin*(y_mgjoint(i)^2)*(tand(63)^2)) - (-2*(x_mgjoint-fudge)*h_cg^2); % FUDGE
        c = (x_cgmin^2*y_mgjoint(i)^2*tand(63)^2) - (h_cg^2*(y_mgjoint(i)^2+(x_mgjoint-fudge)^2)); %FUDGE
        x_ng1 = (-b+sqrt(b^2-4*a*c))/(2*a);
        x_ng2 = (-b-sqrt(b^2-4*a*c))/(2*a);
        x_ng_overturn_less = min(x_ng1, x_ng2);
        disp(['Overturn constraint: nose gear xpos less than ', num2str(x_ng_overturn_less)])
        
        % Check if nose gear positioning is possible
        x_ng_least = max(x_ng_minload_more, x_ng_place_more);
        x_ng_most = min([x_ng_tricycle_less, x_ng_maxload_less, x_ng_overturn_less]);
        
        %% Condition 2: Check if nose gear placement is possible
        
        if x_ng_least > x_ng_most
            
            % BAD
            disp('Nose gear cannot be placed')
            haveUndercarriage = 0;
            % Exits into remainder of ground clearance available
            
        else
            
            x_ng = x_ng_least:0.1:x_ng_most; % technically goes to x_ng_most but not much point
            
            %% Loop 2: Picking nose gear longitudinal positions
            
            % Pick an x_ng and proceed
            for ii = 1:length(x_ng)
                
                disp(['Trying y_mg = ', num2str(y_mgjoint(i))])
                disp(['Trying x_ng = ', num2str(x_ng(ii))])
                % Calculate actual ground clearance achieved. This was the
                % source of the error. We didn't need to recalculate ground
                % clearance because it was set in place. The effect of this
                % is that we get a lower overturn angle instead which is
                % nice.
                %h_cg_actual = (y_mgjoint(i)*(x_cgmin-x_ng(ii))*tand(63)) / (sqrt(y_mgjoint(i)^2 + (x_mgjoint-x_ng(ii))^2));
                %grc_actual = h_cg-radius_fuselage-z_cg;
                                
                % Verification checks for constraints (just in case)
                disp(' ')
                disp('Landing gear potential placement found:')
                disp(['Nose gear placed at ', num2str(x_ng(ii))])
                disp(['Main gear placed at ', num2str(x_mgjoint)])
                disp(' ')
                disp('Verifying placement selection:')
                WNGR_actual = (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint); %OUTPUT
                disp(['Nose gear load ratio is ', num2str(WNGR_actual)])
                theta_tailstrike_actual = atand( (grc_chosen + radius_fuselage + z_firsttailstrike) / (x_firsttailstrike - x_mgjoint-fudge) ); %OUTPUT FUDGE FACTOR
                disp(['Tailstrike angle is ', num2str(theta_tailstrike_actual) ])
                theta_tipback_actual = atand( (x_mgjoint+fudge-x_cgmax)/h_cg ); %OUTPUT FUDGE FACTOR
                disp(['Tipback angle is ', num2str(theta_tipback_actual)])
                disp(['Ground clearance is ', num2str(grc_chosen)])
                theta_overturn_actual = atand( (h_cg*sqrt(y_mgjoint(i)^2+(x_mgjoint-fudge-x_ng(ii))^2))/(y_mgjoint(i)*(x_cgmin-x_ng(ii)))); %OUTPUT
                disp(['Overturn angle is ', num2str(theta_overturn_actual) ])
                disp(' ')
                
                % Calculate wheel loads
                [W_WheelMainGear, W_WheelNoseGear, W_DynamNoseGear, LbsReqMainGear, ...
                    LbsReqNoseGearStatic, LbsReqNoseGearDynamic] = WheelLoads(W0, x_ng(ii), ...
                    x_mgjoint, x_cgmin, x_cgmax, h_cg); %OUTPUT can take W_(...) because they are metric. the Lbs(...) are just unit converted for ease
                
                disp('Loads required to carry by landing gears:')
                disp(['Static load on nose gear is approx ', num2str(round(LbsReqNoseGearStatic)), ' lbs'])
                disp(['Dynamic load on nose gear is approx ', num2str(round(LbsReqNoseGearDynamic)), ' lbs'])
                disp(['Total load on nose gear is approx ', num2str(round(LbsReqNoseGearStatic + LbsReqNoseGearDynamic)), ' lbs'])
                disp(['Static load on main gear is approx ', num2str(round(LbsReqMainGear)), ' lbs'])
                
                % Pick tires
                [NoseWheel] = GimmeTires(LbsReqNoseGearStatic+LbsReqNoseGearDynamic, 300, 60); %OUTPUT
                [MainWheel] = GimmeTires(LbsReqMainGear, 200, length_mgmax*39.3700787/2); %OUTPUT
                disp(' ')
                disp('Nose wheel selected: ')
                disp(NoseWheel)
                disp('Main wheel selected: ')
                disp(MainWheel)
                
                % Calculate maximum width of main u/c (aka height in fus)
                y_mg_tire_dist_chosen = ((height_mgmax/2)*39.3700787) - (MainWheel.SectionWidthMaxINCH/2); %OUTPUT
                disp(['Maximum lateral distance between main gear tires is ', num2str(y_mg_tire_dist_chosen), ' inches'])
                
                % While you're at it calculate this too:
                x_mg_tire_dist_chosen = length_mgmax*39.3700787 - MainWheel.InflatedOuterDiamMaxINCH; %OUTPUT
                disp(['Maximum longitudinal distance between main gear tires is ', num2str(x_mg_tire_dist_chosen), ' inches'])
                
                % Check if this maximum distance is sufficient for engine
                % clearance.
                grc_engine_actual = grc_chosen + radius_fuselage + z_enginestrike; %OUTPUT
                y_outer = y_enginestrike - (grc_engine_actual/tand(5));
                
                %% Condition 3: Is 5 degree engine clearance available?
                
                if y_outer-y_mgjoint(i) > (y_mg_tire_dist_chosen*0.0254)
                    
                    % BAD
                    disp('Engine 5 degree clearance was not possible')
                    haveUndercarriage = 0;
                    
                else
                    
                    disp('Engine 5 degree clearance successful')
                    
                    % Calculate oleo sizes required
                    V_Vertical = 10; %ft/s
                    eta_oleo = 0.9; %nondim
                    eta_tire = 0.1; %nondim
                    N_g = 2.7; %taken as lower bound to give largest stroke
                    Stroke_tire_main = ((MainWheel.InflatedOuterDiamMinINCH/2) - MainWheel.StaticLoadedRadiusINCH)/12; %ft
                    Stroke_tire_nose = ((NoseWheel.InflatedOuterDiamMinINCH/2) - NoseWheel.StaticLoadedRadiusINCH)/12; %ft
                    
                    MainOleo = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire_main, W0*WFCumulative6, 2, 1-( (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint) )); %ft %OUTPUT
                    NoseOleo = GimmeAnOleo(V_Vertical, eta_oleo, eta_tire, N_g, Stroke_tire_nose, W0*WFCumulative6, 1, ( (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint) )); %ft %OUTPUT
                    
                    disp(['Nose gear oleo has length ', num2str(NoseOleo.TotalLength)])
                    disp(['Main gear oleo has length ', num2str(MainOleo.TotalLength)])
                    
                    %disp(['The height of nose gear (minus strut) required is approx ', num2str( (NoseOleo.TotalLength + NoseWheel.StaticLoadedRadiusINCH) * 0.0254 ), ' m'])
                    %disp(['The height of main gear (minus strut) required is approx ', num2str( (MainOleo.TotalLength + MainWheel.StaticLoadedRadiusINCH) * 0.0254 ), ' m'])
                    
                    %% Condition 4: Is undercarriage height (so far) required less than distance between ground and joint?
                    
                    if ((MainOleo.TotalLength + MainWheel.StaticLoadedRadiusINCH) * 0.0254) > grc_chosen + radius_fuselage + z_mgjoint
                        
                        % BAD
                        disp('Undercarriage size required exceeds distance from ground to joint')
                        haveUndercarriage = 0;
                        
                    else
                        
                        disp('Undercarriage fits between ground and joint')
                        
                        % Calculate strut length required, using static
                        % loaded tire and static loaded oleo. Still need to
                        % reach the joint height.
                        mg_strut_length = grc_min_most_constraining + radius_fuselage + z_mgjoint - (MainWheel.StaticLoadedRadiusINCH*0.0254) - ( (MainOleo.TotalLength - 0 ) * 0.0254 ); %OUTPUT
                        disp(['Main gear strut length required is ', num2str(mg_strut_length)])
                        mg_deployed_total_length = mg_strut_length + (MainWheel.StaticLoadedRadiusINCH*0.0254) + ( (MainOleo.TotalLength - 0 ) * 0.0254 ); %OUTPUT % instead of zero this should really be (MainOleo.Stroke*(2/3))
                        mg_retracted_total_length = mg_strut_length + (MainWheel.InflatedOuterDiamMaxINCH*0.0254) + (MainOleo.TotalLength*0.0254); %OUTPUT
                        
                        %% Condition 5: Can undercarriage fit into retraction bay
                        
                        if mg_retracted_total_length > y_mgjoint(i)
                            
                            % BAD
                            disp('Undercarriage would not fit laterally into retraction bay')
                            haveUndercarriage = 0;
                            
                        else
                            
                            disp('Undercarriage fits laterally into retraction bay')
                            
                            %% Condition 6: Do your ACN numbers work with chosen PCN numbers?
                            
                            % For now assume yes and move on
                            
                            % If you have reached this region of code, you
                            % have been successful in meeting the tricycle,
                            % WNGRmin, WNGRmax, wing jointed constraints on
                            % the nose and main gears. You have also met
                            % tailstrike, tipback, undercarriage size,
                            % engine clearance constraints on ground
                            % clearance. You were then able to pick a nose
                            % gear position because you weren't constrained
                            % away. You also passed 5 degree engine
                            % clearance and confirmed that the required
                            % main gear sizes aren't too large. Your ACN
                            % numbers are okay. Life is good. Undercarriage
                            % is sized.
                            
                            % Finalise the undercarriage
                            % To break out of outer nested loop
                            haveUndercarriage = 1;
                            % Break out of this loop
                            break
                        end
                        
                    end
                    
                end
                
            end
            %% \Loop 2: Picking nose gear longitudinal positions
            % You will enter this region of code if:
                % a) You picked a y_mg and also a x_ng which passed all
                % required conditions. This led you to recieve a working
                % undercarriage, with your haveUndercarriage boolean set to
                % "1". You're all set to start producing final outputs.
                % b) You exhausted all x_ng positions without success for
                % this particular y_mg. 
            % Lets add a quick checkpoint here
            if haveUndercarriage == 0;
                
                disp('Your search for a working x_ng for this value of y_mg failed')
            end
        end
        %% \Condition 2: Check if nose gear placement is possible
        % You will enter this region of code if:
            % a) Successful (haveUndercarriage = 1)
            % b) Nose gear placement was not possible (haveUndercarriage =
            % 0)
        % Lets add another quick checkpoint here
        if haveUndercarriage == 0;
            
            disp('You were not able to place a nose gear')
        end
    end
    %% \Condition 1: Check if ground clearance is possible
    % You will enter this region of code if:
        % a) Successful (haveUndercarriage = 1)
        % b) Ground clearance limits were not possible (haveUndercarriage =
        % 0)
    % Lets add yet another quick checkpoint here
    if haveUndercarriage == 0;
        
        disp('Your ground clearances were not possible')
        disp(' ')
    else haveUndercarriage == 1;
        disp('Final undercarriage placement successful')  
        break
    end
    %pause(0.005)
    clc
end
%% \Loop 1: Picking lateral positions of landing gears
% You will enter this region of code if:
    % a) Successful (haveUndercarriage = 1)
    % b) You exhausted all y_mg positions for these inputs
    % (haveUndercarriage = 0). In this case we need to throw an error as an
    % output requesting a revisit for the inputs themselves.
% Lets add one final checkpoint
if haveUndercarriage == 0;
    clc
    disp('Inputs prevent an undercarriage from being physically possible')
else haveUndercarriage == 1;
    disp('Closing all loops')
    disp('Now proceeding towards making a good usable set of outputs')
end

%% Outputs required

if haveUndercarriage == 0
    
    LocationMainGearJoint = [100,100,100]';
    LocationNoseGearJoint = [100,100,100]';
    
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

%% Workspace cleanup
% clear a b c chord_rearspar eta_oleo eta_tire grc_engine_min grc_max_tipback
% clear grc_max_undercarriage_length grc_min_engine grc_min_tailstrike
% clear haveUndercarriage height_mgmax length_aircraft length_mgmax length_rootchord
% clear N_g Stroke_tire_main Stroke_tire_nose theta_dihedral theta_maxground 
% clear theta_setting theta_sweeprearspar V_Vertical W0 WF1 WF2 WF3 WF4 WF5 WF6
% clear WNGRmax WNGRmin x_cgmax x_cgmin x_firsttailstrike x_ng x_ng1 x_ng2
% clear x_ng_least x_ng_maxload_less x_ng_minload_more x_ng_most x_ng_overturn_less
% clear x_ng_place_more x_ng_tricycle_less x_rearspar x_wingroot y_enginestrike
% clear y_mgjoint y_outer y_tire_dist_max z_cg z_enginestrike 
% clear z_firsttailstrike z_rearspar z_wingroot grc_max_most_constraining grc_min_most_constraining

end