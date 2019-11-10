function reference_performance = MFTEPCA(reference_design, heatmodel)
BTU_to_ft_lb = 780;
BTU_lbm_to_ft2_s2 = 25037.00;
BTU_p_sec_to_KW = 1.055;
import PropPrelib.Mattingly.*
import PropPrelib.gc
import PropPrelib.atmos
d = reference_design;

if nargin == 1
    heatmodel = 1; %Default Constant Specific Heat
end

if heatmodel==3
    warning('Variable specific heat analysis is no0t complete! You may se incorrect or missing values')
end

if isfield(d, 'Pi_c')
    if ~isfield(d, 'Pi_cH')
        d.Pi_cH = d.Pi_c/d.Pi_cL;
    end
    if ~isfield(d, 'Pi_cL')
        d.Pi_cL = d.Pi_c*d.Pi_cH;
    end
end

if isfield(d, 'Alt')
    has_T_0 = isfield(d, 'T_0');
    has_P0 = isfield(d, 'P0');
    if ~has_T_0 || ~has_P0
        [tempT0, ~, tempP0] = atmos(d.Alt);
        if ~has_T_0
            d.T_0 = tempT0;
        end
        if ~has_P0
            d.P0 = tempP0;
        end
    end
end

if ~isfield(d, 'AB')
    d.AB = 1;
end

r.hmodel = heatmodel;

%Ambient Gas Properties
switch (heatmodel)
    case 1
        R_c = d.C_pc - d.C_pc/d.gamma_c;
        R_0 = R_c;
        C_p0 = d.C_pc;
        gamma_0 = d.gamma_c;
        r.a0 = sqrt(d.gamma_c*R_c*d.T_0*gc*BTU_to_ft_lb);
        r.h_0 = d.C_pc*d.T_0;
    case 3
        [~, r.h_0, P_r0, phi_0, C_p0, R_0, gamma_0, r.a0] = FAIR(1, 0, d.T_0);
end

r.V0 = d.M0*r.a0;
r.PTOL__dmdot = r.h_0*d.CTOL*BTU_p_sec_to_KW;
r.PTOH__dmdot = r.h_0*d.CTOH*BTU_p_sec_to_KW;

%Tau R, Pi R
switch (heatmodel)
    case 1 % Constant Specific Heat        
        r.Tau_r = 1 + (gamma_0-1)/2*d.M0^2;     % 4.5a-CPG
        r.Pi_r = r.Tau_r^(gamma_0/(gamma_0-1)); % 4.5b-CPG
        T_t0 = d.T_0*r.Tau_r;
    case 3 % Variable Specific Heat   
        h_t0 = r.h_0 + (r.V0^2)/(2*gc)/BTU_to_ft_lb;
        [T_t0, ~, P_rt0, phi_t0, c_pt0, R_t0, gamma_t0, a_t0] = FAIR(2, 0, NaN, h_t0);
        r.Tau_r = h_t0/r.h_0;  % 4.5a
        r.Pi_r = P_rt0/P_r0; % 4.5b
end

P_t0 = d.P0*r.Pi_r;
        

r.Pi_d = d.Pi_dmax * Eta_Rspec(d.M0);

P_t2 = P_t0*r.Pi_d;

%Tau f, Eta f, Tau cL, Eta cL, Tau cH, Eta cH, T ti
switch (heatmodel)
    case 1 % Constant Specific Heat
        T_t2 = T_t0;
        
        r.Tau_f = d.Pi_f^((gamma_0-1)/(gamma_0*d.e_f));
        Tau_fi = d.Pi_f^((gamma_0-1)/gamma_0);
        r.Eta_f = (Tau_fi - 1)/(r.Tau_f-1); % 4.9a-CPG
        T_t13 = r.Tau_f*T_t2;
        
        r.Tau_cL = d.Pi_cL^((gamma_0-1)/(gamma_0*d.e_cL));
        Tau_cLi = d.Pi_cL^((gamma_0-1)/gamma_0);
        r.Eta_cL = (Tau_cLi - 1)/(r.Tau_cL-1); % 4.9b-CPG
        T_t2p5 = r.Tau_cL*T_t2;
                
        r.Tau_cH = d.Pi_cH^((gamma_0-1)/(gamma_0*d.e_cH));
        Tau_cHi = d.Pi_cH^((gamma_0-1)/gamma_0);
        r.Eta_cH = (Tau_cHi - 1)/(r.Tau_cH-1); % 4.9c-CPG
        T_t3 = r.Tau_cH*T_t2p5;
    case 3 % Variable Specific Heat
        P_rt2 = P_rt0;
        P_rt13 = P_rt2*d.Pi_f^(1/d.e_f);
        h_t2 = h_t0;
        [T_t13, h_t13, ~, phi_t13, c_pt13, R_t13, gamma_t13, a_t13] = FAIR(3, 0, NaN, NaN, P_rt13);
        r.Tau_f = h_t13/h_t2; %(H.1)
        
        P_rt13i = P_rt2*d.Pi_f;
        [T_t13i, h_t13i, ~, phi_t13i, c_pt13i, R_t13i, gamma_t13i, a_t13i] = FAIR(3, 0, NaN, NaN, P_rt13i);
        r.Eta_f = (h_t13i - h_t2)/(h_t13 - h_t2);
        
        P_rt2p5 = P_rt2*d.Pi_cL^(1/d.e_cL);
        [T_t2p5, h_t2p5, ~, phi_t2p5, c_pt2p5, R_t2p5, gamma_t2p5, a_t2p5] = FAIR(3, 0, NaN, NaN, P_rt2p5);
        r.Tau_cL = h_t2p5/h_t2; %(H.2)
        
        P_rt2p5i = P_rt2*d.Pi_cL;
        [T_t2p5i, h_t2p5i, ~, phi_t2p5i, c_pt2p5i, R_t2p5i, gamma_t2p5i, a_t2p5i] = FAIR(3, 0, NaN, NaN, P_rt2p5i);
        r.Eta_cL = (h_t2p5i - h_t2)/(h_t2p5 - h_t2);
        
        P_rt3 = P_rt2p5*d.Pi_cH^(1/d.e_cH);
        [T_t3, h_t3, ~, phi_t3, c_pt3, R_t3, gamma_t3, a_t3] = FAIR(3, 0, NaN, NaN, P_rt3);
        r.Tau_cH = h_t3/h_t2p5; %(H.3)
        
        P_rt3i = P_rt2p5*d.Pi_cH;
        [T_t3i, h_t3i, ~, phi_t3i, c_pt3i, R_t3i, gamma_t3i, a_t3i] = FAIR(3, 0, NaN, NaN, P_rt3i);
        r.Eta_cH = (h_t3i - h_t2p5)/(h_t3 - h_t2p5);
end

%f, Tau_L
switch (heatmodel)
    case 1 % Constant Specific Heat
        r.Tau_L = (d.C_pt*d.Tt4)/(C_p0*d.T_0);  % 4.6c-CPG
        r.f = (r.Tau_L - r.Tau_r*r.Tau_cL*r.Tau_cH)/(d.h_Pr*d.Eta_b/r.h_0 - r.Tau_L);
    case 3 % Variable Specific Heat
        f4i = 0.0001;%initial
        while true
               [~, h_t4, P_rt4, phi_t4, c_pt4, R_t4, gamma_t4, a_t4] = FAIR(1, f4i, d.Tt4) %Label A
               r.f = (h_t4 - h_t3)/(d.Eta_b*d.h_Pr - h_t4); %(H.4)
               if abs(r.f-f4i)>0.0001
                   f4i = r.f;
                   continue;
               end
               break;
        end
        r.Tau_L = h_t4/r.h_0;
end

bee = (1 - d.Beta - d.Eps_1 - d.Eps_2);
beef = bee*(1+r.f);

r.Tau_m1 = (beef + d.Eps_1*r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L)/(beef + d.Eps_1);        %(H.5)
r.Tau_tH = 1 - (r.Tau_r*r.Tau_cL*(r.Tau_cH-1) + (1+d.alpha)*d.CTOH/d.Eta_mPH)/...      %(H.6)
                (d.Eta_mH*r.Tau_L*(beef + d.Eps_1*r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L));
       
r.Tau_m2 = (beef + d.Eps_1 + d.Eps_2*(r.Tau_r*r.Tau_cL*r.Tau_cH/(r.Tau_L*r.Tau_m1*r.Tau_tH)))/...
   (beef + d.Eps_1 + d.Eps_2); %(H.8)
r.Tau_tL = 1 - (r.Tau_r*((r.Tau_cL-1) + d.alpha*(r.Tau_f-1)) + (1 + d.alpha)*d.CTOL/d.Eta_mPL)/...           
    (d.Eta_mL*r.Tau_L*r.Tau_tH*(beef + (d.Eps_1+d.Eps_2/r.Tau_tH)*(r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L)));%(H.9)

%Coolant Mixers
f_4p1 = r.f/(1+r.f+d.Eps_1/bee);
f_4p5 = r.f/(1+r.f+(d.Eps_1+d.Eps_2)/bee);
            
%Pi_tH, Eta_tH, Pi_tL, Eta_tL, T_ti
switch (heatmodel)
    case 1 % Constant Specific Heat
        T_t4p1 = r.Tau_m1*d.Tt4;
        
        r.Pi_tH = r.Tau_tH^(d.gamma_t/((d.gamma_t-1)*d.e_tH));
        Tau_tHi = r.Pi_tH^((d.gamma_t-1)/d.gamma_t);
        r.Eta_tH = (1-r.Tau_tH)/(1-Tau_tHi); % 4.9d-CPG
        T_t4p4 = r.Tau_tH*T_t4p1;
        
        T_t4p5 = r.Tau_m2*T_t4p4;
        
        r.Pi_tL = r.Tau_tL^(d.gamma_t/((d.gamma_t-1)*d.e_tL));
        Tau_tLi = r.Pi_tL^((d.gamma_t-1)/d.gamma_t);
        r.Eta_tL = (1-r.Tau_tL)/(1-Tau_tLi); % 4.9e-CPG     
        T_t5 = r.Tau_tL*T_t4p5;
    case 3 % Variable Specific Heat
        h_t4p1 = h_t4*r.Tau_m1;
        [T_t4p1, ~, P_rt4p1, phi_t4p1, c_pt4p1, R_t4p1, gamma_t4p1, a_t4p1] = FAIR(2, f_4p1, NaN, h_t4p1);
        h_t4p4 = h_t4p1*r.Tau_tH;
        [T_t4p4, ~, P_rt4p4, phi_t4p4, c_pt4p4, R_t4p4, gamma_t4p4, a_t4p4] = FAIR(2, f_4p1, NaN, h_t4p4);
        r.Pi_tH = (P_rt4p4/P_rt4p1)^(1/d.e_tH); %(H.7)

        P_rt4p4i = r.Pi_tH*P_rt4p1;
        [T_t4p4i, h_t4p4i, ~, phi_t4p4i, c_pt4p4i, R_t4p4i, gamma_t4p4i, a_t4p4i] = FAIR(3, f_4p1, NaN, NaN, P_rt4p4i);
        r.Eta_tH = (h_t4p1 - h_t4p4)/(h_t4p1 - h_t4p4i);
        
        h_t4p5 = h_t4p4*r.Tau_m2;
        [T_t4p5, ~, P_rt4p5, phi_t4p5, c_pt4p5, R_t4p5, gamma_t4p5, a_t4p5] = FAIR(2, f_4p5, NaN, h_t4p5);
        h_t5 = h_t4p5 * r.Tau_tL;
        [T_t5, ~, P_rt5, phi_t5, c_pt5, R_t5, gamma_t5, a_t5] = FAIR(2, f_4p5, NaN, h_t5);
        r.Pi_tL = (P_rt5/P_rt4p5)^(1/d.e_tL); %(H.10)

        P_rt5i = P_rt4p5*r.Pi_tH;
        [T_t5i, h_t5i, ~, phi_t5i, c_pt5i, R_t5i, gamma_t5i, a_t5i] = FAIR(3, 0, NaN, NaN, P_rt5i);
        r.Eta_tL = (h_t4p5 - h_t5)/(h_t4p5 - h_t5i);
        
        h_t6 = h_t5; 
        h_t16 = h_t13; P_rt16 = P_rt13;
end

T_t16 = T_t13;
T_t6 = T_t5;
f_16 = 0; f_6 = f_4p5;

r.Tt16__dT0 = T_t16/d.T_0;
r.Tt6__dT0 = T_t6/d.T_0;

alpha_p = d.alpha/(beef + d.Eps_1 + d.Eps_2); %(H.11)

f_6A = f_6/(1+alpha_p);
P_t16dP_t6 = d.Pi_f/(d.Pi_cL*d.Pi_cH*d.Pi_b*r.Pi_tH*r.Pi_tL);

%Tau M, CP M, R M, Gamma M, MFP_6
switch (heatmodel)
    case 1 % Constant Specific Heat
        h_t16__dh_t6 = (r.Tau_r*r.Tau_f)/(r.Tau_L*r.Tau_m1*r.Tau_tH*r.Tau_m2*r.Tau_tL); %G.3
        r.Tau_M = (1 + alpha_p*h_t16__dh_t6)/(1+alpha_p); %G.4
        
        R_t = d.C_pt - d.C_pt/d.gamma_t;
        R_6 = R_t;
        R_16 = R_0;
        C_p6 = d.C_pt;
        C_p16 = C_p0;
        gamma_6 = C_p6/(C_p6-R_6);
        gamma_16 = gamma_0;
        
        r.CP_M = Mix(C_p6, C_p16, alpha_p);
        R_M = Mix(R_6, R_16, alpha_p);
        r.Gamma_M = r.CP_M/(r.CP_M-R_M);
        
        [TtdT_6, PtdP_6, MFP_6] = cpgMFP(d.M6, r.Gamma_M, R_M);
    case 3 % Variable Specific Heat
        h_t6A = (h_t6 + alpha_p*h_t16)/(1+alpha_p);
        r.Tau_M = h_t6A/h_t6; %(H.12)
        
        [~, TtdT_6, PtdP_6, MFP_6] = RGCOMPR(1, T_t6, d.M6, f_4p5);
end

T_6 = T_t6/TtdT_6;
PtdP_16 = PtdP_6*P_t16dP_t6;

%M_16, MFP_16
switch (heatmodel)
    case 1 % Constant Specific Heat
        TtdT_16 = PtdP_16^((gamma_16-1)/gamma_16);
        r.M16 = sqrt(2*(TtdT_16 - 1)/(gamma_16-1));
        
        [TtdT_16, PtdP_16, MFP_16] = cpgMFP(r.M16, gamma_16, R_16);      
    case 3 % Variable Specific Heat
        P_r16 = P_rt16/PtdP_16;
        [T_16, h_16, ~, phi_16, c_p16, R_16, gamma_16, a_16] = FAIR(3, 0, NaN, NaN, P_r16);
        V_16 = sqrt(2*gc*(h_t16 - h_16)*BTU_to_ft_lb);
        r.M16 = V_16/a_16;
        
        [~, TtdT_16, PtdP_16, MFP_16] = RGCOMPR(1, T_t16, r.M16, f_16);
end

r.A16__dA6 = alpha_p * sqrt(T_t16/T_t6) / P_t16dP_t6 * (MFP_6/MFP_16);
A_6dA_6A = 1/(1+r.A16__dA6);

% T_t6A
switch (heatmodel)
    case 1 % Constant Specific Heat
        T_t6A = T_t6*r.Tau_M;
    case 3 % Variable Specific Heat
        [~, h_6, Pr6, phi_6, c_p6, R_6, gamma_6, a_6] = FAIR(1, f_6, T_6);
        [T_t6A, ~, P_rt6A, phi_t6A, c_tp6A, R_t6A, gamma_t6A, a_t6A] = FAIR(2, f_6, NaN, h_t6A);
end

%MFP_6A
Constant = sqrt(R_6*T_6/gamma_6) * ((1+gamma_6*d.M6^2) + r.A16__dA6*(1+gamma_16*r.M16^2))/(d.M6*(1+alpha_p));
M6Ai = d.M6;%initial
switch (heatmodel)
    case 1 % Constant Specific Heat
        gamma_6A = r.Gamma_M;
        R_6A = R_M;        
        while true 
            [TtdT_6A, PtdP_6A, MFP_6A] = cpgMFP(M6Ai, gamma_6A, R_6A); %Label B
            T_6A = T_t6A*TtdT_6A;
            r.M6A = sqrt(R_6A*T_6A/gamma_6A)*(1+gamma_6A*M6Ai^2)/Constant; %(H.14)
            if abs(r.M6A-M6Ai)>0.0001
               M6Ai = r.M6A;
               continue; %Goto B
            end
            break;
        end
    case 3 % Variable Specific Heat
        while true
               [~, TtdT_6A, PtdP_6A, MFP_6A] = RGCOMPR(1, T_t6A, M6Ai, f_6A); %Label B
               T_6A = T_t6A*TtdT_6A;
               [~, h_6A, P_r6A, phi_6A, c_p6A, R_6A, gamma_6A, a_6A] = FAIR(1, f_6, T_6A);
               r.M6A = sqrt(R_6A*T_6A/gamma_6A)*(1+gamma_6A*M6Ai^2)/Constant; %(H.14)
               if abs(r.M6A-M6Ai)>0.0001
                   M6Ai = r.M6A;
                   continue; %Goto B
               end
               break;
        end
end

Pi_Mideal = (1 + alpha_p)*sqrt(r.Tau_M)*A_6dA_6A*MFP_6/MFP_6A;
r.Pi_M = d.Pi_Mmax*Pi_Mideal; %(H.15)

Tt7 = T_t6A+(d.Tt7_max-T_t6A)*d.AB;

% F_AB, f_7
switch (heatmodel)
    case 1 % Constant Specific Heat
       C_p7 = r.CP_M+(d.C_pAB-r.CP_M)*d.AB;
       Tau_LAB = (C_p7*Tt7)/(C_p0*d.T_0);
       r.f_AB = (1+r.f*bee/(1+d.alpha-d.Beta))*...
           (Tau_LAB - r.Tau_L*r.Tau_m1*r.Tau_tH*r.Tau_m2*r.Tau_tL*r.Tau_M)/...
           (d.h_Pr*d.Eta_AB/r.h_0 - Tau_LAB); %(H.16)
       f_7 = f_6A + r.f_AB;
    case 3 % Variable Specific Heat
        f7i = 0.0001;%initial
        while true
               [~, h_t7, P_rt7, phi_t7, c_pt7, R_t7, gamma_t7, a_t7] = FAIR(1, f7i, Tt7); %Label C
               Tau_LAB = h_t7/r.h_0;
               r.f_AB = (1+r.f*bee/(1+d.alpha-d.Beta))*...
                   (Tau_LAB - r.Tau_L*r.Tau_m1*r.Tau_tH*r.Tau_m2*r.Tau_tL*r.Tau_M)/...
                   (d.h_Pr*d.Eta_AB/r.h_0 - Tau_LAB); %(H.16)
               f_7 = f_6A + r.f_AB;
               if abs(f_7-f7i)>0.0001
                   f7i = f_7;
                   continue; % GOTO C
               end
               break;
        end
        h_t9 = h_t7; P_rt9 = P_rt7;
end

f_o = f_7;
T_t9 = Tt7; 

r.Pt9__dP9 = d.P0dP9*r.Pi_r*r.Pi_d*d.Pi_cL*d.Pi_cH*d.Pi_b*r.Pi_tH*r.Pi_tL*r.Pi_M*d.Pi_AB*d.Pi_n;

%Performance
switch (heatmodel)
    case 1 % Constant Specific Heat
        R_AB = d.C_pAB - d.C_pAB/d.gamma_AB;
        R_9 = R_AB;
        gamma_9 = d.gamma_AB;

        
        r.T9__dT0 = (T_t9/d.T_0)/(r.Pt9__dP9^((d.gamma_AB-1)/d.gamma_AB)); %4.17-CPG
        T9 = d.T_0*r.T9__dT0;
        TtdT_9 = T_t9/T9;
        
        M9 = sqrt(2*(TtdT_9 - 1)/(gamma_9-1));
        r.M9__dM0 = M9/d.M0;
        a9 = sqrt(d.gamma_AB*R_AB*T9*BTU_lbm_to_ft2_s2);
        V9 = M9*a9;
        r.V9__dV0 = V9/r.V0;
        r.F__dmdot = (r.a0/gc)*((1+f_o-(d.Beta/(1+d.alpha)))*(V9/r.a0) - d.M0 +...
            (1+f_o-(d.Beta/(1+d.alpha)))*(R_9/R_0)*(r.T9__dT0/(V9/r.a0))*((1-d.P0dP9)/gamma_0)); % 4.14
        
        kf = (1+f_o-(d.Beta/(1+d.alpha)))*r.V9__dV0^2-1;
        PTOdm = (r.PTOL__dmdot + r.PTOH__dmdot)/BTU_p_sec_to_KW/BTU_to_ft_lb;
        r.Eta_TH = (r.V0^2/(2*gc))*(kf+PTOdm)/(f_o*d.h_Pr*BTU_to_ft_lb); % 4.32b Modified
        r.Eta_P = 2*(r.F__dmdot*gc/r.V0)/kf;%(4.32a)
        r.S = f_o/r.F__dmdot*3600;
    case 3 % Variable Specific Heat
        P_r9 = P_rt9*r.Pt9__dP9;
        [T_9, h_9, ~, phi_9, c_p9, R_9, gamma_9, a_9] = FAIR(3, f_o, NaN, NaN, P_r9);
        V9 = sqrt(2*gc*(h_t9 - h_9)*BTU_to_ft_lb);
        r.V9__dV0 = V9/r.V0;

        M9 = V9/a_9;
        r.M9__dM0 = M9/d.M0;
end

reference_performance = r;
end

function [TtdT, PtdP, MFP] = cpgMFP(M, gamma, R)
import PropPrelib.gc
TtdT = 1+(gamma-1)/2*M^2;
PtdP = TtdT^(gamma/(gamma-1));
MFP = M*sqrt(gamma*gc/R)*sqrt(TtdT/PtdP);
end

function x = Mix(a, b, r)
    x = (a+b*r)/(1+r);
end


    
