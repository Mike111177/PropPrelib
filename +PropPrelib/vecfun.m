function varargout = vecfun(fun, vec, varargin)
    outputArgs = nargout(fun);
    elements = numel(vec);
    global PARALLEL_VECTORS;
    if PARALLEL_VECTORS
        out = cell(1,elements);
        [out{:}] = deal(cell(1,3));
        parfor i=1:elements
            out{i} = runfun(fun, vec(i), outputArgs, varargin);
        end
        [varargout{1:outputArgs}] = deal(zeros(size(vec)));
        for i = 1:outputArgs
            for j = 1:elements
                varargout{i}(j) =  out{j}{i};
            end
        end
    else
        if nargin>2
            args = varargin;
            fun = @(x)fun(x, args{:});
        end
        [varargout{1:outputArgs}] = arrayfun(fun,vec);
    end
end

function outputs = runfun(fun, ele, outputArgs, args)
    outputs = cell(1, outputArgs);
    [outputs{:}] = fun(ele,args{:});
end


