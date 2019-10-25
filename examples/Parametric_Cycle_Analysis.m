clear
clc

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*
import PropPrelib.Mattingly.*

units BE;
atmodel Standard;

%Ambient
[design.T_0, ~, design.P0] = atmos(30000);
design.M0 = 1.6;
design.C_pc = 0.238;  %Ignored in VSH mode
design.gamma_c = 1.4; %Ignored in VSH mode

%Diffisur
design.Pi_dmax = 0.97;

%Fan
design.alpha = 0.3;
design.Pi_f = 3.5;
design.e_f = 0.89;

%LCompressor
design.Pi_cL = 3.5;
design.e_cL = 0.89;

%HCompressor
design.Pi_cH = 16/design.Pi_cL;
design.e_cH = 0.89;

%Burner
design.h_Pr = 18000;
design.Eta_b = 0.980;
design.Pi_b = 0.970;
design.Tt4 = 3200;

%HTurbine
design.e_tH = 0.890;
design.C_pt = 0.295;  %Ignored in VSH mode
design.gamma_t = 1.3; %Ignored in VSH mode

%LTurbine
design.e_tL = 0.910;

%Mixer
design.M6 = 0.4;
design.Pi_Mmax = 0.970;

%Afterburner
design.Pi_AB = 0.960;
design.Eta_AB = 0.970;
design.Tt7 = 3600;
design.C_pAB = 0.295;  %Ignored in VSH mode
design.gamma_AB = 1.3; %Ignored in VSH mode

%Nozzle
design.Pi_n = 0.980;
design.P0dP9 = 1;

%AUX Air
design.Beta = 0.01;
design.Eps_1 = 0.05;
design.Eps_2 = 0.05;

%OTHER
design.Eta_mPL = 0.98;
design.Eta_mPH = 0.98;
design.Eta_mL = 0.99;
design.Eta_mH = 0.98;
design.CTOH = 0;
design.CTOL = 0.01;
ref = MFTEPCA(design, 1);
fprintf('Input\n')
ppstruct(design);
fprintf('Results\n')
ppstruct(ref);