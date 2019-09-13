function [T, a, P, rho] = atmosisaBE( h )
h = h * 0.3048; %Feet to Meters
[T, a, P, rho] = atmosisa(h);
T = T * 1.8; %Kelvin to Rankine
a = a * 3.28084; %m/s to ft/s
P = P * 0.020885; %Pasclas to PSF
rho = rho * 0.062428; %kg/m^3 to lbm/ft^2
end

