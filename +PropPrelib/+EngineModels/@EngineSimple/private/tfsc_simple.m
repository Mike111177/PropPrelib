function tfsc = tfsc_simple(varargin)
    [theta, M0, C1, C2] = parsevars(varargin);
    
    tfsc = (C1 + C2.*M0).*sqrt(theta)/3600;
end 

function [theta, M0, C1, C2] = parsevars(vars)
    import PropPrelib.*
    persistent p
    if isempty(p)
        p = ArgParser;
        addParameter(p, 'theta'  , RequiredArg, @isnumeric);
        addParameter(p, 'M0'   , RequiredArg, @isnumeric);
        addParameter(p, 'C1', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
        addParameter(p, 'C2', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    end

    try
        arg = parse(p, vars{:});
    catch ME
        throwAsCaller(ME)
    end   

    theta = arg.theta;
    M0 = arg.M0;
    C1 = arg.C1;
    C2 = arg.C2;
end