function [theta, delta, sigma] = atmos_nondimensional(h)
import PropPrelib.*;

[Tstd, a, Pstd, rhostd] = atmos(0);
[T, a, P, rho] = atmos(h);
theta = T/Tstd;
delta = P/Pstd;
sigma = rho/rhostd;
end

