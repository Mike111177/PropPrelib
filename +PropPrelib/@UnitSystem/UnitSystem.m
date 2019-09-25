classdef UnitSystem
    properties
        g0
    end
    methods
        function us = UnitSystem(g0)
            us.g0 = g0;
        end
    end
    enumeration
        BE(32.17),
        SI(1)
    end
end

