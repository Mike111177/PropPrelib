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
CLm = 1.8;
kTO = 1.15;
Beta_TO = 0.97;
AB = 0;

hold on
H = linspace(0,70E3);
[~, V, ~] = atmos(H);
plot(V, H/1E3)
[V, H] = MinTimeClimbSch(h, TR, TL, WL, CLm, Beta_TO, h_TO, kTO, AB,50);
plot(V, H/1E3)
[V, H] = MinTimeClimbSch(h, TR, TL, WL, CLm, Beta_TO, h_TO, kTO, AB,6);
plot(V, H/1E3)
[V, H] = MinTimeClimbSch(h, TR, TL, WL, CLm, Beta_TO, h_TO, kTO, AB,50, 0.9);
plot(V, H/1E3)
[V, H] = MinTimeClimbSch(h, TR, TL, WL, CLm, Beta_TO, h_TO, kTO, AB,6, 0.9);
plot(V, H/1E3)
axis([500, 1500, 0, 70])
grid on
ylabel('Alt (kft)')
xlabel('Velocity (ft/s)')
legend('M = 1', 'Min(50)', 'Min(6)', 'Mach<0.9(50)', 'Mach<0.9(6)','Location', 'SouthWest')