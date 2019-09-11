function alpha = thrust_lapse_max(theta_0, delta_0, TR, M_0)
%Equation 2.55a
if theta_0>TR
    alpha = delta_0.*(1-0.3.*(theta_0-1)-0.1*sqrt(M_0)-(1.5.*(theta_0-TR)./(1.5+M_0)));
else
    alpha = delta_0*(1-0.3.*(theta_0-1)-0.1*sqrt(M_0));
end
end

