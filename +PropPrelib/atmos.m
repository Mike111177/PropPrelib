function [T, a, P, rho] = atmos( h, model )
import PropPrelib.*
import PropPrelib.unitsystem.*

if nargin == 1
    model = atmodel;
end

usys = units;
if usys == UnitSystem_e.BE
    h = h * 0.3048; %Feet to Meters
end

[T, a, P, rho] = model.airAt(h);

if usys == UnitSystem_e.BE
    T = T * 1.8; %Kelvin to Rankine
    a = a * 3.28084; %m/s to ft/s
    P = P * 0.020885; %Pasclas to PSF
    rho = rho * 0.062428; %kg/m^3 to lbm/ft^2
end
end

