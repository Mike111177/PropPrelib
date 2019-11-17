function [r] = build_stations()
vars = {'T', 'P', 'R', 'gamma', 'Cp', 'h', 'M', 'V', 'a', 'Tt', 'Pt', 'f', 'mdot'};
for i = 1:length(vars)
    r.(vars{i}) = nv;
end
end

function m = nv()
m = containers.Map('KeyType','double','ValueType','double');
end

