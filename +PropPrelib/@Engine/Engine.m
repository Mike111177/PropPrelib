classdef Engine
    methods (Abstract)
        [lapse, varargout] = thrustLapse(e, varargin),
        [tfsc, varargout] = tfsc(e, varargin),
    end
    methods(Static)
        function e = CreateEngine(type, varargin)
            import PropPrelib.EngineModels.*
            switch (type)
                case 'LBTF'
                    switch (nargin)
                        case 2
                            cMax.A = 1; cMax.B = -3.5;
                            cMax.C = 1; cMax.D = 1;
                            %Eq 3.55b
                            cMax.C1 = 1.6;
                            cMax.C2 = 0.27;

                            cMil.A = 0.6; cMil.B = -2.28;
                            cMil.C = 1; cMil.D = 1;
                            %Eq 3.55a
                            cMil.C1 = 0.9;
                            cMil.C2 = 0.30;

                            e = EngineMaxMil(cMax, cMil);
                        case {3,4}
                            e = LBTF(varargin{:});
                    end
            end
        end
    end
end

