clear
clc

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*
import PropPrelib.Mattingly.*

units BE;


ref.T_0 = 390.51;
ref.M0 = 1.6;

%Diffisur
ref.Pi_dmax = 0.94;

%Fan
ref.alpha = 0.4;
ref.Pi_f = 4;
ref.e_f = 0.9;

%LCompressor
ref.Pi_cL = 4;
ref.e_cL = 0.9;

%HCompressor
ref.Pi_cH = 22/ref.Pi_cL;
ref.e_cH = 0.88;

%Burner
ref.h_Pr = 18000;
ref.Eta_b = 0.960;
ref.Pi_b = 0.960;
ref.Tt4 = 3000;

%HTurbine
ref.e_tH = 0.91;

%LTurbine
ref.e_tL = 0.91;

%Mixer
ref.M6 = 0.4;
ref.Pi_Mmax = 0.95;

%Afterburner
ref.Pi_AB = 0.950;
ref.Eta_AB = 0.970;
ref.Tt7 = 3500;

%Nozzle
ref.Pi_n = 0.960;
ref.P0dP9 = 1;

%AUX Air
ref.Beta = 0.01;
ref.Eps_1 = 0.05;
ref.Eps_2 = 0.05;

%OTHER
ref.Eta_mPL = 0.98;
ref.Eta_mPH = 0.98;
ref.Eta_mL = 0.99;
ref.Eta_mH = 0.99;
ref.CTOH = 0;
ref.CTOL = 0;
res = MFTEPCA(ref);
fprintf('Input\n')
ppstruct(ref);
fprintf('Results\n')
ppstruct(res);