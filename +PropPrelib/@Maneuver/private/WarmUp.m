function [PI, stats] = WarmUp(varargin)
    [beta, TLto, alt, TR, dt] = parsevars(varargin);
    import PropPrelib.* 

    [~, ~, ~, ~, theta, delta] = atmos(alt); 
    
    alpha = thrustLapse('theta_0', theta,'delta_0', delta,'TR', TR,'AB', 0);   
    tfsc_m = tfsc('theta', theta,'M0', 0,'AB', 0);
            
    PI = 1-tfsc_m*alpha/beta*TLto*dt;
    
    stats.Alpha = alpha;                               
    stats.AB = 0;
    stats.TFSC = tfsc_m;
    stats.Beta_1 = beta;
    stats.Beta_2 = PI*beta;
    stats.Time = dt;
    stats.PI = PI;
    stats.Theta0 = theta;
    stats.Delta0 = delta;
    stats.Theta = theta;
    stats.Delta = delta;
end

function [beta, TLto, alt, TR, dt] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'beta', RequiredArg, @isnumeric);
    addParameter(p, 'TLto', RequiredArg, @isnumeric);
    addParameter(p, 'TR'  , RequiredArg, @isnumeric);
    addParameter(p, 'alt' , RequiredArg, @isnumeric);
    addParameter(p, 'dt'  , RequiredArg, @isnumeric);
    addParameter(p, 'Wlto', RequiredArg().alt());%Avoid unkown paramete error
end

try
    arg = parse(p, vars{:});
catch ME
    throwAsCaller(ME)
end   

beta = arg.beta;
TLto = arg.TLto;
alt = arg.alt;
TR = arg.TR;
dt = arg.dt;
end



