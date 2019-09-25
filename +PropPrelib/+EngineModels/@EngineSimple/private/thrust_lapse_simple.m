function alpha = thrust_lapse_simple(varargin)
    [theta_0, delta_0, TR, A, B, C, D] = parsevars(varargin);
    
    alpha = delta_0.*...
        ((theta_0<=TR).*(A) + ... %alpha / delta_0 = A, theta_0 < TR
        (theta_0>TR) .* (A + B .* (abs(theta_0 - TR) .^ C) ./ (theta_0 .^ D))); 
end

function [theta_0, delta_0, TR, A, B, C, D] = parsevars(vars)
    import PropPrelib.RequiredArg
    persistent p
    if isempty(p)
        p = inputParser;
        addParameter(p, 'theta_0'  , RequiredArg, @isnumeric);
        addParameter(p, 'delta_0'   , RequiredArg, @isnumeric);
        addParameter(p, 'TR', RequiredArg, @isnumeric)
        addParameter(p, 'A', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
        addParameter(p, 'B', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
        addParameter(p, 'C', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
        addParameter(p, 'D', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    end

    try
        arg = RequiredArg.check(p, vars);
    catch ME
        throwAsCaller(ME)
    end   

    theta_0 = arg.theta_0;
    delta_0 = arg.delta_0;
    TR = arg.TR;
    A = arg.A;
    B = arg.B;
    C = arg.C;
    D = arg.D;
end