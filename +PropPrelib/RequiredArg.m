classdef RequiredArg
    methods(Static)
        function arg = check(parser, vars)
            import PropPrelib.*
            parse(parser,vars{:});
            arg = parser.Results;
            argnames = fieldnames(arg);
            for k = 1:numel(argnames)
                if isa(arg.(argnames{k}),'RequiredArg')
                    error(['Parameter ''' argnames{k} ''' must be defined.']);
                end
            end
        end
    end
end

