function r = perf_metrics(d, r)
import PropPrelib.gc
BTU_lbm_to_ft2_s2 = 25037.00;
BTU_to_ft_lb = 780;
%Performance Metrics
r.Pt9__dP9 = d.P0dP9*r.Pi_r*r.Pi_d*d.Pi_cL*d.Pi_cH*d.Pi_b*r.Pi_tH*r.Pi_tL*r.Pi_M*d.Pi_AB*d.Pi_n;
R_AB = d.C_pAB - d.C_pAB/d.gamma_AB;
R_9 = R_AB;
gamma_9 = d.gamma_AB;


r.T9__dT0 = (r.Tt(9)/r.T(0))/(r.Pt9__dP9^((d.gamma_AB-1)/d.gamma_AB)); %4.17-CPG
T9 = r.T(0)*r.T9__dT0;
TtdT_9 = r.Tt(9)/T9;

M9 = sqrt(2*(TtdT_9 - 1)/(gamma_9-1));
r.M9__dM0 = M9/d.M0;
a9 = sqrt(d.gamma_AB*R_AB*T9*BTU_lbm_to_ft2_s2);
V9 = M9*a9;
r.V9__dV0 = V9/r.V(0);
r.F__dmdot = (r.a(0)/gc)*((1+r.f_o-(d.Beta/(1+d.alpha)))*(V9/r.a(0)) - d.M0 +...
    (1+r.f_o-(d.Beta/(1+d.alpha)))*(R_9/r.R(0))*(r.T9__dT0/(V9/r.a(0)))*((1-d.P0dP9)/r.gamma(0))); % 4.14

kf = (1+r.f_o-(d.Beta/(1+d.alpha)))*r.V9__dV0^2-1;
PTOdm = (r.PTOL/r.mdot(0) + r.PTOH/r.mdot(0))/BTU_to_ft_lb;
r.Eta_TH = (r.V(0)^2/(2*gc))*(kf+PTOdm)/(r.f_o*d.h_Pr*BTU_to_ft_lb); % 4.32b Modified
r.Eta_P = 2*(r.F__dmdot*gc/r.V(0))/kf;%(4.32a)
r.S = r.f_o/r.F__dmdot*3600;
end

