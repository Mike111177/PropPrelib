classdef ArgParser<inputParser
    properties(Access = private)
        dargs,
        defaults,
        yielders,
        required
    end
    methods
       function [arg, unmatched] = parse(p, varargin)
            import PropPrelib.RequiredArg
            %Populate Database
            if isempty(p.dargs)
                parse@inputParser(p);
                p.dargs = p.Results;
                p.defaults = p.UsingDefaults;
                for k = 1:numel(p.defaults)
                    name = p.defaults{k};
                    value = p.dargs.(name);
                    if isa(value,'RequiredArg')
                        if ~value.is_alt
                            p.required.(name) = value;
                        end
                        if ~isempty(value.yielded)
                            p.yielders.(name) = value;
                        end
                    end
                end
            end
            %Parse Args
            parse@inputParser(p,varargin{:});
            arg = p.Results;
            unmatched = p.Unmatched;
            % If there are unspecified arguments
            if ~isempty(p.UsingDefaults)
                %Resolve Yields
                if ~isempty(p.yielders)
                    names = fieldnames(p.yielders);
                    for k = 1:numel(names)
                        name = names{k};
                        value = p.yielders.(name);
                        if ~isa(arg.(name),'RequiredArg')
                            [yielded_values{1:nargout(value.yielded.f)}] = value.yielded.f(arg.(name));
                            for i = 1:numel(value.yielded.args)
                                fname = value.yielded.args{i};
                                if isa(arg.(fname),'RequiredArg')
                                    arg.(fname) = yielded_values{i};
                                end                  
                            end
                        end
                    end
                end
                %Try to resolve conversions
                argnames = fieldnames(p.required);
                for k = 1:numel(argnames)
                    r = arg.(argnames{k});
                    if isa(r,'RequiredArg')
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

