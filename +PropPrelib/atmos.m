function [T, a, P, rho, theta, delta, sigma] = atmos( h, model )
import PropPrelib.*
persistent memAtmos
if isempty(memAtmos)
    memAtmos = memoize(@atmosImpl);
end
if nargin == 1
    model = atmodel;
end

[T, a, P, rho, theta, delta, sigma] = memAtmos( h, model );
end

function [T, a, P, rho, theta, delta, sigma] = atmosImpl( h, model )
import PropPrelib.*
persistent STD
usys = units;
if usys == UnitSystem.BE
    h = h * 0.3048; %Feet to Meters
end

[T, a, P, rho] = model.airAt(h);

%If outputs call for non-dimensional
if nargout>4
    if isempty(STD)
        [STD.T, STD.a, STD.P, STD.rho] = AtmosModel.Standard.airAt(0);
    end
    theta = T./STD.T;
    delta = P./STD.P;
    sigma = rho./STD.rho;
end

if usys == UnitSystem.BE
    T = T * 1.8; %Kelvin to Rankine
    a = a * 3.28084; %m/s to ft/s
    P = P * 0.020885; %Pasclas to PSF
    rho = rho * 0.062428; %kg/m^3 to lbm/ft^2
end
end

