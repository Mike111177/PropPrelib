classdef LBTF < PropPrelib.Engine
    properties
        design_parameters,
        reference_conditions,
        mdot
    end
    
    methods
        function obj = LBTF(design, mdot)
            import PropPrelib.Matttingly.MFTEPCA
            
            obj.design_parameters = design;
            obj.reference_conditions = MFTEPCA(design);
            if nargin == 2
                obj.mdot = mdot;
            else
                obj.mdot = 100;
            end
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

