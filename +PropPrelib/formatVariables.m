function labels = formatVariables(labels)
    labels = strrep(labels, "__d", "/");
    labels = strrep(labels, "_", " ");
end

