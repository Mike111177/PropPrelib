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
TL = 1.3;
TR = 1.1;
h_TO = 0;
Beta_TO = 0.9;
AB = 1;
n = 1;

hold on
H = linspace(0,70E3,150);
ylabel('Alt (kft)');
xlabel('Velocity (ft/s)');
V = Contours.MachLines(H);
plot(V, H/1E3,'LineWidth',2);

% Interpolation Method (150x200)
V = linspace(100, 2000,200);
VT = Contours.ConstantPs(H,V, TR, TL, WL, Beta_TO, n, AB);

% Constant Ps Contours
SCHED = Contours.MinTimeClimb(H,V,VT);
VT(VT<0) = 0;
contour(V, H/1E3, VT, 25,'-k');
plot(SCHED, H/1E3,'LineWidth',3);

%Optimization Method (SLOW) (x10)
Iterations = 10;
[V, H] = Contours.MinTimeClimbSch(h, TR, TL, WL, Beta_TO, h_TO, n, AB, Iterations);
h_kft = H'./1E3;
min_t_V = V';
plot(V, H/1E3,'LineWidth',2)
V = Contours.MinTimeClimbSch(h, TR, TL, WL, Beta_TO, h_TO, n, AB, Iterations, 0.9);
less_M_09_V = V';
plot(V, H/1E3,'LineWidth',2)

legend('Mach 1', 'Constant Ps Lines', 'Min Time Climb (Interpolated)', 'Min Time Climb (Optimized)','Min Time Climb (<0.9) (Optimized)','Location','NorthWest')

%% Table

disp(table(h_kft,min_t_V,less_M_09_V))


