function alpha = thrust_lapse_mil(theta_0, delta_0, TR, M_0)
%Equation 2.54b
alpha = 0.6.*delta_0.*((theta_0<=TR)+...
    (theta_0>TR).*(1-3.8.*(theta_0-TR)./theta_0));
end

