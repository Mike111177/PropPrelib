function varargout = vecfun(fun, vec, varargin)
    outputArgs = nargout(fun);
    if nargin>2
        args = varargin;
        fun = @(x)fun(x, args{:});
    end
    [varargout{1:outputArgs}] = arrayfun(fun,vec);
end


