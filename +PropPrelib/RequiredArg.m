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
    methods(Static)
        function arg = check(p, vars)
            import PropPrelib.RequiredArg
            parse(p);
            dargs = p.Results;
            defaults = p.UsingDefaults;
            parse(p,vars{:});
            arg = p.Results;
            for k = 1:numel(defaults)
                name = defaults{k};
                value = dargs.(name);
                if isa(value,'RequiredArg') && ~isempty(value.yielded) && ~isa(arg.(name),'RequiredArg')
                    [yielded_values{1:nargout(value.yielded.f)}] = value.yielded.f(arg.(name));
                    for i = 1:numel(value.yielded.args)
                        fname = value.yielded.args{i};
                        if isa(arg.(fname),'RequiredArg')
                            arg.(fname) = yielded_values{i};
                        end                  
                    end
                    
                end
            end
            argnames = fieldnames(arg);
            for k = 1:numel(argnames)
                r = arg.(argnames{k});
                if isa(r,'RequiredArg') && ~r.is_alt
                    if isempty(r.conversions)
                        error(['Parameter ''' argnames{k} ''' must be defined.']);
                    else
                        [arg, s] = resolve(r, argnames{k}, arg);
                        if ~s
                            error('Parameter %s must be defined.\nIt could not be resolved.', argnames{k});
                        end
                    end
                end
            end
        end
    end
    
end

function [arg, s] = resolve(r, name, arg, trail)
    import PropPrelib.RequiredArg
    s = false;
    if nargin == 3
        trail = {};
    end
    for conv = r.conversions
        cs = true;
        conv_args = cell(1,length(conv.args));
        for k = 1:numel(conv.args)
            fieldname = conv.args{k};
            fvalue = arg.(fieldname);
            if isa(fvalue,'RequiredArg')
                if isempty(fvalue.conversions)   
                    cs = false;
                    break;
                elseif ~any(strcmp(trail, fieldname))%Avoid looping
                    [arg, ts] = resolve(fvalue, fieldname, arg,[trail, fieldname]);
                    if ~ts
                        cs = false;
                        break;
                    end
                else
                    cs = false;
                    break;
                end
            end
            conv_args{k} = arg.(fieldname);
        end
        if cs
            arg.(name) = conv.f(conv_args{:});
            s = true;
            break;
        end
    end

end

