function TL = ConstantSpeedClimb(varargin)
% CONSTANTSPEEDCLIMB('WL', WL, 'beta', beta, 'TR', TR, 'alt1', alt1, 'alt2', alt2, 'dt', dt, 'M', M) 
% calculates wingloading with default max thrust model.
% 
% CONSTANTSPEEDCLIMB('WL', WL, 'beta', beta, 'TR', TR, 'alt1', alt1, 'alt2', alt2, 'dt', dt, 'M', M, 'Throttle', 'max') 
% calculates wingloading with max thrust model.
%
% CONSTANTSPEEDCLIMB('WL', WL, 'beta', beta, 'TR', TR, 'alt1', alt1, 'alt2', alt2, 'dt', dt, 'M', M, 'Throttle', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt1,alt2,dt,M,Throttle] = parsevars(varargin);

import PropPrelib.* 

dh = alt2 - alt1;
alt = mean(alt1, alt2);

[T, a, P] = atmos(alt); 
V = a.*M;
q = dynamic_pressure(P, M);
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

% Calculating Thrust Lapse
switch(Throttle)
    case 'max'
        alpha = thrustLapse_max(theta_0, delta_0, TR, M);
    case 'mil'
        alpha = thrustLapse_mil(theta_0, delta_0, TR, M);
end
 
[K1, CD0] = drag_constants(M);
CDR = 0;
K2 = 0;

%EQ 2.14
TL = beta./alpha.*(K1.*beta./q.*WL+K2+(CD0+CDR)./(beta./q)./WL+1./V.*dh./dt);
end

function [WL,beta,TR,alt1,alt2,dt,M,Throttle] = parsevars(vars)
import PropPrelib.RequiredArg
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt1'  , RequiredArg, @isnumeric);
    addParameter(p, 'alt2'  , RequiredArg, @isnumeric);
    addParameter(p, 'dt'  , RequiredArg, @isnumeric);
    addParameter(p, 'M'   , RequiredArg, @isnumeric);
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
alt1 = arg.alt1;
alt2 = arg.alt2;
dt = arg.dt;
M = arg.M;
Throttle = arg.Throttle;
end

