clear
clc

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*
import PropPrelib.Mattingly.*

units BE;
atmodel Standard;
%Ambient
design.Alt = 35000;
design.M0 = 1.6;
design.C_pc = 0.238;  %Ignored in VSH mode
design.gamma_c = 1.4; %Ignored in VSH mode

%Diffisur
design.Pi_dmax = 0.97;

%Fan
design.alpha = 0.4;
design.Pi_f = 3.8;
design.e_f = 0.89;

%LCompressor
design.Pi_cL = 3.5;
design.e_cL = 0.89;

%HCompressor
design.Pi_c = 16;
design.e_cH = 0.89;

%Burner
design.h_Pr = 18000;
design.Eta_b = 0.999;
design.Pi_b = 0.950;
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
design.Pi_AB = 0.950;
design.Eta_AB = 0.970;
design.Tt7_max = 3600;
design.C_pAB = 0.295;  %Ignored in VSH mode
design.gamma_AB = 1.3; %Ignored in VSH mode

%Nozzle
design.Pi_n = 0.970;
design.P0dP9 = 1;

%AUX Air
design.Beta = 0.01;
design.Eps_1 = 0.05;
design.Eps_2 = 0.05;

%OTHER
design.Eta_mPL = 0.995;
design.Eta_mPH = 0.995;
design.Eta_mL = 0.99;
design.Eta_mH = 0.98;
design.CTOH = 0.015;
design.CTOL = 0;

disp('Design:')
ppstruct(design);
disp('AB ON:')
ppstruct(MFTEPCA(design));
disp('AB OFF:')
ppstruct(MFTEPCAABOff(design));

%AfterBurner off
ABon = funcSens(@MFTEPCA,design,...
                {'Tt4', 'Tt7_max', 'Pi_c', 'Pi_f', 'alpha', 'M6', 'P0dP9', 'M0', 'Alt'},...
                {'F__dmdot', 'S'}, 0.05);
          
%Afterburner on
ABoff = funcSens(@MFTEPCAABOff,design,...`
                {'Tt4',        'Pi_c', 'Pi_f', 'alpha', 'M6', 'P0dP9', 'M0', 'Alt'},...
                {'F__dmdot', 'S'}, 0.1);
              
printDoubleTable({'Military Power','Max Power'}, {ABoff,  ABon});