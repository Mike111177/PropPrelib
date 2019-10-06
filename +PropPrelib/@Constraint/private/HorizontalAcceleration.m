function TL = HorizontalAcceleration(varargin)
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dVdt', dVdt, 'M', M) 
% calculates wingloading with default max thrust model.
% 
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'M1', M1, 'M2', M2, 'AB', 'max') 
% calculates wingloading with max thrust model.
%
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'V1', V1, 'V2', V2, 'AB', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,alt,dVdt,M,AB] = parsevars(varargin);

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

%EQ 2.18a
TL = beta./alpha.*(K1.*beta./q.*WL+K2+(CD0+CDR)./(beta./q)./WL+1./g0.*dVdt);
end

function [WL,beta,TR,alt,dVdt,M,AB] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'alt'  , RequiredArg().yields(@atmos,'T','a','P'), @isnumeric);
    addParameter(p, 'dVdt' , RequiredArg().convert(@(a,b)a/b, 'dV', 'dt'), @isnumeric);
    addParameter(p, 'M'    , RequiredArg().convert(@(a,b)mean([a,b]), 'M1', 'M2').convert(@(a,b)b/a, 'a', 'V'), @isnumeric);
    addParameter(p, 'T'    , RequiredArg().alt(), @isnumeric);
    addParameter(p, 'a'    , RequiredArg().alt(), @isnumeric);
    addParameter(p, 'P'    , RequiredArg().alt(), @isnumeric);
    addParameter(p, 'dt'   , RequiredArg().alt(), @isnumeric);
    addParameter(p, 'M1'   , RequiredArg().alt().convert(@(a,b)b/a, 'a', 'V1'), @isnumeric);
    addParameter(p, 'M2'   , RequiredArg().alt().convert(@(a,b)b/a, 'a', 'V2'), @isnumeric);
    addParameter(p, 'V'    , RequiredArg().alt().convert(@(a,b)mean([a,b]), 'V1', 'V2').convert(@(a,b)a*b, 'a', 'M'), @isnumeric);
    addParameter(p, 'dV'   , RequiredArg().alt().convert(@(a,b)b-a, 'V1', 'V2'), @isnumeric);
    addParameter(p, 'V1'   , RequiredArg().alt().convert(@(a,b)a*b, 'a', 'M1'), @isnumeric);
    addParameter(p, 'V2'   , RequiredArg().alt().convert(@(a,b)a*b, 'a', 'M2'), @isnumeric);
    addParameter(p, 'AB', 'max');
end

% try
    arg = parse(p, vars{:});
% catch ME
%     throwAsCaller(ME);
% end   

WL = arg.WL;
beta = arg.beta;
TR = arg.TR;
alt = arg.alt;
dVdt = arg.dVdt;
M = arg.M;
AB = arg.AB;
end


