clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*

%From table C.1
MaxMach = 1.8;
MaxMachAlt = 40000;
SuperCruiseMach = 1.5;
SuperCruiseAlt = 30000;

[T, a, P] = atmosisaBE(MaxMachAlt);
MaxMach_q = dynamic_pressure(P, MaxMach)

[T, a, P] = atmosisaBE(SuperCruiseAlt);
SuperCruise_q = dynamic_pressure(P, SuperCruiseMach)

%%
% <include>+PropPrelib/atmosisaBE.m</include>
%
% <include>+PropPrelib/dynamic_pressure.m</include>