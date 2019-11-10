function [Pi_tH, Tau_tH, T_t4p5] = TURBC(Tt4, f, A4dA4p5, M4, M4p5, EtatH, Tt4p5R, Tt3, Beta, Eps1, Eps2)
import PropPrelib.Mattingly.*
[~, ht4, Prt4, phit4, Cpt4, Rt4, gammat4, at4] = FAIR(1, f, Tt4);
[T4, P4, MFP4] = MASSFP(Tt4, f, M4);
[~, ht3, Prt3, phit3, Cpt3, Rt3, gammat3, at3] = FAIR(1, f, Tt3);
mdotf = f*(1-Beta-Eps1-Eps2);
mdot4 = (1+f)*(1-Beta-Eps1-Eps2);
mdot4p1 = (1+f)*(1-Beta-Eps1-Eps2) + Eps1;
mdot4p5 = (1+f)*(1-Beta-Eps1-Eps2) + Eps1 + Eps2;
f4p1 = mdotf/(mdot4p1-mdotf);
f4p5 = mdotf/(mdot4p5-mdotf);
ht4p1 = (mdot4*ht4+Eps1*ht3)/(mdot4+Eps2);% Typo in mattingly?
[Tt4p1, ~, Prt4p1, phit4p1, Cpt4p1, Rt4p1, gammat4p1, at4p1] = FAIR(2, f, NaN, ht4p1);
T_t4p5 = Tt4p5R;
while true % Label 1
    [T4p5, P4p5, MFP4p5] = MASSFP(T_t4p5, f4p5, M4p5);
    Pi_tH = (mdot4p5/mdot4)*(MFP4/MFP4p5)*A4dA4p5*sqrt(T_t4p5/Tt4);
    [~, ht4p5, Prt4p5, phit4p5, Cpt4p5, Rt4p5, gammat4p5, at4p5] = FAIR(1, f4p5, T_t4p5);
    Prt4p4i = Pi_tH*Prt4p1;
    [Tt4p4i, ht4p4i, ~, phit4p4i, Cpt4p5, Rt4p4i, gammat4p4i, at4p4i] = FAIR(3, f4p1, NaN, NaN, Prt4p4i);
    ht4p4 = ht4p1-EtatH*(ht4p1-ht4p4i);
    Tau_tH = ht4p4/ht4p1;
    ht4p5 = (mdot4p1*ht4p4+Eps1*ht3)/(mdot4p1+Eps2);
    [Tt4p5n, ~, Prt4p5, phit4p5, Cpt4p5, Rt4p5, gammat4p5, at4p5] = FAIR(2, f4p5, NaN, ht4p5);
    if abs(T_t4p5 - Tt4p5n) > 0.01
        T_t4p5 = Tt4p5n;
        continue; % Goto 1
    else
        break; %Exit Loop
    end
end
end

