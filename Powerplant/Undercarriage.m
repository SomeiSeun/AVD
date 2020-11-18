%% Undercarriage Design
% For the purposes of this script, the origin is placed at the ground
% exactly under the tip of the nose. The x axis then runs through to the
% tail, y axis runs sideways along wing directionn and z axis runs up.

%% Undercarriage baseline configuration

% The undercarriage for our aircraft is a tricycle configuration, with nose
% wheel retracting backwards (drag + gravity assist deployment in the case
% of hydraulics failure) and the main wheels attach to the wing/fuselage
% junction and retract into a bulge in the fuselage. 

% This configuration would allow for a large wheelbase and also allow us to
% place the central fuel tank above the retraction bay.

%% Housekeeping
clear
clc
close all

%% Get external data
load('../Initial Sizing/InitialSizing.mat', 'W0')

%% Constraining values
x_cg_max = 32;                                                                  % Allowing for the fact that CG approximations are not going to be accurate yet
x_cg_min = 30;                                                                  % See above
y_cg = 0;                                                                       % For completeness sake, should be zero for symmetric aircraft
z_cg_max = 3;                                                                   % Again allowing deviation
z_cg_min = 2;                                                                   % Value not really used tbh so might not be required
Length_ac = 60;                                                                 % Only really relevant for plotting the graph within limits
W_NoseGear_Ratio_Max = 0.20;                                                    % Assumption from slides - to prevent overloading
W_NoseGear_Ratio_Min = 0.05;                                                    % Assumption from slides - to prevent loss of steering friction
x_ng_min = 4;                                                                   % Foremost position of nose gear possible (based on nose and cockpit geometry)
x_fuse_tapers = 50;                                                             % Point where fuselage starts to taper upwards (for tailstrike calculations)
AoA_liftoff = 5;                                                                % Required to know largest angle encountered near ground (for tailstrike calculations)
AoA_landing = 2;                                                                % Angles given in degrees
ground_clearance = 1.5;                                                         % Required for a lot of things, probably would need to be iterated within the code
overturn_angle = 63;                                                            % Assumption from slides
y_mg_max = 2;                                                                   % Limitations can arise due to structural constraints

%% Landing gear positioning constraint space

% Initialising arrays to use as axes in constraint space
x_mg = 0:0.001:Length_ac;                                                       
x_ng = 0:0.001:Length_ac;

% Calculate constraining arrays using the formulae available
x_ng_min = zeros(1, length(x_mg)) + x_ng_min; % For foremost nose gear position
Const_Max_NoseGearRatio = (x_cg_min - x_mg + W_NoseGear_Ratio_Max .* x_mg)./W_NoseGear_Ratio_Max; % For the maximum possible nose gear load, consider the foremost cg position
Const_Min_NoseGearRatio = (x_cg_max - x_mg + W_NoseGear_Ratio_Min .* x_mg)./W_NoseGear_Ratio_Min; % For the minimum possible nose gear load, consider the aftmost cg position
x_mg_min = zeros(1, length(x_mg)) + x_fuse_tapers - ground_clearance/(tand(max([AoA_liftoff, AoA_landing]))); % For preventing tailstrike due to liftoff or landing angles
x_mg_min2 = zeros(1, length(x_mg)) + tand(max([AoA_liftoff, AoA_landing]))*z_cg_max + x_cg_max; % For preventing tipping the CG back too far when rotating to liftoff
x_overturnpos = real(sqrt((((y_mg_max*tand(overturn_angle))^2 .* (x_cg_min - x_ng).^2)./(z_cg_max^2)) - y_mg_max^2) + x_ng); % For preventing overturn
x_overturnneg = real(-sqrt((((y_mg_max*tand(overturn_angle))^2 .* (x_cg_min - x_ng).^2)./(z_cg_max^2)) - y_mg_max^2) + x_ng); % For preventing overturn
Const_OptimumNoseGearRatio = (x_cg_max - x_mg + 0.08 .* x_mg)./0.08;

% Trying what happens when you try and equate the wheel loads
% x_ng_WWMGequalsWWNG_MaxCG = 5*x_cg_max - 4.*x_mg;
% x_ng_WWMGequalsWWNG_MinCG = 5*x_cg_min - 4.*x_mg;
% x_mg_WWNGequalsWDNG_maxCG = 0.1770138042*z_cg_max + x_cg_max + zeros(1, length(x_mg));
% x_mg_WWNGequalsWDNG_minCG = 0.1770138042*z_cg_max + x_cg_min + zeros(1, length(x_mg));
% x_ng_WWMGequalsWDNG_maxCG = x_cg_max - 0.7080552167*z_cg_max + zeros(1, length(x_mg));
% x_ng_WWMGequalsWDNG_minCG = x_cg_min - 0.7080552167*z_cg_max + zeros(1, length(x_mg));

% Plotting constraint space
plot(x_mg, x_ng, '--r', 'LineWidth', 1.5) % For ensuring tricycle configuration
hold on
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
legend('Tricycle arrangement (stay below)', 'Foremost nose gear placement (stay above)', 'Minimum nose gear load (stay right)', ...
     'Maximum nose gear load (stay left)', 'Tailstrike prevention (stay right)', 'CG tipback prevention (stay right)', ...
     'Overturn prevention (stay within cone)', 'Overturn prevention (stay within cone)', 'Common (8%) load on nose gear')
xlim([0 Length_ac])
ylim([0 Length_ac])
xlabel('Main gear x position')
ylabel('Nose gear x position')
grid on
axis equal
hold off

%% Design point selection

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

%% Calculating loads on each wheel based on above selected design point

% Going off of the rough guidelines, we can decide to have the main gear
% split into two struts each carrying a twin tandem bogey configuration of
% wheels. For the dynamic load we are assuming a 10ft/s2 deceleration. That
% is the value 10 input there.

W_WheelMainGear = (1.07/8)*W0*( ((x_cg_min+x_cg_max)/2) - x_NoseGear )/(x_MainGear - x_NoseGear);   % With 7% safety factor. Removing this can show true load.
W_WheelNoseGear = (1.07/2)*W0*( x_MainGear - ((x_cg_min+x_cg_max)/2) )/(x_MainGear - x_NoseGear);   % With 7% safety factor. It adds up correctly.
W_DynamNoseGear = (10*z_cg_max*W0)/( 32.1850394*(1/0.3048)*(x_MainGear-x_NoseGear) );               % Need to take MTOW because this can occur during takeoff run.

LbsReqMainGear = (W_WheelMainGear/9.81) * 2.20462262;
LbsReqNoseGearStatic = (W_WheelNoseGear/9.81) * 2.20462262;
LbsReqNoseGearDynamic = (W_DynamNoseGear/9.81) * 2.20462262;

disp(['The maximum load on any tire is ', num2str(max([LbsReqMainGear, LbsReqNoseGearStatic, LbsReqNoseGearDynamic])), ' lbs' ])


%% Next steps

% "Having decided on the relative placement of the nose gear, main gear and
% the height of cg..."

% " Next thing is to ensure that the undercarriage we design would allow
% the aircraft to operate from the intended runways without causing
% structural damage (aka puncturing the runway for example). For that we
% would need to consider what the loads our u/c would apply to the tarmac
% is going to be. Depending on the number of tires we choose, we will be
% able to spread out the load over a larger surface and therefore cause
% less damage to the runway. As a first rule of thumb, we can roughly
% relate the number of wheels per main u/c strut to the MTOW. For our
% aircraft this corresponds to 4 wheels per main u/c strut arranged in a
% twin tandem bogey. We probably just need two struts."

% "The above is just a sanity check ballpark guideline, very rough. What we
% really need to consider is the tire pressure of each wheel (which
% basically corresponds to how much load per surface area each wheel would
% be imparting) vs the equivalent load that is distributed over a single
% point. That equivalent load is called the Equivalent Single Wheel Load
% (ESWL). Higher the LCN, stronger the runway, can go for a higher
% inflation pressure. Under the LCN method, there are ways of quantifying
% the ESWL etc but this method is obsolete for civil aircraft now."

% "What we use now is the ACN/PCN method. A = aircraft, P = pavement, CN =
% classification number. Similar to ESWL method."

% Here the ACN = 2 * DSWL (Derived Single Wheel Load)
% Where DSWL is the ESWL at an inflation pressure of 1.25 MPa
% Where ESWL is no longer that simple function of L stiffness factor but
% instead a function of the pavement substrate strength and pavement type.
% Unlike the LCN method, this uses a finite element approach.

% What we look for is that the ACN number is less or equal to the PCN
% number. Now the PCN number is determined for a particular runway and
% someone will tell you that. They will then specify the characteristics
% aka is it rigid or flexible i.e. is it a concrete or asphalt runway.
% Would also specify strength of substrate (ABCD). The value of DSWL is
% greatly affected by minute details such as the gravel packing etc,
% therefore it is not easy to calculate the DSWL and therefore the ACN. The
% DSWL is calculated using a FORTRAN source code available online
% hopefully. SEE IF IT CAN BE INTEGRATED INTO MATLAB! The other option is
% using COMFAA's graphical interface instead which would be very difficult
% to integrate into the code here.

% Need to find the PCN of the most restrictive airport we are likely to
% land at and accordingly on COMFAA ensure that the ACN is less than that.
% It seems that this code can be done fairly independently of the
% iterations.



% "Having determined the u/c positioning and therefore the maximum loads
% that we would expect on each undercarriage as well as roughly what tire
% pressure we are going for and roughly what the spacing between wheels
% would be in order to allow us to operate from the most constraining
% runway, we can go ahead and choose our tires."

% Spacing can be derived directly from landing gear bay volume constraints
% orrr does it work the opposite direction aka my requirements take
% precedence?

% First figure out what the maximum load we expect on each tire is. The max
% load is W_w = max static load on strut * 1.07 / No of wheels on strut.

% This is the maximum static load on each tire. In the case of e.g. aborted
% takeoff or landing, there are also dynamic loads due to braking. These
% loads push the nose gear down hard af and this would increase the "ACN"
% essentially. This is due to inertial moments imparted on the nose gear
% when braking. Same as being pushed forward when braking hard.

% Assumed deceleration of 10ft/s^2 (at the brakes). Then can use the weird
% ass formula which has some issues: W_dynamic_nose = 10*H*W0 / g*B. The 10
% is the assumed deceleration.

% This above calculation should come directly after the placement of the
% u/c is decided because its mainly a function of the geometrical
% properties and the assumed deceleration.




















 

%% Notes

    % Steerability: Something to check in FAR25, might be requirements on
    % turn radii etc which would place a number on the turning amount
    % required on the nose gear
    % Sharp turn engine strike prevention
    % Sufficient visibility over nose
    % Runway suitability
    
    % Ideally nose carries around 8% of the MTOW. This can be done with a
    % simple function which takes x locations of nose gear, main gear, cg.
    
    % Engine clearance would depend on u/c sizing rather than the other way
    % around. For span loading, engines would ideally be placed further
    % away and having u/c constrain engines would allow this. Aka this
    % should be an output rather than a constraining factor. If anything,
    % this would be limited by the overturn constraint.
    
    % Avoiding tipback is heavily related to weight and balance. Refer to
    % notes it was a bit unclear.
    
    % Okay so basically heres tipback. When the aircraft is rotating for
    % liftoff, we want the CG to be in front of the main landing gear. This
    % ensures that as the aircraft is rotating, it doesn't fall back onto
    % its tail. The wings are generating lift and causing the aircraft to
    % move towards such a position where it could tipback. As the lift at
    % that moment is less than the weight, the CG "tipping" behind the main
    % wheels could easily cause the aircraft to fall backwards before
    % sufficient lift is achieved to support flight and this would be
    % catastrophic. Tipback angle should therefore be introduced for the
    % CG. However, tipback angle should not exceed 10-15 degrees to prevent
    % excessive control forces required to rotate which would make the
    % takeoff run longer. Essentially this part of the design needs to be
    % balanced carefully to pretty much make it at the point of being
    % unstable equilibrium. Tipback would impose another minimum x_mg
    % requirement. It can be reversed to help find z_cg which would be
    % dependant on the iterative process which sizes the landing legs and
    % therefore ground clearance and therefore z_cg.
    
    % Overturning in sharp turns has to do with the height of the landing
    % gears and the relative positions of the nose wheel and outermost main
    % wheel. Want the overturn angle to be less than 63 degrees for some
    % reason. Overturn angle is arctan(height/static ground line). To
    % reduce this angle, we need to have either a cool ass placement of the
    % relative positions of nose wheel, main uc, cg or just reduce the
    % height off the ground. Now the height of the ground is also
    % constrained by something else later.
    
    % Runway suitability is to do with the aircraft being able to land on
    % the runway without causing damage to the landing structure as well as
    % the runway. This essentially puts constraints on the least number of
    % wheels. Atleast the essence. There are guidelines regarding
    % recommended values for number of wheels per main u/c strut. Our
    % aircraft weighs in at 161,800kg which falls under the W0 < 400,000lbs
    % category. This means that its recommended that we do 4 wheels per
    % main u/c strut. A good arrangement would probably be the twin tandem
    % which would allow for the correct number of wheels.
    
    % Runway suitability depends on the ACN/PCN method. In 1981, the ICAO
    % made the ACN/PCN method the only acceptable method for reporting
    % runway strength for W0 greater than 5700 kg.
    
%% The Whole Process

    % Assume tire pressure, number of u/c struts and wheels per strut
    % Place u/c (assuming CG height and position)
    % Calculate wheel loads (static and dynamic)
    % Choose tires
    % Estimate ESWL and aircraft LCN or ACN
    % Verify you can operate from desired airfields with chosen tire
    % pressure
    % Size oleos and find strut length
    % Repeat for actual CG range
    % All done

%https://aerocastle.files.wordpress.com/2012/05/aircraft-conceptual-design-synthesis.pdf
    
    
    
   
   
   
    
