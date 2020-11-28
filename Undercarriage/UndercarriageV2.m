%% Undercarriage v2

%{
This code is an improved version which solves the issues that the previous
one left unnoticed. It should again be able to take inputs regarding
various different geometries and output (or warn the impossibility of) an
undercarriage that passes each constraint applied on it.
%}

%% Housekeeping
clear
clc
close all

%% Request inputs

% Initial sizing code
load('../Initial Sizing/InitialSizing.mat', 'W0', 'WF6')

% Wing design / aerodynamics
x_wingroot = 29;
z_wingroot = -2.1354937213;
length_rootchord = 7.4505;
theta_setting = 2.2;
theta_sweeprearspar = 24.3048;
theta_dihedral = 5;
theta_maxground = 15;
chord_rearspar = 0.60;

% Fuselage
length_aircraft = 60;
radius_fuselage = 2.35;
x_firsttailstrike = 42.38;
z_firsttailstrike = -2.09;
height_mgmax = 2;
length_mgmax = 4;

% Weight and balance
x_cgmin = 28;
x_cgmax = 29;
z_cg = 0.1;

% Undercarriage assumptions
WNGRmin = 0.05;
WNGRmax = 0.20;

%% Initialise variables and arrays
x_ng = 0:0.001:length_aircraft;
x_mg = 0:0.001:length_aircraft;
y_mgjoint = 0:0.001:10;

%% Loop

error = 1;

% Pick a y_mg and proceed
for i = 1:length(y_mgjoint)
    
    % Specify details
    disp(['Trying y_mg = ', num2str(y_mgjoint(i)), ':'])
    
    % Calculate x_mgjoint and z_mgjoint
    x_rearspar = x_wingroot + length_rootchord*(chord_rearspar - 0.25)*cosd(theta_setting);
    z_rearspar = z_wingroot - length_rootchord*(chord_rearspar - 0.25)*sind(theta_setting);
    x_mgjoint = x_rearspar + y_mgjoint(i)*( tand(theta_sweeprearspar)*cosd(theta_setting) + tand(theta_dihedral)*sind(theta_setting) );
    z_mgjoint = z_rearspar + y_mgjoint(i)*( -tand(theta_sweeprearspar)*sind(theta_setting) + tand(theta_dihedral)*cosd(theta_setting) );
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
    grc_min = (x_firsttailstrike - x_mgjoint)*tand(theta_maxground) - z_firsttailstrike - radius_fuselage;
    disp(['Tailstrike constraint: min ground clearance ', num2str(grc_min)])
    
    % Find maximum ground clearance from tipback constraint
    grc_max = ((x_mgjoint - x_cgmax)/(tand(theta_maxground))) - radius_fuselage - z_cg;
    disp(['Tipback constraint: max ground clearance ', num2str(grc_max)])
    
    % Check if ground clearance is possible
    if grc_min > min(grc_max, y_mgjoint(i) + z_mgjoint)
        
        disp('Gear will be too large to fit in fuselage')
        pause(0.0001)
        clc
        
    else
        % Define ground clearance limits
        grc = grc_min:0.001:min(grc_max, y_mgjoint(i)+z_mgjoint);
        
        % Find most constraining nose gear overturn due to max ground clearance
        h_cg = max(grc) + radius_fuselage + z_cg;
        a = (y_mgjoint(i)^2 * tand(63)^2) - (h_cg^2);
        b = (-2*x_cgmin*(y_mgjoint(i)^2)*(tand(63)^2)) - (-2*x_mgjoint*h_cg^2);
        c = (x_cgmin^2*y_mgjoint(i)^2*tand(63)^2) - (h_cg^2*(y_mgjoint(i)^2+x_mgjoint^2));
        x_ng1 = (-b+sqrt(b^2-4*a*c))/(2*a);
        x_ng2 = (-b-sqrt(b^2-4*a*c))/(2*a);
        x_ng_overturn_less = min(x_ng1, x_ng2);
        disp(['Overturn constraint: nose gear xpos less than ', num2str(x_ng_overturn_less)])
        
        % Check if nose gear positioning is possible
        x_ng_least = max(x_ng_minload_more, x_ng_place_more);
        x_ng_most = min([x_ng_tricycle_less, x_ng_maxload_less, x_ng_overturn_less]);
        
        if x_ng_least > x_ng_most
            
            disp('Nose gear cannot be placed')
            pause(0.001)
            clc
            
        else
            
            x_ng = x_ng_least:0.001:x_ng_most;
            
            % Pick an x_ng and proceed
            for ii = 1:length(x_ng)
                
                % Calculate actual ground clearance achieved
                h_cg = (y_mgjoint(i)*(x_cgmin-x_ng(ii))*tand(63)) / (sqrt(y_mgjoint(i)^2 + (x_mgjoint-x_ng(ii))^2));
                grc_actual = h_cg-radius_fuselage-z_cg;
                                
                % Verification checks for constraints (just in case)
                disp(' ')
                disp('Landing gear potential placement found:')
                disp(['Nose gear placed at ', num2str(x_ng(ii))])
                disp(['Main gear placed at ', num2str(x_mgjoint)])
                disp(' ')
                disp('Verifying placement selection:')
                disp(['Nose gear load ratio is ', num2str( (((x_cgmax+x_cgmin)/2) - x_mgjoint)/(x_ng(ii)-x_mgjoint) )])
                disp(['Tailstrike angle is ', num2str(atand( (grc_actual + radius_fuselage + z_firsttailstrike) / (x_firsttailstrike - x_mgjoint) ))])
                disp(['Tipback angle is ', num2str(atand( (x_mgjoint-x_cgmax)/h_cg ))])
                disp(['Ground clearance is ', num2str(grc_actual)])
                disp(['Overturn angle is ', num2str(atand( (h_cg*sqrt(y_mgjoint(i)^2+(x_mgjoint-x_ng(ii))^2))/(y_mgjoint(i)*(x_cgmin-x_ng(ii))))) ])
                disp(' ')
                
                % Calculate wheel loads
                % Functions
                [W_WheelMainGear, W_WheelNoseGear, W_DynamNoseGear, LbsReqMainGear, ...
                    LbsReqNoseGearStatic, LbsReqNoseGearDynamic] = WheelLoads(W0, x_ng(ii), ...
                    x_mgjoint, x_cgmin, x_cgmax, z_cg);
                
                % Outputs
                disp('Loads required to carry by landing gears:')
                disp(['Static load on nose gear is approx ', num2str(round(LbsReqNoseGearStatic)), ' lbs'])
                disp(['Dynamic load on nose gear is approx ', num2str(round(LbsReqNoseGearDynamic)), ' lbs'])
                disp(['Total load on nose gear is approx ', num2str(round(LbsReqNoseGearStatic + LbsReqNoseGearDynamic)), ' lbs'])
                disp(['Static load on main gear is approx ', num2str(round(LbsReqMainGear)), ' lbs'])
                
                % Pick tires
                [NoseWheel] = GimmeTiresRaymerForReal(LbsReqNoseGearStatic + LbsReqNoseGearDynamic, 3);
                [MainWheel] = GimmeTiresRaymerForReal(LbsReqMainGear, 1);
                disp(' ')
                disp('Nose wheel selected: ')
                disp(NoseWheel)
                disp('Main wheel selected: ')
                disp(MainWheel)
                
                % Calculate maximum width of main u/c (aka height in fus)
                % If max width too big, warn u/c failed due to engine
                % clearance. If not too big, carry on with ACN PCN. 
                
                % Finalise the undercarriage
                % To break out of outer nested loop
                error = 0;
                % Break out of this loop
                break
            end
        end
    
    end
    
    if error == 0
        break
    else
        continue
    end
    % For testing purposes
    pause(0.01)
    clc
    
end
    