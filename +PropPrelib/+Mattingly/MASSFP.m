function [TtdT, PtdP, MFP] = MASSFP(Tt, f, M)
BTU_to_ft_lb = 780;
import PropPrelib.*
import PropPrelib.Mattingly.*
% Inputs: Case, Tt, f, and M
% Outputs: Tt/T, Pt/P, and MFP
[Tt, ht, Prt, phit, cpt, Rt, gammat, at] = FAIR(1, f, Tt);
V = (M*at)/(1+((gammat-1)/2)*M^2);
while true %Label A
    h = ht - V^2/(2*gc)/BTU_to_ft_lb;
    [T, ~, Pr, phi, cp, R, gamma, a] = FAIR(2, f, NaN, h);
    Vn = M*a;
    if V ~= 0 
        Verror = (V-Vn)/V;
    else
        Verror = (V-Vn);
    end
    if abs(Verror)>0.00001
        V = Vn;
        continue; %Goto A
    else
        break;
    end
end
TtdT = Tt/T;
PtdP = Prt/Pr;
MFP = M/PtdP*sqrt((gamma*gc)/R*TtdT);
end