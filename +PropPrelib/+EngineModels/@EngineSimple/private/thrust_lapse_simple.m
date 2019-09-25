function alpha = thrust_lapse_simple(theta_0, delta_0, TR, A, B, C, D)
  alpha = delta_0.*...
          ((theta_0<=TR).*(A) + ... %alpha / delta_0 = A, theta_0 < TR
          (theta_0>TR) .* (A + B .* (abs(theta_0 - TR) .^ C) ./ (theta_0 .^ D))); 
end