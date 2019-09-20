function TL = ConstantAltitudeSpeedCruise(varargin)
% CONSTANTALTITUDESPEEDCRUISE('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M) 
% calculates wingloading with default max thrust model.
% 
% CONSTANTALTITUDESPEEDCRUISE('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'Throttle', 'max') 
% calculates wingloading with max thrust model.
%
% CONSTANTALTITUDESPEEDCRUISE('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'Throttle', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt,M,Throttle] = parsevars(varargin);

import PropPrelib.* 

[T, a, P] = atmos(alt); 
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

%EQ 2.12
TL = beta./alpha.*(K1.*beta./q.*WL+K2+(CD0+CDR)./(beta./q)./WL);
end

function [WL,beta,TR,alt,M,Throttle] = parsevars(vars)
import PropPrelib.RequiredArg
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt'  , RequiredArg, @isnumeric);
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
alt = arg.alt;
M = arg.M;
Throttle = arg.Throttle;
end

