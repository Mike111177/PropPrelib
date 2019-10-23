function reference_performance = MFTEPCA(reference_design)
BTU_to_ft_lb = 780;
import PropPrelib.Mattingly.*
import PropPrelib.gc
d = reference_design;

[~, h_0, P_r0, phi_0,C_p0, R_0, gamma_0, r.a0] = FAIR(1, 0, d.T_0);
r.V0 = d.M0*r.a0;

h_t0 = h_0 + (r.V0^2)/(2*gc)/BTU_to_ft_lb;

[T_t0, ~, P_rt0, phi_t0, c_pt0, R_t0, gamma_t0, a_t0] = FAIR(2, 0, NaN, h_t0);

r.Tau_r = h_t0/h_0;

r.Pi_r = P_rt0/P_r0;

if d.M0 <= 1
    eta_Rspec = 1;
elseif d.M0 <= 5
    eta_Rspec = 1-0.075*(d.M0 - 1)^1.35;
else
    eta_Rspec = 800/(d.M0^4 + 935);
end

r.Pi_d = d.Pi_dmax * eta_Rspec;

h_t2 = h_t0;

P_rt2 = P_rt0;

P_rt13 = P_rt2*d.Pi_f^(1/d.e_f);

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

f4i = 0.0001;%initial
while true
       [~, h_t4, P_rt4, phi_t4, c_pt4, R_t4, gamma_t4, a_t4] = FAIR(1, f4i, d.Tt4); %Label A
       r.f = (h_t4 - h_t3)/(d.Eta_b*d.h_Pr - h_t4); %(H.4)
       if abs(r.f-f4i)>0.0001
           f4i = r.f;
           continue;
       end
       break;
end
% h_t4 = NaN; P_rt4 = NaN; phi_t4 = NaN; c_pt4 = NaN; R_t4 = NaN; gamma_t4 = NaN; a_t4 = NaN;
% f4guess = 0.0001;
% fminsearch(@vals, f4guess);
% function err = vals(f)
%     import PropPrelib.Mattingly.FAIR;
%     [~, h_t4, P_rt4, phi_t4, c_pt4, R_t4, gamma_t4, a_t4] = FAIR(1, f, d.Tt4);
%     r.f = (h_t4 - h_t3)/(d.Eta_b*d.h_Pr - h_t4); %(H.4)
%     err = abs(r.f-f);
% end

r.Tau_L = h_t4/h_0;

bee = (1 - d.Beta - d.Eps_1 - d.Eps_2);
beef = bee*(1+r.f);

r.Tau_m1 = (beef + d.Eps_1*r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L)/(beef + d.Eps_1);  %(H.5)

r.Tau_tH = 1 - (r.Tau_r*r.Tau_cL*(r.Tau_cH-1) + (1+d.alpha)*d.CTOH/d.Eta_mPH)/...           %(H.6)
                (d.Eta_mH*r.Tau_L*(beef + d.Eps_1*r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L));
          
h_t4p1 = h_t4*r.Tau_m1;

f_4p1 = r.f/(1+r.f+d.Eps_1/bee);

[T_t4p1, ~, P_rt4p1, phi_t4p1, c_pt4p1, R_t4p1, gamma_t4p1, a_t4p1] = FAIR(2, f_4p1, NaN, h_t4p1);

h_t4p4 = h_t4p1*r.Tau_tH;

[T_t4p4, ~, P_rt4p4, phi_t4p4, c_pt4p4, R_t4p4, gamma_t4p4, a_t4p4] = FAIR(2, f_4p1, NaN, h_t4p4);

r.Pi_tH = (P_rt4p4/P_rt4p1)^(1/d.e_tH); %(H.7)

P_rt4p4i = r.Pi_tH*P_rt4p1;

[T_t4p4i, h_t4p4i, ~, phi_t4p4i, c_pt4p4i, R_t4p4i, gamma_t4p4i, a_t4p4i] = FAIR(3, f_4p1, NaN, NaN, P_rt4p4i);

r.Eta_tH = (h_t4p1 - h_t4p4)/(h_t4p1 - h_t4p4i);

r.Tau_m2 = (beef + d.Eps_1 + d.Eps_2*(r.Tau_r*r.Tau_cL*r.Tau_cH/(r.Tau_L*r.Tau_m1*r.Tau_tH)))/...
               (beef + d.Eps_1 + d.Eps_2); %(H.8)

h_t4p5 = h_t4p4*r.Tau_m2;

f_4p5 = r.f/(1+r.f+(d.Eps_1+d.Eps_2)/bee);
           
[T_t4p5, ~, P_rt4p5, phi_t4p5, c_pt4p5, R_t4p5, gamma_t4p5, a_t4p5] = FAIR(2, f_4p5, NaN, h_t4p5);

r.Tau_tL = 1 - (r.Tau_r*((r.Tau_cL-1) + d.alpha*(r.Tau_f-1)) + (1 + d.alpha)*d.CTOL/d.Eta_mPL)/...           
                (d.Eta_mL*r.Tau_L*r.Tau_tH*(beef + (d.Eps_1+d.Eps_2/r.Tau_tH)*(r.Tau_r*r.Tau_cL*r.Tau_cH/r.Tau_L)));%(H.9)
            
h_t5 = h_t4p5 * r.Tau_tL;

[T_t5, ~, P_rt5, phi_t5, c_pt5, R_t5, gamma_t5, a_t5] = FAIR(2, f_4p5, NaN, h_t5);

r.Pi_tL = (P_rt5/P_rt4p5)^(1/d.e_tL); %(H.10)

P_rt5i = P_rt4p5*r.Pi_tH;

[T_t5i, h_t5i, ~, phi_t5i, c_pt5i, R_t5i, gamma_t5i, a_t5i] = FAIR(3, 0, NaN, NaN, P_rt5i);

r.Eta_tL = (h_t4p5 - h_t5)/(h_t4p5 - h_t5i);

h_t6 = h_t5; T_t6 = T_t5; f_6 = f_4p5;
h_t16 = h_t13; T_t16 = T_t13; P_rt16 = P_rt13; f_16 = 0;

r.Tt16__dT0 = T_t16/d.T_0;
r.Tt6__dT0 = T_t6/d.T_0;

alpha_p = d.alpha/(beef + d.Eps_1 + d.Eps_2); %(H.11)

f_6A = f_6/(1+alpha_p);

h_t6A = (h_t6 + alpha_p*h_t16)/(1+alpha_p);

r.Tau_M = h_t6A/h_t6; %(H.12)

P_t16dP_t6 = d.Pi_f/(d.Pi_cL*d.Pi_cH*d.Pi_b*r.Pi_tH*r.Pi_tL);

[~, TtdT_6, PtdP_6, MFP_6] = RGCOMPR(1, T_t6, d.M6, f_4p5);

T_6 = T_t6/TtdT_6;

PtdP_16 = PtdP_6*P_t16dP_t6;

P_r16 = P_rt16/PtdP_16;

[T_16, h_16, ~, phi_16, c_p16, R_16, gamma_16, a_16] = FAIR(3, 0, NaN, NaN, P_r16);

V_16 = sqrt(2*gc*(h_t16 - h_16)*BTU_to_ft_lb);
r.M16 = V_16/a_16;

[~, TtdT_16, PtdP_16, MFP_16] = RGCOMPR(1, T_t16, r.M16, f_16);

r.A16__dA6 = alpha_p * sqrt(T_t16/T_t6) / P_t16dP_t6 * (MFP_6/MFP_16);

A_6dA_6A = 1/(1+r.A16__dA6);

%wtf jack
%Missing from text
[~, h_6, Pr6, phi_6, c_p6, R_6, gamma_6, a_6] = FAIR(1, f_6, T_6);
[T_t6A, ~, P_rt6A, phi_t6A, c_tp6A, R_t6A, gamma_t6A, a_t6A] = FAIR(2, f_6, NaN, h_t6A);

Constant = sqrt(R_6*T_6/gamma_6) * ((1+gamma_6*d.M6^2) + r.A16__dA6*(1+gamma_16*r.M16^2))/(d.M6*(1+alpha_p));

M6Ai = d.M6;%initial
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

Pi_Mideal = (1 + alpha_p)*sqrt(r.Tau_M)*A_6dA_6A*MFP_6/MFP_6A;

r.Pi_M = d.Pi_Mmax*Pi_Mideal; %(H.15)

f7i = 0.0001;%initial
while true
       [~, h_t7, P_rt7, phi_t7, c_pt7, R_t7, gamma_t7, a_t7] = FAIR(1, f7i, d.Tt7); %Label C
       Tau_LAB = h_t7/h_0;
       r.f_AB = (1+r.f*bee/(1+d.alpha-d.Beta))*...
           (Tau_LAB - r.Tau_L*r.Tau_m1*r.Tau_tH*r.Tau_m2*r.Tau_tL*r.Tau_M)/...
           (d.h_Pr*d.Eta_AB/h_0 - Tau_LAB); %(H.16)
       f_7 = f_6A + r.f_AB;
       if abs(f_7-f7i)>0.0001
           f7i = f_7;
           continue; % GOTO C
       end
       break;
end

f_o = f_7;
T_t9 = d.Tt7; h_t9 = h_t7; P_rt9 = P_rt7;

r.Pt9__dP9 = d.P0dP9*r.Pi_r*r.Pi_d*d.Pi_cL*d.Pi_cH*d.Pi_b*r.Pi_tH*r.Pi_tL*r.Pi_M*d.Pi_AB*d.Pi_n

P_r9 = P_rt9*r.Pt9__dP9;

[T_9, h_9, ~, phi_9, c_p9, R_9, gamma_9, a_9] = FAIR(3, f_o, NaN, NaN, P_r9);
T_9
h_t9
h_9

V9 = sqrt(2*gc*(h_t9 - h_9)*BTU_to_ft_lb);
r.V9__dV0 = V9/r.V0;

M9 = V9/a_9;
r.M9__dM0 = M9/d.M0;

reference_performance = r;
end

