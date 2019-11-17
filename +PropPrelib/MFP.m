function [TtdT, PtdP, MFP] = MFP(M, gamma, R)
    import PropPrelib.gc
    TtdT = 1+(gamma-1)/2*M^2;
    PtdP = TtdT^(gamma/(gamma-1));
    MFP = M*sqrt(gamma*gc/R)*sqrt(TtdT/PtdP);
end
