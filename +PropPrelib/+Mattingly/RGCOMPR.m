%Appendix F
function [M, TtdT, PtdP, MFP] = RGCOMPR (Item, Tt, M, f, TtdT, PtdP, MFP)
% Inputs: Item, Tt, f, and one of the following: M, Tt/T, Pt/P, and MFP
% Outputs: M, Tt/T, Pt/P, and MFP
import PropPrelib.Mattingly.*
import PropPrelib.gc
BTU_to_ft_lb = 780;
switch (Item)
    case 1 % Mach known
        [TtdT, PtdP, MFP] = MASSFP(Tt, f, M);
    case {2, 3} % Tt/T or Pt/P known
        [Tt, ht, Prt, phi_t, cpt, Rt, gamma_t, at] = FAIR (1, f, Tt);
        if Item == 2
            T = Tt/TtdT;
            [T, h, Pr, phi, cp, R, gamma, a] = FAIR(2, f, T);
        else
            Pr = Prt/PtdP;
            [T, h, Pr, phi, cp, R, gamma, a] = FAIR(3, f, NaN, NaN, Pr);
        end
        Vp2 = 2*(ht - h)*gc*BTU_to_ft_lb;
        if Vp2 < 0
            M = 0;
            T = Tt;
        else
            M = sqrt(Vp2)/a;
        end
        [TtdT, PtdP, MFP] = MASSFP(Tt, f, M);
    case {4, 5} %MFP known
        if Item == 4
            M = 2;
        else
            M = 0.5;
        end
        dM = 0.1;
        [TtdT, PtdP, MFP_0] = MASSFP(Tt, f, M);
        while true %Label 4.... yes he uses goto statements
            M = M + dM; 
            [TtdT, PtdP, MFP_n] = MASSFP (Tt, f, M);
            MFP_error = abs(MFP_n - MFP_0);
            if MFP_error > 0.00001
                dM = (MFP - MFP_n)/(MFP_n - MFP_0)*dM;
                MFP_0 = MFP_n;
                continue; %GOTO 4
            end
            break; %gotos lol
        end
end