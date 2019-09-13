function alpha = thrust_lapse_max(theta_0, delta_0, TR, M0)
%Equation 2.54a
    alpha = delta_0.*((theta_0>TR) + ...
        (theta_0<=TR).*(1-3.5.*(theta_0-TR)./theta_0));
end

