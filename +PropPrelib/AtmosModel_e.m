classdef AtmosModel_e
    properties
        modeldata
    end
    methods
        function m = AtmosModel_e(varargin)
            m.modeldata = varargin;
        end
    end
    enumeration
        Standard(9.80665, 1.4, 287.0531, 0.0065, 11000, 20000, 1.225, 101325, 288.15),
            Cold(9.80665, 1.4, 287.0531, 0.0065, 9500, 20000, 1.225, 101325, 222.10),
             Hot(9.80665, 1.4, 287.0531, 0.0065, 12000, 20000, 1.225, 101325, 312.60),
          Tropic(9.80665, 1.4, 287.0531, 0.0065, 16000, 20000, 1.225, 101325, 305.27)
    end
end
    

