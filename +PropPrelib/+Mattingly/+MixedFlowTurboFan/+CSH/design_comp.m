function [d] = design_comp(d)
    if isfield(d, 'Pi_c')
        if ~isfield(d, 'Pi_cH')
            d.Pi_cH = d.Pi_c/d.Pi_cL;
        end
        if ~isfield(d, 'Pi_cL')
            d.Pi_cL = d.Pi_c*d.Pi_cH;
        end
    end
end

