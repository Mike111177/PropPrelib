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
            [theta_0, delta_0, TR] = parsetl(varargin);
            lapse = thrust_lapse_simple(theta_0, delta_0, TR,...
                                            e.cthrust.A, e.cthrust.B, e.cthrust.C, e.cthrust.D);
        end
        function tfsc = tfsc(e, varargin)
            tfsc = tfsc_simple(varargin{:}, e.ctfsc);
        end
    end
end

function [A, B, C, D, C1, C2] = parseconstants(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    addParameter(p, 'A', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'B', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'C', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'D', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'C1', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
    addParameter(p, 'C2', RequiredArg, @(x)isnumeric(x)&&isscalar(x));
end

try
    arg = parse(p, vars{:});
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

function [theta_0, delta_0, TR] = parsetl(vars)
    import PropPrelib.*
    persistent p
    if isempty(p)
        p = ArgParser;
        addParameter(p, 'theta_0', RequiredArg, @isnumeric);
        addParameter(p, 'delta_0', RequiredArg, @isnumeric);
        addParameter(p, 'TR', RequiredArg, @isnumeric)
    end

    try
        arg = parse(p, vars{:});
    catch ME
        throwAsCaller(ME)
    end   

    theta_0 = arg.theta_0;
    delta_0 = arg.delta_0;
    TR = arg.TR;
end