function alpha = thrust_lapse_max(theta_0, delta_0, TR, M0)
%Equation 2.54a
if theta_0<=TR
    alpha = delta_0; q
else
    alpha = delta_0.*(1-3.5.*(theta_0-TR)./theta_0);
end 
end

