function r = design_point(d,r)
import PropPrelib.MFP
r.PTOL = r.h(0)*r.mdot(0)*d.CTOL;
r.PTOH = r.h(0)*r.mdot(0)*d.CTOH;

%Tau f, Eta f, Tau cL, Eta cL, Tau cH, Eta cH, T ti
r.Tt(2) = r.Tt(0);

r.Tau_f = d.Pi_f^((r.gamma(0)-1)/(r.gamma(0)*d.e_f));
Tau_fi = d.Pi_f^((r.gamma(0)-1)/r.gamma(0));
r.Eta_f = (Tau_fi - 1)/(r.Tau_f-1); % 4.9a-CPG
T_t13 = r.Tau_f*r.Tt(2);

r.Tau_cL = d.Pi_cL^((r.gamma(0)-1)/(r.gamma(0)*d.e_cL));
Tau_cLi = d.Pi_cL^((r.gamma(0)-1)/r.gamma(0));
r.Eta_cL = (Tau_cLi - 1)/(r.Tau_cL-1); % 4.9b-CPG
r.Tt(2.5) = r.Tau_cL*r.Tt(2);

r.Tau_cH = d.Pi_cH^((r.gamma(0)-1)/(r.gamma(0)*d.e_cH));
Tau_cHi = d.Pi_cH^((r.gamma(0)-1)/r.gamma(0));
r.Eta_cH = (Tau_cHi - 1)/(r.Tau_cH-1); % 4.9c-CPG
r.Tt(3) = r.Tau_cH*r.Tt(2.5);

%f, Tau_L
r.Tau_L = (d.C_pt*d.Tt4)/(r.Cp(0)*r.T(0));  % 4.6c-CPG
r.f(4) = (r.Tau_L - r.Tau_r*r.Tau_cL*r.Tau_cH)/(d.h_Pr*d.Eta_b/r.h(0) - r.Tau_L);

bee = (1 - d.Beta - d.Eps_1 - d.Eps_2);
beef = bee*(1+r.f(4));

r.Tau_m1 = (beef + d.Eps_1*r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L)/(beef + d.Eps_1);        %(H.5)
r.Tau_tH = 1 - (r.Tau_r*r.Tau_cL*(r.Tau_cH-1) + (1+d.alpha)*d.CTOH/d.Eta_mPH)/...      %(H.6)
                (d.Eta_mH*r.Tau_L*(beef + d.Eps_1*r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L));
       
r.Tau_m2 = (beef + d.Eps_1 + d.Eps_2*(r.Tau_r*r.Tau_cL*r.Tau_cH/(r.Tau_L*r.Tau_m1*r.Tau_tH)))/...
   (beef + d.Eps_1 + d.Eps_2); %(H.8)
r.Tau_tL = 1 - (r.Tau_r*((r.Tau_cL-1) + d.alpha*(r.Tau_f-1)) + (1 + d.alpha)*d.CTOL/d.Eta_mPL)/...           
    (d.Eta_mL*r.Tau_L*r.Tau_tH*(beef + (d.Eps_1+d.Eps_2/r.Tau_tH)*(r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L)));%(H.9)

%Coolant Mixers
r.f(4.1) = r.f(4)/(1+r.f(4)+d.Eps_1/bee);
r.f(4.5) = r.f(4)/(1+r.f(4)+(d.Eps_1+d.Eps_2)/bee);
            
%Pi_tH, Eta_tH, Pi_tL, Eta_tL, T_ti
T_t4p1 = r.Tau_m1*d.Tt4;

r.Pi_tH = r.Tau_tH^(d.gamma_t/((d.gamma_t-1)*d.e_tH));
Tau_tHi = r.Pi_tH^((d.gamma_t-1)/d.gamma_t);
r.Eta_tH = (1-r.Tau_tH)/(1-Tau_tHi); % 4.9d-CPG
T_t4p4 = r.Tau_tH*T_t4p1;

T_t4p5 = r.Tau_m2*T_t4p4;

r.Pi_tL = r.Tau_tL^(d.gamma_t/((d.gamma_t-1)*d.e_tL));
Tau_tLi = r.Pi_tL^((d.gamma_t-1)/d.gamma_t);
r.Eta_tL = (1-r.Tau_tL)/(1-Tau_tLi); % 4.9e-CPG     
r.Tt(5) = r.Tau_tL*T_t4p5;

T_t16 = T_t13;
r.Tt(6) = r.Tt(5);
r.f(16) = 0; r.f(6) = r.f(4.5);

r.Tt16__dT0 = T_t16/r.T(0);
r.Tt6__dT0 = r.Tt(6)/r.T(0);

alpha_p = d.alpha/(beef + d.Eps_1 + d.Eps_2); %(H.11)

f_6A = r.f(6)/(1+alpha_p);
P_t16dP_t6 = d.Pi_f/(d.Pi_cL*d.Pi_cH*d.Pi_b*r.Pi_tH*r.Pi_tL);

%Tau M, CP M, R M, Gamma M, MFP_6
h_t16__dh_t6 = (r.Tau_r*r.Tau_f)/(r.Tau_L*r.Tau_m1*r.Tau_tH*r.Tau_m2*r.Tau_tL); %G.3
r.Tau_M = (1 + alpha_p*h_t16__dh_t6)/(1+alpha_p); %G.4

R_t = d.C_pt - d.C_pt/d.gamma_t;
R_6 = R_t;
R_16 = r.R(0);
C_p6 = d.C_pt;
C_p16 = r.Cp(0);
gamma_6 = C_p6/(C_p6-R_6);
gamma_16 = r.gamma(0);

r.CP_M = Mix(C_p6, C_p16, alpha_p);
R_M = Mix(R_6, R_16, alpha_p);
r.Gamma_M = r.CP_M/(r.CP_M-R_M);

[TtdT_6, PtdP_6, MFP_6] = MFP(d.M6, r.Gamma_M, R_M);

T_6 = r.Tt(6)/TtdT_6;
PtdP_16 = PtdP_6*P_t16dP_t6;

%M_16, MFP_16
        TtdT_16 = PtdP_16^((gamma_16-1)/gamma_16);
        r.M16 = sqrt(2*(TtdT_16 - 1)/(gamma_16-1));
        
        [TtdT_16, PtdP_16, MFP_16] = MFP(r.M16, gamma_16, R_16);      

r.A16__dA6 = alpha_p * sqrt(T_t16/r.Tt(6)) / P_t16dP_t6 * (MFP_6/MFP_16);
A_6dA_6A = 1/(1+r.A16__dA6);

% T_t6A
T_t6A = r.Tt(6)*r.Tau_M;

%MFP_6A
Constant = sqrt(R_6*T_6/gamma_6) * ((1+gamma_6*d.M6^2) + r.A16__dA6*(1+gamma_16*r.M16^2))/(d.M6*(1+alpha_p));
M6Ai = d.M6;%initial
        gamma_6A = r.Gamma_M;
        R_6A = R_M;        
        while true %Label B
            [TtdT_6A, PtdP_6A, MFP_6A] = MFP(M6Ai, gamma_6A, R_6A); 
            T_6A = T_t6A*TtdT_6A;
            r.M6A = sqrt(R_6A*T_6A/gamma_6A)*(1+gamma_6A*M6Ai^2)/Constant; %(H.14)
            if abs(r.M6A-M6Ai)>0.0001
               M6Ai = r.M6A;
               continue; %Goto B
            end
            break;
        end

Pi_Mideal = (1 + alpha_p)*sqrt(r.Tau_M)*A_6dA_6A*MFP_6/MFP_6A;
r.Pi_M = d.Pi_Mmax*Pi_Mideal; %(H.15)

Tt7 = d.Tt7;

C_p7 = d.C_pAB;
Tau_LAB = (C_p7*Tt7)/(r.Cp(0)*r.T(0));
r.f_AB = (1+r.f(4)*bee/(1+d.alpha-d.Beta))*...
            (Tau_LAB - r.Tau_L*r.Tau_m1*r.Tau_tH*r.Tau_m2*r.Tau_tL*r.Tau_M)/...
            (d.h_Pr*d.Eta_AB/r.h(0) - Tau_LAB); %(H.16)
r.f(7) = f_6A + r.f_AB;

r.f_o = r.f(7);
r.Tt(9) = Tt7; 
end

function x = Mix(a, b, r)
    x = (a+b*r)/(1+r);
end
