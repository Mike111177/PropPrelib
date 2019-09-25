function PI = ConstantAltitudeSpeedCruise(varargin)
    [beta, WLto, TLto, alt, M, TR, D, CDR, Intervals] = parsevars(varargin);
    PI = 1;
    for i = 1:Intervals
        PI = PI*CASCInt(beta, WLto, TLto, alt, M, TR, D/Intervals, CDR);
        beta = beta*PI;
    end
end

function PI = CASCInt(beta, WLto, TLto, alt, M, TR, D, CDR) 
    import PropPrelib.* 

    [~, a, P] = atmos(alt); 
    [theta, ~] = atmos_nondimensional(alt);
    q = dynamic_pressure(P, M);
    [K1, CD0] = drag_constants(M);
    K2 = 0;
  
    CL = beta/q*WLto;
    CD = K1*CL^2 + K2*CL + CD0;
    CDdCL = (CD+CDR)/CL;
    
    %Find afterburner setting where TL = set value
    ABreq = fminbnd(@(ABv)Constraint.A('WL', WLto,'beta', beta,'TR',TR,'M',M,'alt',alt,'AB',ABv)-TLto, 0, 1);
    tfsc_m = tfsc('theta', theta,...
                  'M0'   , M,...
                  'AB'   , ABreq);
              
    dt = D/(a*M);
   
    PI = exp(-tfsc_m*CDdCL*dt);
end

function [beta, WLto, TLto, alt, M, TR, D, CDR, Intervals] = parsevars(vars)
import PropPrelib.RequiredArg
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'beta', RequiredArg, @isnumeric);
    addParameter(p, 'WLto', RequiredArg, @isnumeric);
    addParameter(p, 'TLto', RequiredArg, @isnumeric);
    addParameter(p, 'TR'  , RequiredArg, @isnumeric);
    addParameter(p, 'alt' , RequiredArg, @isnumeric);
    addParameter(p, 'M'   , RequiredArg, @isnumeric);
    addParameter(p, 'D'   , RequiredArg, @isnumeric);
    addParameter(p, 'CDR' , 0, @isnumeric);
    addParameter(p, 'Intervals', 5, @(x)isnumeric(x)&&isscalar(x));
end

try
    arg = RequiredArg.check(p, vars);
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
Intervals = arg.Intervals;
end



