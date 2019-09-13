function mfp = MFP(M, R, gamma)
% Equation 1.3
if nargin == 2
    gamma = 1.4;
end
mf = 1+(gamma-1)/2.*M.^2;
mfp = M.*sqrt(gamma*32.2/R).*mf.^((gamma+1)/(2*(1-gamma)));
end

