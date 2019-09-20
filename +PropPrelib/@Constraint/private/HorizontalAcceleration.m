function TL = HorizontalAcceleration(varargin)
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'M1', M1, 'M2', M2) 
% calculates wingloading with default max thrust model.
% 
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'M1', M1, 'M2', M2, 'Throttle', 'max') 
% calculates wingloading with max thrust model.
%
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'M1', M1, 'M2', M2, 'Throttle', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt,dt,M1,M2,Throttle] = parsevars(varargin);

import PropPrelib.* 

[T, a, P] = atmos(alt);

dV = a.*(M2-M1);
M = mean([M1, M2]);
 
q = dynamic_pressure(P, M);
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

% Calculating Thrust Lapse
if strcmp(Throttle, 'max')
    alpha = thrustLapse_max(theta_0, delta_0, TR, M);
elseif strcmp(Throttle, 'mil')
    alpha = thrustLapse_mil(theta_0, delta_0, TR, M);
end
 
[K1, CD0] = drag_constants(M);
CDR = 0;
K2 = 0;

TL = beta./alpha.*(K1.*beta./q.*WL+K2+(CD0+CDR)./(beta./q)./WL+1./g0.*dV./dt);
end

function [WL,beta,TR,alt,dt,M1,M2,Throttle] = parsevars(vars)
import PropPrelib.RequiredArg
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt'  , RequiredArg, @isnumeric);
    addParameter(p, 'dt'   , RequiredArg, @isnumeric);
    addParameter(p, 'M1'   , RequiredArg, @isnumeric);
    addParameter(p, 'M2'   , RequiredArg, @isnumeric);
    addParameter(p, 'Throttle', 'max');
end

try
    arg = RequiredArg.check(p, vars);
catch ME
    throwAsCaller(ME)
end   

WL = arg.WL;
beta = arg.beta;
TR = arg.TR;
alt = arg.alt;
dt = arg.dt;
M1 = arg.M1;
M2 = arg.M2;
Throttle = arg.Throttle;
end

