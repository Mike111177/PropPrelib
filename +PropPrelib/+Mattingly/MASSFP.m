function [TtdT, PtdP, MFP] = MASSFP(Tt, f, M)
import PropPrelib.Mattingly.*
% Inputs: Case, Tt, f, and M
% Outputs: Tt/T, Pt/P, and MFP
[Tt, ht, Prt, phit, cpt, Rt, gammat, at] = FAIR(1, f, Tt);
V = Mat/(1+((gammat-1)/2)*M^2);
while true %Label A
    h = ht - V^2/2*gc;
    [T, h, Pr, phi, cp, R, gamma, a] = FAIR(2, f, NaN, h);
    Vn = Ma;
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