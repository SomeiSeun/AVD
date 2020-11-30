function W_engineStarter = W_engineStarter(NumEngines, W_engine)
% this function calculates the weight of the pneumatic engine starter in lb

% INPUTS
% NumEngines = number of engines
% W_engine = weight of engine (ob)

W_engineStarter = 49.19 * (NumEngines * W_engine * 1e-3)^0.541;
end