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
            [theta, M0] = parsetf(varargin);
            tfsc = tfsc_simple(theta, M0, e.ctfsc.C1, e.ctfsc.C2);
        end
    end
end

function [A, B, C, D, C1, C2] = parseconstants(vars)
import PropPrelib.*
persistent p
if isempty(p)
    p = ArgParser;
    p.addRequiredParameter('A' , @(x)isnumeric(x)&&isscalar(x));
    p.addRequiredParameter('B' , @(x)isnumeric(x)&&isscalar(x));
    p.addRequiredParameter('C' , @(x)isnumeric(x)&&isscalar(x));
    p.addRequiredParameter('D' , @(x)isnumeric(x)&&isscalar(x));
    p.addRequiredParameter('C1', @(x)isnumeric(x)&&isscalar(x));
    p.addRequiredParameter('C2', @(x)isnumeric(x)&&isscalar(x));
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
        p.addRequiredParameter('theta_0', @isnumeric).setOptionalPositional('theta_0');
        p.addRequiredParameter('delta_0', @isnumeric).setOptionalPositional('delta_0');
        p.addRequiredParameter('TR', @isnumeric).setOptionalPositional('TR');
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

function [theta, M0] = parsetf(vars)
    if length(vars) == 2
        [theta, M0] = deal(vars{:});
        return;
    end
    import PropPrelib.*
    persistent p
    if isempty(p)
        p = ArgParser;
        addParameter(p, 'theta', RequiredArg, @isnumeric);
        addParameter(p, 'M0', RequiredArg, @isnumeric);
    end

    try
        arg = parse(p, vars{:});
    catch ME
        throwAsCaller(ME)
    end   

    theta = arg.theta;
    M0 = arg.M0;
end