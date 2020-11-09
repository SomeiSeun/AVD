function [L_DMax] = LiftToDragRatio(K_LD, AspectRatio, SWet_SRef)
% This function is used to calculate the lift to drag ratio given the
% assumptions of certain values. This is a low fidelity model including
% basic empirical values and a simple equation. This will be made better
% later on.
% Example: [L_DMax] = LiftToDragRatio(K_LD, AspectRatio, SWet_SRef)

L_DMax = K_LD * sqrt(AspectRatio/SWet_SRef);

end

