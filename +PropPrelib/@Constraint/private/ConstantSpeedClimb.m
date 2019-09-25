function TL = ConstantSpeedClimb(varargin)
% CONSTANTSPEEDCLIMB('WL', WL, 'beta', beta, 'TR', TR, 'alt1', alt1, 'alt2', alt2, 'dt', dt, 'M', M) 
% calculates wingloading with default max thrust model.
% 
% CONSTANTSPEEDCLIMB('WL', WL, 'beta', beta, 'TR', TR, 'alt1', alt1, 'alt2', alt2, 'dt', dt, 'M', M, 'AB', 'max') 
% calculates wingloading with max thrust model.
%
% CONSTANTSPEEDCLIMB('WL', WL, 'beta', beta, 'TR', TR, 'alt1', alt1, 'alt2', alt2, 'dt', dt, 'M', M, 'AB', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt1,alt2,dt,M,AB] = parsevars(varargin);

import PropPrelib.* 

dh = alt2 - alt1;
alt = mean(alt1, alt2);

[T, a, P] = atmos(alt); 
V = a.*M;
q = dynamic_pressure(P, M);
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

% Calculating Thrust Lapse
alpha = thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', AB);
 
[K1, CD0] = drag_constants(M);
CDR = 0;
K2 = 0;

%EQ 2.14
TL = beta./alpha.*(K1.*beta./q.*WL+K2+(CD0+CDR)./(beta./q)./WL+1./V.*dh./dt);
end

function [WL,beta,TR,alt1,alt2,dt,M,AB] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt1'  , RequiredArg, @isnumeric);
    addParameter(p, 'alt2'  , RequiredArg, @isnumeric);
    addParameter(p, 'dt'  , RequiredArg, @isnumeric);
    addParameter(p, 'M'   , RequiredArg, @isnumeric);
    addParameter(p, 'AB', 1);
end

try
    arg = parse(p, vars{:});
catch ME
    throwAsCaller(ME)
end   

WL = arg.WL;
beta = arg.beta;
TR = arg.TR;
alt1 = arg.alt1;
alt2 = arg.alt2;
dt = arg.dt;
M = arg.M;
AB = arg.AB;
end

