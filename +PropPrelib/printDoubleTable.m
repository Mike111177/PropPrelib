function printDoubleTable(tabnames, tabs)
import PropPrelib.formatVariables
%Init
tabsl = length(tabs);
rows = {};
cols = {};
for k = 1:tabsl
    cols = union(cols, tabs{k}.Properties.VariableNames);
    rows = union(rows, tabs{k}.Properties.RowNames);
end

rowsl = length(rows);
colsl = length(cols);
tabsl = length(tabs);

boxes = strings(rowsl, colsl*tabsl);

%Build
for i = 1:rowsl
    rowname = rows{i};
    for j = 1:colsl
        colname = cols{j};
        for k = 1:tabsl
            currtab = tabs{k};
            try
                boxes(i,j+(k-1)*colsl) = string(currtab{rowname, colname});
            catch ME
                boxes(i,j+(k-1)*colsl) = "-";
            end
        end
    end
end

%Create Headers
rowheads = string(rows);
colheads = string(cols);
tabheads = string(tabnames);

%Format Variable Headers
rowheads = formatVariables(rowheads);
colheads = formatVariables(colheads);

%Calculate header sizes
maxbox = max(max(strlength(boxes)));
maxvar = max(strlength(colheads));
maxtab = max(strlength(tabheads));
maxrn = max(strlength(rowheads));
colw = max([maxbox, maxvar, maxtab/colsl]);
tabw = colw*colsl+colsl-1;

%Pad Data
boxes = pad(boxes, colw, 'left');
colheads = pad(colheads, colw, 'both');
rowheads = pad(rowheads, maxrn, 'right');
tabheads = pad(tabheads, tabw, 'both');

%Create Spacers
padcorner = pad("", maxrn);
colun = pad("", colw, '_');
tabun = pad("", tabw, '_');

%Format Headers
rowheads = strcat("<strong>", rowheads, "</strong>");
colheads = strcat("<strong>", colheads, "</strong>");
tabheads = strcat("<strong>", tabheads, "</strong>");

%Build Table String
%Table Names
out = strcat(padcorner, " ", strjoin(tabheads, " "), '\n');
%Table name Underlines
out = strcat(out, padcorner);
for k = 1:tabsl
    out = strcat(out, " ", tabun);
end
out = strcat(out, '\n');
%Column names
out = strcat(out, padcorner);
for k = 1:tabsl
    out = strcat(out, " ", strjoin(colheads));
end
out = strcat(out, '\n');
% Column Name Underline
out = strcat(out, padcorner);
for k = 1:tabsl
    for j = 1:colsl
        out = strcat(out, " ", colun);
    end
end
out = strcat(out, '\n');
%Rows and data
for i = 1:rowsl
    out = strcat(out, rowheads(i), " ", strjoin(boxes(i,:), ' '), '\n');
end
    

fprintf(out);

end
    


