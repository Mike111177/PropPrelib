classdef EngineSimple < PropPrelib.Engine    
    properties
        cthrust
        ctfsc
    end
    
    methods
        function e = EngineSimple(varargin)
            [e.cthrust.A, e.cthrust.B, e.cthrust.C, e.cthrust.D,...
                e.ctfsc.C1, e.ctfsc.C2] = parseconstants(varargin);
        end
        function lapse = thrustLapse(e, varargin)
            lapse = thrust_lapse_simple(varargin{:}, e.cthrust);
        end
        function tfsc = tfsc(e, varargin)
            tfsc = tfsc_simple(varargin{:}, e.ctfsc);
        end
    end
end

function [A, B, C, D, C1, C2] = parseconstants(vars)
import PropPrelib.RequiredArg
persistent p
if isempty(p)
    p = inputParser;
    addParameter(p, 'A', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'B', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'C', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'D', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'C1', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'C2', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
end

try
    arg = RequiredArg.check(p, vars);
catch ME
    throwAsCaller(ME)
end   

A = arg.A;
B = arg.B;
C = arg.C;
D = arg.D;
C1 = arg.C1;
C2 = arg.C2;
end