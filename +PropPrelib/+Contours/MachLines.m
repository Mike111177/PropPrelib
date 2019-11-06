function v = MachLines(alt, maxmach)
    import PropPrelib.*
    if nargin == 1
        maxmach = 1;
    end
    [~, ml] = atmos(alt);
    for i = 1:maxmach
        v(i,:) = ml.*i;
    end
end
