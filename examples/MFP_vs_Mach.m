clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*

M = linspace(0,4);
MW = 28.95;
Ru = 1545;
R = MW*Ru;

hold on
plot(M, MFP(M, R))
plot(M, MFp_static(M, R))
legend("MFP", "MFp");
xlabel("M");

%%
% <include>+PropPrelib/MFP.m</include>
%
% <include>+PropPrelib/MFp_static.m</include>