function [PI, stats] = ConstantAltitudeSpeedTurn(varargin)
    [beta, WLto, TLto, alt, M, TR, n, Turns, CDR] = parsevars(varargin);
    import PropPrelib.* 

    [~, a, P] = atmos(alt); 
    [theta, delta] = atmos_nondimensional(alt);
    [theta_0, delta_0] = adjust_atmos(theta, delta, M);
    q = dynamic_pressure(P, M);
    [K1, CD0] = drag_constants(M);
    K2 = 0;

    CL = n*beta/q*WLto;
    CD = K1*CL^2 + K2*CL + CD0;
    CDdCL = (CD+CDR)/CL;
    
    alpha_req = CDdCL*n*beta/TLto;
    %Find afterburner setting where alpha = alpha_req
    [AB_req, alpha_avail] = required_AB(alpha_req, theta_0, delta_0, TR);
    
    tfsc_m = tfsc('theta', theta,...
                  'M0'   , M,...
                  'AB'   , AB_req);
              
    V = a*M;                   
    dt = 2*pi*Turns*V/(g0*sqrt(n^2-1));
   
    PI = exp(-tfsc_m*CDdCL*n*dt);
    
    stats.Alpha_req = alpha_req;
    stats.Alpha = alpha_avail;                               
    stats.AB_req = AB_req;
    stats.AB = AB_req;
    stats.TFSC = tfsc_m;
    stats.Beta_1 = beta;
    stats.Beta_2 = PI*beta;
    stats.CD = CD;
    stats.CL = CL;
    stats.CD__dCL = CDdCL;
    stats.Time = dt;
    stats.PI = PI;
end

function [beta, WLto, TLto, alt, M, TR, n, Turns, CDR] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'WLto' , RequiredArg, @isnumeric);
    addParameter(p, 'TLto' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt'  , RequiredArg, @isnumeric);
    addParameter(p, 'M'    , RequiredArg, @isnumeric);
    addParameter(p, 'n'    , RequiredArg, @isnumeric);
    addParameter(p, 'Turns', RequiredArg, @isnumeric);
    addParameter(p, 'CDR'  , 0, @isnumeric);
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
M = arg.M;
TR = arg.TR;
n = arg.n;
Turns = arg.Turns;
CDR = arg.CDR;
end



