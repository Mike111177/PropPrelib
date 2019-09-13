function [theta, delta, sigma] = atmos_nondimensional(h)
[Tstd, a, Pstd, rhostd] = atmosisa(0);
[T, a, P, rho] = atmosisa(h);
theta = T/Tstd;
delta = P/Pstd;
sigma = rho/rhostd;
end

