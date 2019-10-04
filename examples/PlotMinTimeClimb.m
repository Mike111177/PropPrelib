clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*

units BE;
enginemodel LBTF;
dragmodel FutureFighter;
atmodel Standard;

h = 60000;
WL = 64;
TL = 1.25;
TR = 1.07;
h_TO = 0;
Beta_TO = 0.97;
AB = 0;
n = 1;

hold on
axis([500, 1500, 0, 70])
grid on
title(sprintf('%d iterations.', 50))
ylabel('Alt (kft)')
xlabel('Velocity (ft/s)')
H = linspace(0,70E3);
[~, V, ~] = atmos(H);
plot(V, H/1E3,'LineWidth',2)
[V, H] = MinTimeClimbSch(h, TR, TL, WL, Beta_TO, h_TO, n, AB, 50);
h_kft = H(1:2:end)'./1E3;
min_t_V = V(1:2:end)';
plot(V, H/1E3,'LineWidth',4)
V = MinTimeClimbSch(h, TR, TL, WL, Beta_TO, h_TO, n, AB, 50, 0.9);
less_M_09_V = V(1:2:end)';
plot(V, H/1E3,'LineWidth',4)
legend('\color{white}M = 1', '\color{white}Max Ps', '\color{white}Mach<0.9','Location', 'SouthWest', 'color','none','color','none','Box', 'off')
set(gca,'Color','k')
set(gca,'GridColor','w')

table(h_kft,min_t_V,less_M_09_V)

