function [theta, delta, sigma] = atmos_nondimensional(h)
import PropPrelib.*;

[Tstd, a, Pstd, rhostd] = atmos(0, AtmosModel_e.Standard);
[T, a, P, rho] = atmos(h);
theta = T/Tstd;
delta = P/Pstd;
sigma = rho/rhostd;
end

