function MTOW = RoskamGimmeMTOW(ProductWFs, W_Payload, W_Crew, TrappedFuelFactor)
% This function uses the values selected in initial sizing and the
% calculated fuel fraction to iterate a value for the Maximum Take-Off
% Weight MTOW (also called W0) of the aircraft. This function uses the
% Roskam method.

% The initial mass estimate is going to be taken as the mass of e.g. the
% A321Neo. As seen on Desmos, anything above around 500,000N can converge
% without issues and the value doesn't really matter.

% The convergence would work based on the ratio of W_ETent and W_EAllowed
% instead of e.g. percent difference. It worked in Excel, should work here
% too.
W0Guess = 1500000;
difference = 20;
error = 1;
while difference > error
    W_FUsed = (1-ProductWFs)*W0Guess;
    W_FRes = TrappedFuelFactor*W_FUsed;
    W_FTotal = W_FUsed + W_FRes;
    W0_ETent = W0Guess - W_FTotal - W_Payload;
    
    W_ETent = W0_ETent - W_FRes - W_Crew;
    W_EAllowed = 10^( (log10(W0Guess)-0.0833)/1.0383 );
    
    difference = abs(W_ETent - W_EAllowed);
    
    ratio = W_EAllowed/W_ETent;
    W0Guess = W0Guess * ratio;
    
end
MTOW = W0Guess;
end