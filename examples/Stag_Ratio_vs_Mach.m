clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*

M = linspace(0,4);
[Tt, Pt] = adjust_atmos(1, 1, M);
hold on
plot(M, Tt);
plot(M, Pt);
legend("Tt/T", "Pt/P");
xlabel("M");

%%
% <include>+PropPrelib/adjust_atmos.m</include>