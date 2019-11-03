function reference_performance = MFTEPCAABOff(reference_design, heatmodel)
%MFTEPCAABOFF Summary of this function goes here
%   Detailed explanation goes here
import PropPrelib.Mattingly.MFTEPCA
% reference_design.Tt7 = reference_design.Tt4;
% reference_design.Pi_AB = 1;
% reference_design.Eta_AB = 1;
% 
% if isfield(reference_design, 'C_pt')
%     reference_design.C_pAB = reference_design.C_pt;
% end
% if isfield(reference_design, 'gamma_t')
%     reference_design.gamma_AB = reference_design.gamma_t;
% end

reference_design.AB = 0;

switch nargin
    case 1
        reference_performance = MFTEPCA(reference_design);
    case 2
        reference_performance = MFTEPCA(reference_design, heatmodel);
end

end

