function Ps = PsFVh(V, h, TR, TL, WL, beta, n, AB)
%Ps = PSFVH (V, h, TR, TL, WL, beta, n, AB)
%Given Velocity, altitude, Throttle Ratio, Thrust Loading, Wing Loading,
%beta, n, and AB settting, calculate excess power.
%Requires dragmodel set.
%Requires enginemodel set.
%Requires units set.
%Requires atmodel set.
    import PropPrelib.*
    [~, a, P, ~, theta, delta, ~] = atmos(h);
    M = V./a;
    [theta_0, delta_0] = adjust_atmos(theta, delta, M);
    alpha = thrustLapse(theta_0, delta_0, TR, 'AB', AB);
    q = dynamic_pressure(P, M);
    [K1, CD0, K2] = drag_constants(M);
    Ps = V*(alpha./beta.*TL - K1.*n.^2*beta./q.*WL - K2.*n - CD0./((beta./q).*WL));
 end
