function TL = ServiceCeiling(varargin)
[WL,beta,TR,alt,M,AB,Ps] = parsevars(varargin);

import PropPrelib.* 

[~, a, P, ~, theta, delta] = atmos(alt); 
q = dynamic_pressure(P, M);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

CL = beta/q*WL;
V = a*M;

% Calculating Thrust Lapse
alpha = thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', AB);
 
[K1, CD0, K2] = drag_constants(M);
CDR = 0;

%EQ 2.12
TL = beta./alpha.*(K1.*CL+K2+(CD0+CDR)./CL+1./V.*Ps);
end

function [WL,beta,TR,alt,M,AB,Ps] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt'  , RequiredArg, @isnumeric);
    addParameter(p, 'M'    , RequiredArg, @isnumeric);
    addParameter(p, 'AB'   , RequiredArg, @isnumeric);
    addParameter(p, 'Ps'   , RequiredArg, @isnumeric);
end

try
    arg = parse(p, vars{:});
catch ME
    throwAsCaller(ME)
end   

WL = arg.WL;
beta = arg.beta;
TR = arg.TR;
alt = arg.alt;
M = arg.M;
AB = arg.AB;
Ps = arg.Ps;
end

