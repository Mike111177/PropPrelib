function q = dynamic_pressure(P, M, gamma)
%Equation 1.6
if nargin == 2
    gamma = 1.4;
end
q = gamma.*P.*M.^2./2;
end

