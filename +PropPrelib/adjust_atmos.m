function [theta_0, delta_0] = adjust_atmos(theta, delta, M0, gamma)
% Equations 2.52a and b
% Also applies to equations 1.1 and 1.2
% TODO find a better name for this
if nargin == 3
    gamma = 1.4;
end
mf = 1+(gamma-1)/2*M0.^2;
theta_0 = theta .* mf;
delta_0 = delta .* mf .^ (gamma/(gamma-1));
end

