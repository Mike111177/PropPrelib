function [theta, delta, sigma] = atmos_nondimensionalBE(h)
import PropPrelib.atmos_nondimensional;
[theta, delta, sigma] = atmos_nondimensional(h * 0.3048);
end

