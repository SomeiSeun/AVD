function [span, cRoot, cTip, cBar] = tailplaneSizing(Sref, AR, taper)
% this function calculates the span and root, tip, and mean aerodynamic
% chords for a given lifting surface with the following parameters
%
% INPUTS
% Sref = reference planform area (m^2)
% AR = wing aspect ratio b^2/Sref
% taper = taper ratio cTip/cRoot


%determining planform span
span = sqrt(Sref*AR);

%determining horizontal tailplane chord values 
cRoot = 2*Sref/(span*(1+taper));
cTip = cRoot*taper;
cBar = 2/3*cRoot*(1+taper+taper^2)/(1+taper);
end


%% UDDESHYA'S CODE <3
% function [S_HT, S_VT, b_HT, b_VT, C_avg_HT, C_avg_VT] = tailplaneSizing(R1, R2, S, C_ref, b_ref, AR_VT, AR_HT)
% 
% % This function determines the size of the horizontal and vertical
% % stabilizers 
% 
% % The INPUTS are: (ALL SI UNITS)
% % R1 is the radius of the fuselage at wing quarter chord line in m
% % R2 is the radius of the fuselage at horizontal tail plane quarter chord
% % line in m
% % S is the reference wing area in m^2
% % C_ref is the mean geometric chord in m
% % b_ref is the reference span in m
% % AR_HT is the Aspect Ratio for the Horizontal Tail plane
% % AR_VT is the Aspect Ratio for the Vertical Tail plane
% 
% % The OUTPUTS are: (ALL SI UNITS)
% % S_HT is the Horizontal tail area in m^2
% % S_VT is the Vertical tail area in m^2
% % b_HT is the Horizontal tail span in m
% % b_VT is the Vertical tail span in m
% % C_avg_HT is the mean chord of the Horizontal tail in m
% % C_avg_VT is the mean chord of the Vertical tail in m
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% V_VT = 0.09;  % Assigning the Vertical Tail volume value
% V_HT = 1.2;   % Assigning the Horizontal Tail volume value
% 
% l_T = sqrt((2 * S * ((V_HT * C_ref) + V_VT * b_ref)) / (pi * (R1 + R2))); % Finding out the vertical tail arm in m
% 
% S_HT = (V_HT * S * C_ref) / l_T;    % Gives the Horizontal tail area in m^2
% 
% S_VT = (V_VT * S * b_ref) / l_T;    % Gives the Vertical tail area in m^2
% 
% b_HT = sqrt(AR_HT * S_HT); % Gives the Horizontal tail span in m
% 
% b_VT = sqrt(AR_VT * S_VT); % Gives the Vertical tail span in m
% 
% C_avg_HT = b_HT / AR_HT;   % Gives the average chord of the Horizontal tail plane in m
% 
% C_avg_VT = b_VT / AR_VT;   % Gives the average chord of the Vertical tail plane in m
% 
% end