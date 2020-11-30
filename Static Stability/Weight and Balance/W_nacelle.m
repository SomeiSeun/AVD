function W_nacelle = W_nacelle(W_engine, lengthNacelle, widthNacelle, Nz, NumEngines, SnacelleWetted)
% this function calculates the nacelle weight in lbs

INPUTS
lengthNacelle = length of nacelle (ft)
widthNacelle = width of nacelle (ft)
Nz = ultimate load factor (1.5x limit load factor)
NumEngines = number of engines
SnacelleWetted = wetted nacelle area (ft2)
W_engine = engine weight (lb)


Wenc = 2.331 * 1.18 * W_engine^0.901;

W_nacelle = 0.6724 * 1.017 * lengthNacelle^0.1 * widthNacelle^0.294 * Nz^0.119 *...
    Wenc^0.611 * NumEngines^0.984 * SnacelleWetted^0.224;
end