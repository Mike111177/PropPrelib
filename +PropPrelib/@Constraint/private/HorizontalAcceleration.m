function TL = HorizontalAcceleration(varargin)
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dVdt', dVdt, 'M', M) 
% calculates wingloading with default max thrust model.
% 
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'M1', M1, 'M2', M2, 'Throttle', 'max') 
% calculates wingloading with max thrust model.
%
% HORIZONTALACCELERATION('WL', WL, 'beta', beta, 'TR', TR, 'alt', alt, 'dt', dt, 'V1', V1, 'V2', V2, 'Throttle', 'mil') 
% calculates wingloading with millitary thrust model.
%
%   TODO: make work with any thrust percentage.
[WL,beta,TR,T,a,P,dVdt,M,Throttle] = parsevars(varargin);

import PropPrelib.* 
 
q = dynamic_pressure(P, M);
[Tstd, ~, Pstd] = atmos(0, AtmosModel_e.Standard);
theta = T/Tstd;
delta = P/Pstd;
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

%EQ 2.18a
TL = beta./alpha.*(K1.*beta./q.*WL+K2+(CD0+CDR)./(beta./q)./WL+1./g0.*dVdt);
end

function [WL,beta,TR,T,a,P,dVdt,M,Throttle] = parsevars(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'WL'   , RequiredArg, @isnumeric);
    addParameter(p, 'beta' , RequiredArg, @isnumeric);
    addParameter(p, 'TR'   , RequiredArg, @isnumeric);
    addParameter(p, 'T'    , RequiredArg, @isnumeric);
    addParameter(p, 'a'    , RequiredArg, @isnumeric);
    addParameter(p, 'P'    , RequiredArg, @isnumeric);
    addParameter(p, 'dVdt' , RequiredArg().convert(@(a,b)a/b, 'dV', 'dt'), @isnumeric);
    addParameter(p, 'M'    , RequiredArg().convert(@(a,b)mean([a,b]), 'M1', 'M2').convert(@(a,b)b/a, 'a', 'V'), @isnumeric);
    addParameter(p, 'alt'  , RequiredArg().alt().yields(@atmos,'T','a','P'), @isnumeric);
    addParameter(p, 'dt'   , RequiredArg().alt(), @isnumeric);
    addParameter(p, 'M1'   , RequiredArg().alt().convert(@(a,b)b/a, 'a', 'V1'), @isnumeric);
    addParameter(p, 'M2'   , RequiredArg().alt().convert(@(a,b)b/a, 'a', 'V2'), @isnumeric);
    addParameter(p, 'V'    , RequiredArg().alt().convert(@(a,b)mean([a,b]), 'V1', 'V2').convert(@(a,b)a*b, 'a', 'M'), @isnumeric);
    addParameter(p, 'dV'   , RequiredArg().alt().convert(@(a,b)b-a, 'V1', 'V2'), @isnumeric);
    addParameter(p, 'V1'   , RequiredArg().alt().convert(@(a,b)a*b, 'a', 'M1'), @isnumeric);
    addParameter(p, 'V2'   , RequiredArg().alt().convert(@(a,b)a*b, 'a', 'M2'), @isnumeric);
    addParameter(p, 'Throttle', 'max');
end

try
    arg = RequiredArg.check(p, vars);
catch ME
    throwAsCaller(ME);
end   

WL = arg.WL;
beta = arg.beta;
TR = arg.TR;
T = arg.T;
a = arg.a;
P = arg.P;
dVdt = arg.dVdt;
M = arg.M;
Throttle = arg.Throttle;
end


