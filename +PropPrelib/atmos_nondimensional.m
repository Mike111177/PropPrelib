function [theta, delta, sigma] = atmos_nondimensional(h)
import PropPrelib.*;

[Tstd, ~, Pstd, rhostd] = atmos(0);
[T, ~, P, rho] = atmos(h);
theta = T/Tstd;
delta = P/Pstd;
sigma = rho/rhostd;
end

