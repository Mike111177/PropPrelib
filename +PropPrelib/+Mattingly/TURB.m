function [Pi_t, Tau_t, T_te] = TURB(Tti, f, AidAe, Mi, Me, Etat, TteR)
% Inputs: Tti, f, (Ai /Ae), Mi, Me, Eta_t, TteR
% Outputs: Pi_t, Tau_t, Tte
import PropPrelib.Mattingly.*
[~, hti, Prti, phiti, cpti, Rti, gammati, ati] = FAIR(1, f, Tti);
[Ti, ~, MFPi] = MASSFP(Tti, f, Mi);
T_te = TteR;
while true % Label 1
    [Te, Pe, MFPe] = MASSFP(T_te, f, Me);
    [hte, Prte, phite, cpte, Rte, gammate, ate] = FAIR (1, f, T_te);
    Pi_t = (MFPi/MFPe)*AidAe*sqrt(T_te/Tti);
    Prtei = Pi_t*Prti;
    [Ttei, htei, ~, phitei, cptei, Rtei, gammatei, atei] = FAIR(3, f, NaN, NaN, Prtei);
    hte = hti - Etat*(hti - htei);
    Tau_t = (hte/hti);
    [Tten, ~, Prte, phite, cpte, Rte, gammate, ate] = FAIR(2, f, NaN, hte);
    Tte_error = abs(T_te - Tten);
    if Tte_error > 0.01
        T_te = Tten;
        continue;
    else
        break;
    end
end

