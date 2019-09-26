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
            [AB, other] = parsevars(varargin);
            lapseMax = e.mMax.thrustLapse(other);
            lapseMil = e.mMil.thrustLapse(other);
            lapse = lapseMil + AB.*(lapseMax - lapseMil);
        end
        function tfsc = tfsc(e, varargin)
            [AB, other] = parsevars(varargin);
            tfscMax = e.mMax.tfsc(other);
            tfscMil = e.mMil.tfsc(other);
            tfsc = tfscMil + AB.*(tfscMax - tfscMil);
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



function [AB, other] = parsevars(vars)
    import PropPrelib.*
    persistent p
    if isempty(p)
        p = ArgParser;
        p.KeepUnmatched = true;
        addParameter(p, 'AB', RequiredArg);
    end
    try
        [arg, other] = parse(p, vars{:});
    catch ME
        throwAsCaller(ME)
    end   
    
    AB = arg.AB;
    if ~isnumeric(AB)
        AB = t2ab(AB);
    end
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
            
            
            
            
            