clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*
units BE;

%From table C.1
MaxMach = 1.8;
MaxMachAlt = 40000;
SuperCruiseMach = 1.5;
SuperCruiseAlt = 30000;

[T, a, P] = atmos(MaxMachAlt);
MaxMach_q = dynamic_pressure(P, MaxMach)

[T, a, P] = atmos(SuperCruiseAlt);
SuperCruise_q = dynamic_pressure(P, SuperCruiseMach)

%%
% <include>+PropPrelib/atmos.m</include>
%
% <include>+PropPrelib/dynamic_pressure.m</include>