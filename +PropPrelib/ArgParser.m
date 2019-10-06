classdef ArgParser<inputParser
    properties (Access = private)
        Yielders = {},
        Required = {},
        DefaultUnresolved = {},
        numOP = 0,
        OptionalPositionals = {},
        Defaults
    end
    properties (SetAccess = private)
        Resolved,
        Unresolved,
        RequiredAndUnresolved
    end
    methods
        function p = setOptionalPositional(p, name)
            p.numOP = p.numOP + 1;
            p.OptionalPositionals{end+1} = name;
        end
        function p = addRequiredParameter(p, name, varargin)
            import PropPrelib.RequiredArg
            p = addParameter(p, name, RequiredArg, varargin{:});
        end
        function p = addParameter(p, name, default, varargin)
            import PropPrelib.RequiredArg
            addParameter@inputParser(p, name, default, varargin{:});
            p.Defaults.(name) = default;
            if isa(default,'RequiredArg')
                p.DefaultUnresolved{end+1} = name;
                if ~default.is_alt
                    p.Required{end+1} = name;
                end
                if ~isempty(default.yielded)
                    p.Yielders{end+1} = name;
                end
            end
        end
        function [arg, unmatched] = parse(p, varargin)
            argsin = numel(varargin);
            if argsin == 1
                arg1 = varargin{1};
                %We trust preparsed args, its up to the caller to ensure validity
                if strcmp(class(arg1), 'PropPrelib.ArgParser') %#ok<STISA> This method is literally x1000 faster... why would anyone ever use isa if they wern't forced to
                    arg = arg1.Resolved;
                    p.Resolved = arg;
                    return;
                end
            end
            
            arg = struct;
            index1 = 1;
            for i = 1:min([p.numOP, argsin])
                arg1 = varargin{i};
                if ~ischar(arg1) && ~isstring(arg1) && ~isstruct(arg1)
                    index1 = index1 + 1;
                    arg.(p.OptionalPositionals{i}) = arg1;
                else
                    break;
                end
            end
            if index1<=argsin
                %Parse Args
                parse@inputParser(p, varargin{index1:end}, arg);
                arg = p.Results;
                unmatched = p.Unmatched;
                if ~isempty(p.UsingDefaults)
                    p.Unresolved = intersect(p.UsingDefaults, p.DefaultUnresolved);
                    p.RequiredAndUnresolved = intersect(p.Unresolved, p.Required);
                    % If there are unspecified Required arguments
                    if ~isempty(p.RequiredAndUnresolved)
                        %Resolve Yields
                        if ~isempty(p.Yielders)
                            set_yielders = setdiff(p.Yielders, p.Unresolved);
                            for k = 1:numel(set_yielders)
                                name = set_yielders{k};
                                value = p.Defaults.(name);
                                yielded_names = value.yielded.args;
                                if ~isempty(intersect(yielded_names, p.Unresolved))
                                    [yielded_values{1:nargout(value.yielded.f)}] = value.yielded.f(arg.(name));
                                    for i = 1:numel(yielded_names)
                                        fname = value.yielded.args{i};
                                        idx = strcmp(p.Unresolved, fname);
                                        if any(idx)
                                            arg.(fname) = yielded_values{i};
                                            p.Unresolved(idx) = [];
                                            p.RequiredAndUnresolved(strcmp(p.RequiredAndUnresolved, fname)) = [];
                                        end
                                    end
                                end
                            end
                        end
                        %Try to resolve conversions
                        while ~isempty(p.RequiredAndUnresolved)
                            name = p.RequiredAndUnresolved{1};
                            r = p.Defaults.(name);
                            if isempty(r.conversions)
                                error(['Parameter ''' name ''' must be defined.']);
                            else
                                [arg, s,resolved] = p.resolve(r, name, arg);
                                p.Unresolved = setdiff(p.Unresolved, resolved);
                                p.RequiredAndUnresolved = setdiff(p.RequiredAndUnresolved, resolved);
                                if ~s
                                    error('Parameter %s must be defined or derived from other parameters.\nIt could not be resolved.', name);
                                end
                            end
                        end
                    end
                end
            end
            p.Resolved = arg;
        end
    end
    methods(Access = private)
        function [arg, s, resolved] = resolve(p, r, name, arg, trail)
            s = false;
            resolved = {};
            if nargin == 4
                trail = {};
            end
            for conv = r.conversions
                cs = true;
                conv_args = cell(1,length(conv.args));
                for k = 1:numel(conv.args)
                    fieldname = conv.args{k};
                    if any(strcmp(p.Unresolved, fieldname))
                        fvalue = arg.(fieldname);
                        if isempty(fvalue.conversions)
                            cs = false;
                            break;
                        elseif ~any(strcmp(trail, fieldname))%Avoid looping
                            [arg, ts, tresolved] = p.resolve(fvalue, fieldname, arg,[trail, fieldname]);
                            resolved = [resolved, tresolved]; %#ok<AGROW>
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
                    resolved{end+1} = name; %#ok<AGROW>
                    s = true;
                    break;
                end
            end
        end
    end
end

