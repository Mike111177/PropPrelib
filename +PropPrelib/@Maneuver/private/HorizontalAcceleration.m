function [PI, stats] = HorizontalAcceleration(varargin)
[beta, WLto, TLto, alt, M1, M2, TR, CDR, AB, Intervals] = parsevars(varargin);
    PI = 1;
    M = linspace(M1, M2, Intervals+1);
    for i = 1:Intervals
        [iPI, istats] = HACCInt(beta, WLto, TLto, alt, M(i), M(i+1), TR, CDR, AB);
        PI = PI*iPI;
        stats(i) = istats;
        beta = beta*iPI;
    end
end

function [PI, stats] = HACCInt(beta, WLto, TLto, alt, M1, M2, TR, CDR, AB) 
    import PropPrelib.* 
    
    M = [M1, M2];
    [~, a, P] = atmos(alt);
    [theta, delta] = atmos_nondimensional(alt);
    [theta_0, delta_0] = adjust_atmos(theta, delta, M);
    q = dynamic_pressure(P, M);
    [K1, CD0, K2] = drag_constants(M);
  
    CL = beta./q.*WLto;
    CD = K1.*CL.^2 + K2.*CL + CD0;
    CDdCL = (CD+CDR)./CL;
    
    alpha = thrustLapse('theta_0', theta_0,...
                        'delta_0', delta_0,...
                        'TR', TR,...
                        'AB', AB);   
    
    tfsc_m = mean(tfsc('theta', theta,...
                       'M0'   , M,...
                       'AB'   , AB));
              
    V = a*M;
    V1 = a*M(1);
    V2 = a*M(2);
    V = mean(V);
    
    dZe = (V2^2-V1^2)/(2*g0);
    u = mean(CDdCL.*(beta./alpha)*(1./TLto));
    
    PI = exp(-tfsc_m/(V*(1-u))*dZe);
    
    stats.alpha_req = alpha;
    stats.alpha_avail = alpha;                                
    stats.AB = AB;
    stats.tfsc = tfsc_m;
end

function [beta, WLto, TLto, alt, M1, M2, TR, CDR, AB, Intervals] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'beta', RequiredArg, @isnumeric);
    addParameter(p, 'WLto', RequiredArg, @isnumeric);
    addParameter(p, 'TLto', RequiredArg, @isnumeric);
    addParameter(p, 'TR'  , RequiredArg, @isnumeric);
    addParameter(p, 'alt' , RequiredArg, @isnumeric);
    addParameter(p, 'M1'  , RequiredArg, @isnumeric);
    addParameter(p, 'M2'  , RequiredArg, @isnumeric);
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
alt = arg.alt;
M1 = arg.M1;
M2 = arg.M2;
TR = arg.TR;
CDR = arg.CDR;
AB = arg.AB;
Intervals = arg.Intervals;
end