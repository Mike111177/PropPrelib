classdef EngineMaxMil < PropPrelib.Engine
    properties
        mMax,
        mMil
    end
    methods
        function e = EngineMaxMil(cMax, cMil)
            import PropPrelib.EngineModels.*
            e.mMax = EngineSimple(cMax);
            e.mMil = EngineSimple(cMil);
        end
        function lapse = thrustLapse(e, varargin)
            p = parsevarstl();
            arg = parse(p, varargin{:});
            lapseMax = e.mMax.thrustLapse(p);
            lapseMil = e.mMil.thrustLapse(p);
            lapse = lapseMil + t2ab(arg.AB).*(lapseMax - lapseMil);
        end
        function tfsc = tfsc(e, varargin)
            p = parsevarstf();
            arg = parse(p, varargin{:});
            tfscMax = e.mMax.tfsc(p);
            tfscMil = e.mMil.tfsc(p);
            tfsc = tfscMil + t2ab(arg.AB).*(tfscMax - tfscMil);
        end
    end
    methods (Access = private)
        function m = subModel(e, AB)
            switch (AB)
                case 0
                    m = e.mMil;
                case 1
                    m = e.mMax;
            end
        end
    end
end

function [parser] = parsevarstl()
    persistent p
    if isempty(p)
        import PropPrelib.*
        p = ArgParser;
        p.addRequiredParameter('theta_0', @isnumeric).setOptionalPositional('theta_0');
        p.addRequiredParameter('delta_0', @isnumeric).setOptionalPositional('delta_0');
        p.addRequiredParameter('TR', @isnumeric).setOptionalPositional('TR');
        p.addRequiredParameter('AB');
    end
    parser = p;
end

function [parser] = parsevarstf()
    persistent p
    if isempty(p)
        import PropPrelib.*
        p = ArgParser;
        p.addRequiredParameter('theta', @isnumeric);
        p.addRequiredParameter('M0', @isnumeric);
        p.addRequiredParameter('AB');
    end
    parser = p;
end

function AB = t2ab(t)
    if isnumeric(t)
        AB = t;
    else
        switch (lower(t))
            case 'mil'
                AB = 0;
            case 'max'
                AB = 1;
        end
    end
end
            
            
            
            
            