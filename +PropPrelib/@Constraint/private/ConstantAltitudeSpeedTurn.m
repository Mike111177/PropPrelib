function TL = ConstantAltitudeSpeedTurn(varargin)
% CONSTANTALTITUDESPEEDTURN('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'n', n) 
% calculates wingloading with default max thrust model.
% 
% CONSTANTALTITUDESPEEDTURN('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'n', n, 'AB', 1) 
% calculates wingloading with max thrust model.
%
% CONSTANTALTITUDESPEEDTURN('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'M', M, 'n', n, 'AB', 0) 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt,M,n,AB] = parsevars(varargin);

import PropPrelib.* 

[~, ~, P] = atmos(alt); 
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

%EQ 2.15
TL = beta./alpha.*(K1.*n.^2.*beta./q.*WL+n.*K2+(CD0+CDR)./(beta./q)./WL);
end

function [WL,beta,TR,alt,M,n,AB] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'WL'      , RequiredArg, @isnumeric);
    addParameter(p, 'beta'    , RequiredArg, @isnumeric);
    addParameter(p, 'TR'      , RequiredArg, @isnumeric);
    addParameter(p, 'alt'     , RequiredArg, @isnumeric);
    addParameter(p, 'M'       , RequiredArg, @isnumeric);
    addParameter(p, 'n'       , RequiredArg, @isnumeric);
    addParameter(p, 'AB'      , RequiredArg, @isnumeric);
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
n = arg.n;
AB = arg.AB;
end

