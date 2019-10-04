clc
clear
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*;

units SI;
dragmodel FutureFighter;

h = linspace(0, 30E3, 200);
atmodel Standard;
[~, ~, ~, ~, theta_stand] = atmos(h);
atmodel Cold;
[~, ~, ~, ~, theta_cold] = atmos(h);
atmodel Hot;
[~, ~, ~, ~, theta_hot] = atmos(h);
atmodel Tropic;
[~, ~, ~, ~, theta_tropic] = atmos(h);
hold on
plot(theta_stand,h/1000) 
plot(theta_cold,h/1000) 
plot(theta_hot,h/1000) 
plot(theta_tropic,h/1000) 
legend('Standard', 'Cold', 'Hot', 'Tropic')
ylabel('h (km)')
xlabel('theta')
title('Fig. B.1')