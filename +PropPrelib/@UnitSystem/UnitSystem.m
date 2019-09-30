classdef UnitSystem
    properties
        g0, gc
    end
    methods
        function us = UnitSystem(g0, gc)
            us.g0 = g0;
            us.gc = gc;
        end
    end
    enumeration
        BE(32.17,32.17),
        SI(9.8067, 1)
    end
end

