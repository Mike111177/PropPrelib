clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*

M = linspace(0,2);

% The first time you run this may be slow as MATLAB loads the data models
% This loading only happens on the first run however until MATLAB is
% restarted.
dragmodel CurrentFighter; %Setting Drag mode
[cK1, cCD0] = drag_constants(M);

dragmodel FutureFighter;
[fK1, fCD0] = drag_constants(M);

subplot(2,1,1)
hold on
plot(M, cK1);
plot(M, fK1);
legend("Current Fighter", "Future Fighter", 'location', "NorthWest");
xlabel("M");
ylabel("K1");
title("Figure 2.10 - K1 for Fighter Aircraft")

subplot(2,1,2)
hold on
plot(M, cCD0);
plot(M, fCD0);
legend("Current Fighter", "Future Fighter", 'location', "NorthWest");
xlabel("M");
ylabel("CD0");
title("Figure 2.11 - CD0 for Fighter Aircraft")
