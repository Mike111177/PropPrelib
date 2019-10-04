function [PI, stats] = ConstantSpeedClimb(varargin)
[beta, WLto, TLto, alt1, alt2, M, TR, CDR, AB, Intervals] = parsevars(varargin);
    PI = 1;
    alt = linspace(alt1, alt2, Intervals+1);
    for i = 1:Intervals
        [iPI, istats] = CSC(beta, WLto, TLto, alt(i), alt(i+1), M, TR, CDR, AB);
        PI = PI*iPI;
        stats(i) = istats;
        beta = beta*PI;
    end
end

function [PI, stats] = CSC(beta, WLto, TLto, alt1, alt2, M, TR, CDR, AB) 
    import PropPrelib.* 
    
    alt = mean([alt1, alt2]);
    [~, a, P] = atmos(alt);
    [theta, delta] = atmos_nondimensional(alt);
    [theta_0, delta_0] = adjust_atmos(theta, delta, M);
    q = dynamic_pressure(P, M);
    [K1, CD0, K2] = drag_constants(M);
  
    CL = beta/q*WLto;
    CD = K1*CL^2 + K2*CL + CD0;
    CDdCL = (CD+CDR)/CL;
    
    alpha = thrustLapse('theta_0', theta_0,...
                        'delta_0', delta_0,...
                        'TR', TR,...
                        'AB', AB);   
    
    tfsc_m = tfsc('theta', theta,...
                  'M0'   , M,...
                  'AB'   , AB);
              
    V = a*M;    
    dZe = alt2-alt1;
    u = CDdCL*(beta/alpha)*(1/TLto);
    
    PI = exp(-tfsc_m/(V*(1-u))*dZe);
    
    stats.Alpha = alpha;                              
    stats.AB = AB;
    stats.TFSC = tfsc_m;
    stats.PI = PI;
end

function [beta, WLto, TLto, alt1, alt2, M, TR, CDR, AB, Intervals] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'beta', RequiredArg, @isnumeric);
    addParameter(p, 'WLto', RequiredArg, @isnumeric);
    addParameter(p, 'TLto', RequiredArg, @isnumeric);
    addParameter(p, 'alt1' , RequiredArg, @isnumeric);
    addParameter(p, 'alt2'  , RequiredArg, @isnumeric);
    addParameter(p, 'M'  , RequiredArg, @isnumeric);
    addParameter(p, 'TR'  , RequiredArg, @isnumeric);
    addParameter(p, 'AB'  , RequiredArg, @isnumeric);
    addParameter(p, 'CDR' , 0, @isnumeric);
    addParameter(p, 'Intervals', 20, @(x)isnumeric(x)&&isscalar(x));
end

try
    arg = parse(p, vars{:});
catch ME
    throwAsCaller(ME)
end   

beta = arg.beta;
WLto = arg.WLto;
TLto = arg.TLto;
alt1 = arg.alt1;
alt2 = arg.alt2;
M = arg.M;
TR = arg.TR;
CDR = arg.CDR;
AB = arg.AB;
Intervals = arg.Intervals;
end