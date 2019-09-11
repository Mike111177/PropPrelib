function alpha = thrust_lapse_mil(theta_0, delta_0, TR)
%Equation 2.54b
if theta_0<=TR
    alpha = 0.6.*delta_0;
else
    alpha = 0.6.*delta_0.*(1-3.8.*(theta_0-TR)./theta_0);
end
end

