function tfsc = tfsc_simple(theta, M0, C1, C2)    
    tfsc = (C1 + C2.*M0).*sqrt(theta)/3600;
end 