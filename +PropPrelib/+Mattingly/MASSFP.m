function [TtdT, PtdP, MFP] = MASSFP(Tt, f, M, ht, Prt, gammat, at)
BTU_to_ft_lb = 780;
import PropPrelib.*
import PropPrelib.Mattingly.*
% Inputs: Case, Tt, f, and M
% Outputs: Tt/T, Pt/P, and MFP

% -------------- Mattingly -------------------
% [Tt, ht, Prt, phit, cpt, Rt, gammat, at] = FAIR(1, f, Tt);
% V = (M*at)/(1+((gammat-1)/2)*M^2);
% while true %Label A
%     h = ht - V^2/(2*gc)/BTU_to_ft_lb;
%     [T, ~, Pr, phi, cp, R, gamman, a] = FAIR(2, f, NaN, h);
%     Vn = M*a;
%     if V ~= 0 
%         Verror = (V-Vn)/V;
%     else
%         Verror = (V-Vn);
%     end
%     if abs(Verror)>0.00001
%         V = Vn;
%         continue; %Goto A
%     else
%         break;
%     end
% end

% -------------- Equivelent -------------------
gamman=NaN;R=NaN;Pr=NaN;T=NaN;
if nargin < 7
    [~, ht, Prt, ~, ~, ~, gammat, at] = FAIR(1, f, Tt);
end
Vguess = (M*at)/(1+((gammat-1)/2)*M^2);
fminsearch(@vals, Vguess);
function Verror = vals(V)
    import PropPrelib.gc;
    import PropPrelib.Mattingly.FAIR;
    h = ht - V^2/(2*gc)/BTU_to_ft_lb;
    [T, ~, Pr, ~, ~, R, gamman, a] = FAIR(2, f, NaN, h);
    Vn = M*a;
    if V ~= 0 
        Verror = abs((V-Vn)/V);
    else
        Verror = abs(V-Vn);
    end
end

TtdT = Tt/T;
PtdP = Prt/Pr;
MFP = M/PtdP*sqrt((gamman*gc)/R*TtdT);
end



