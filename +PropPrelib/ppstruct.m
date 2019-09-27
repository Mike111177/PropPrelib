function ppstruct(s, indent)
    if nargin < 2
        indent = 0;
    end
    names = fieldnames(s);
    labels = pad(string(names), 'left');
    
    lines = cell(1,numel(names));
    for k = 1:numel(names)
        value = s.(names{k});
        if isnumeric(value) && isscalar(value)
            lines{k} = sprintf('%s: %.4g', labels{k}, value);
        end
    end
    istr = blanks(indent);
    sepstr = blanks(5);
    if mod(numel(lines),2) == 1
        lines{end+1} = "";
    end
    rows = join(reshape(pad(string(lines), 'right'), [], 2), sepstr);
    for k = 1:numel(rows)
        fprintf([istr rows{k} '\n'])
    end
end

