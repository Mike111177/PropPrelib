clear
clc

import PropPrelib.*
import PropPrelib.Mattingly.*

units BE;


ref.T_0 = 411.6;
ref.M_0 = 1.6;

%Diffisur
ref.Pi_dmax = 0.97;

%Fan
ref.alpha = 0.3;
ref.Pi_f = 3.5;
ref.e_f = 0.89;

%LCompressor
ref.Pi_cL = 3.5;
ref.e_cL = 0.89;

%HCompressor
ref.Pi_cH = 16/ref.Pi_cL;
ref.e_cH = 0.89;

%Burner
ref.h_Pr = 18000;
ref.Eta_b = 0.980;
ref.Pi_b = 0.970;
ref.Tt4 = 3200;
ref.Tt7 = 3600;

%HTurbine
ref.e_tH = 0.890;

%LTurbine
ref.e_tL = 0.910;

%Mixer
ref.M_6 = 0.4;

%AUX Air
ref.Beta = 0.01;
ref.Epsilon_1 = 0.05;
ref.Epsilon_2 = 0.05;

%OTHER
ref.Eta_mPL = 0.99;
ref.Eta_mPH = 0.98;
ref.Eta_mL = 0.98;
ref.Eta_mH = 0.98;
ref.CTOH = 0;
ref.CTOL = 0.01; 

ppstruct(MFTEPCA(ref));