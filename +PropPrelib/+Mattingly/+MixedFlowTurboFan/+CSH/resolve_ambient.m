function [r, c] = resolve_ambient(r, d, c)
import PropPrelib.atmos
import PropPrelib.gc
import PropPrelib.Mattingly.Eta_Rspec
if nargin == 2
    c = d;
end

BTU_to_ft_lb = 780;

if isfield(c, 'Alt')
    has_T0 = isfield(c, 'T0');
    has_P0 = isfield(c, 'P0');
    if ~has_T0 || ~has_P0
        [tempT0, ~, tempP0] = atmos(c.Alt);
        if ~has_T0
            c.T0 = tempT0;
        end
        if ~has_P0
            c.P0 = tempP0;
        end
    end
end

%Ambient Gas Properties
%Copy from c
r.T(0) = c.T0;
r.P(0) = c.P0;
r.M(0) = c.M0;
r.Cp(0) = d.C_pc;
r.gamma(0) = d.gamma_c;
%Calc
r.R(0) = r.Cp(0) - r.Cp(0)/r.gamma(0);
r.a(0) = sqrt(r.gamma(0)*r.R(0)*r.T(0)*gc*BTU_to_ft_lb);
r.h(0) = r.Cp(0)*r.T(0);
r.V(0) = r.M(0)*r.a(0);

%Tau R, Pi R 
r.Tau_r = 1 + (r.gamma(0)-1)/2*r.M(0)^2;     % 4.5a-CPG
r.Pi_r = r.Tau_r^(r.gamma(0)/(r.gamma(0)-1)); % 4.5b-CPG
r.Tt(0) = r.T(0)*r.Tau_r;
r.Pt(0) = r.P(0)*r.Pi_r;
r.Pi_d = d.Pi_dmax * Eta_Rspec(r.M(0));
r.Pt(2) = r.Pt(0)*r.Pi_d;    
end

