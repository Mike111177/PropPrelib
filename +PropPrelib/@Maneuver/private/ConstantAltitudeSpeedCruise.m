function [PI, stats] = ConstantAltitudeSpeedCruise(varargin)
    [beta, WLto, TLto, alt, M, TR, D, CDR] = parsevars(varargin);
    import PropPrelib.* 

    [~, a, P] = atmos(alt); 
    [theta, delta] = atmos_nondimensional(alt);
    [theta_0, delta_0] = adjust_atmos(theta, delta, M);
    q = dynamic_pressure(P, M);
    [K1, CD0, K2] = drag_constants(M);
  
    CL = beta/q*WLto;
    CD = K1*CL^2 + K2*CL + CD0;
    CDdCL = (CD+CDR)/CL;
    
    alpha_req = CDdCL*beta/TLto;
    %Find afterburner setting where alpha = alpha_req
    [AB_req, alpha_avail] = required_AB(alpha_req, theta_0, delta_0, TR);
    
    tfsc_m = tfsc('theta', theta,...
                  'M0'   , M,...
                  'AB'   , AB_req);
              
    dt = D/(a*M);
   
    PI = exp(-tfsc_m*CDdCL*dt);
    
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
    stats.Theta0 = theta_0;
    stats.Delta0 = delta_0;
    stats.Theta = theta;
    stats.Delta = delta;
end

function [beta, WLto, TLto, alt, M, TR, D, CDR] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'beta', RequiredArg, @isnumeric);
    addParameter(p, 'WLto', RequiredArg, @isnumeric);
    addParameter(p, 'TLto', RequiredArg, @isnumeric);
    addParameter(p, 'TR'  , RequiredArg, @isnumeric);
    addParameter(p, 'alt' , RequiredArg, @isnumeric);
    addParameter(p, 'M'   , RequiredArg, @isnumeric);
    addParameter(p, 'D'   , RequiredArg, @isnumeric);
    addParameter(p, 'CDR' , 0, @isnumeric);
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
D = arg.D;
CDR = arg.CDR;
end



