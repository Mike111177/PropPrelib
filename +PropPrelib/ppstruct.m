function ppstruct(s, indent)
    if nargin == 1
        indent = 0;
    end
    names = fieldnames(s);
    labels = pad(string(names), 'left');
    istr = blanks(indent);
    for k = 1:numel(names)
        value = s.(names{k});
        if isnumeric(value) && isscalar(value)
            fprintf([istr '%s: %.4g\n'], labels{k}, value);
        end
    end
end

