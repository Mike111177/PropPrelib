classdef RequiredArg
    properties
        is_alt,
        yielded,
        conversions
    end
    methods
        function r = convert(obj, f, varargin)
            conv.f = f;
            conv.args = varargin;
            obj.conversions = [obj.conversions conv];
            r = obj;
        end
        function r = yields(obj, f, varargin)
            yielder.f = f;
            yielder.args = varargin;
            obj.yielded = yielder;
            r = obj;
        end
        function r = alt(obj)
            obj.is_alt = true;
            r = obj;
        end
        function r = RequiredArg()
            r.is_alt = false;
            r.conversions = [];
        end
    end
end



