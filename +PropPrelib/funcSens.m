function sens = funcSens(func,base,varin, varout, diff)

if nargin == 4
    diff = 0.001;
end

types = cell(1,length(varout));
for i = 1:numel(types)
    types{i} = 'double';
end

ref = func(base);
sens = table('Size', [length(varin), length(varout)],...
             'VariableTypes',types,...
             'RowNames', varin,...
             'VariableNames', varout);

for i = 1:length(varin)
    name = varin{i};
    nvars = base;
    nvars.(name) = nvars.(name)*(1+diff);
    refi = func(nvars);
    for j = 1:length(varout)
        rname = varout{j};
        sens.(rname)(i) = ((refi.(rname) - ref.(rname))/ref.(rname))/diff;
    end   
end

