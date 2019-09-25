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
            lapseMax = e.subModel(1).thrustLapse(other);
            lapseMil = e.subModel(0).thrustLapse(other);
            lapse = interp1([0, 1], [lapseMil, lapseMax], AB);
        end
        function tfsc = tfsc(e, varargin)
            [AB, other] = parsevars(varargin);
            tfscMax = e.subModel(1).tfsc(other);
            tfscMil = e.subModel(0).tfsc(other);
            tfsc = interp1([0, 1], [tfscMil, tfscMax], AB);
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
    import PropPrelib.RequiredArg
    persistent p
    if isempty(p)
        p = inputParser;
        p.KeepUnmatched = true;
        addParameter(p, 'AB', RequiredArg);
    end
    try
        [arg, other] = RequiredArg.check(p, vars);
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
            
            
            
            
            