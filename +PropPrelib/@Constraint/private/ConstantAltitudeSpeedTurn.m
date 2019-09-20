function TL = ConstantAltitudeSpeedTurn(varargin)
% CONSTANTALTITUDESPEEDTURN('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'n', n) 
% calculates wingloading with default max thrust model.
% 
% CONSTANTALTITUDESPEEDTURN('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'n', n, 'Throttle', 'max') 
% calculates wingloading with max thrust model.
%
% CONSTANTALTITUDESPEEDTURN('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'n', n, 'Throttle', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt,M,n,Throttle] = parsevars(varargin);

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

%EQ 2.15
TL = beta./alpha.*(K1.*n.^2.*beta./q.*WL+n.*K2+(CD0+CDR)./(beta./q)./WL);
end

function [WL,beta,TR,alt,M,n,Throttle] = parsevars(vars)
import PropPrelib.RequiredArg
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'WL'      , RequiredArg, @isnumeric);
    addParameter(p, 'beta'    , RequiredArg, @isnumeric);
    addParameter(p, 'TR'      , RequiredArg, @isnumeric);
    addParameter(p, 'alt'     , RequiredArg, @isnumeric);
    addParameter(p, 'M'       , RequiredArg, @isnumeric);
    addParameter(p, 'n'       , RequiredArg, @isnumeric);
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
n = arg.n;
Throttle = arg.Throttle;
end

