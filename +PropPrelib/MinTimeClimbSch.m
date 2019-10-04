function [V, H, Ps, M] = MinTimeClimbSch(h, TR, TL, WL, CLm, Beta_TO, h_TO, k_TO, AB, inc, M_Max)
%MINTIMECLIMBSCH 
import PropPrelib.*
if nargin == 9
   inc = 5;
end
H = linspace(h_TO, h, inc);

[V, Ps] = vecfun(@VmaxPs, H, TR, TL, WL, Beta_TO, AB);
Ps = Ps.*-1;

[~, a] = atmos(H);
M = V./a;
if nargin == 11
    M(find(M>M_Max)) = M_Max;
    V = M.*a;
end

[T, a, P, rho, theta, delta, sigma] = atmos(25E3);
v = linspace(900, 2000, 30000);
t = vecfun(@PsFVh, v, T, a, P, rho, theta, delta, sigma, TR, TL, WL, Beta_TO, 1, AB);
plot(v/a, -t)
input

end

function [V, Ps] = VmaxPs(h,TR, TL, WL, Beta_TO, AB)
    import PropPrelib.*
    [T, a, P, rho, theta, delta, sigma] = atmos(h(1));
    PsFun = @(V)-PsFVh(V, T, a, P, rho, theta, delta, sigma, TR, TL, WL, Beta_TO, 1, AB);
    [V, Ps] = fminbnd(PsFun, 0, 2.5E3);
end


function Ps = PsFVh(V, T, a, P, rho, theta, delta, sigma, TR, TL, WL, beta, n, AB)
    import PropPrelib.*
    M = V/a;
    [theta_0, delta_0] = adjust_atmos(theta, delta, M);
    alpha = thrustLapse('theta_0', theta_0,...
                        'delta_0', delta_0,...
                        'TR', TR,...
                        'AB', AB);
    q = dynamic_pressure(P, M);
    [K1, CD0, K2] = drag_constants(M);
    Ps = V*(alpha/beta*TL - K1*n^2*beta/q - K2*n - CD0/((beta/q)*WL));
 end

