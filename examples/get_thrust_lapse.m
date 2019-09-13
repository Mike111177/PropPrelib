clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*
enginetype LBTF

M = linspace(0,2);

% Alt = 0, TR = 1
alt = 0;
TR = 1;
[theta, delta] = atmos_nondimensionalBE(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,1);
hold on
title("Alt = 0, TR = 1");
plot(M, thrustLapse_max(theta_0, delta_0, TR, M));
plot(M, thrustLapse_mil(theta_0, delta_0, TR, M));
xlabel("M0");
ylabel("alpha");
legend("max", "mill", 'Location',"SouthWest");

% Alt = 0, TR = 1.08

alt = 0;
TR = 1.08;
[theta, delta] = atmos_nondimensionalBE(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,2);
hold on
title("Alt = 0, TR = 1.08");
plot(M, thrustLapse_max(theta_0, delta_0, TR, M));
plot(M, thrustLapse_mil(theta_0, delta_0, TR, M));
xlabel("M0");
ylabel("alpha");
legend("max", "mill", 'Location',"SouthWest");

% Alt = 40k, TR = 1
alt = 40000;
TR = 1;
[theta, delta] = atmos_nondimensionalBE(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,3);
hold on
title("Alt = 40k, TR = 1");
plot(M, thrustLapse_max(theta_0, delta_0, TR, M));
plot(M, thrustLapse_mil(theta_0, delta_0, TR, M));
xlabel("M0");
ylabel("alpha");
legend("max", "mill", 'Location',"NorthWest");

% Alt = 40k, TR = 1.08
alt = 40000;
TR = 1.08;
[theta, delta] = atmos_nondimensionalBE(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,4);
hold on
title("Alt = 40k, TR = 1.08");
plot(M, thrustLapse_max(theta_0, delta_0, TR, M));
plot(M, thrustLapse_mil(theta_0, delta_0, TR, M));
xlabel("M0");
ylabel("alpha");
legend("max", "mill", 'Location',"NorthWest");

%%
% <include>+PropPrelib/enginetypes/LBTF/thrustLapse_max.m</include>
%
% <include>+PropPrelib/enginetypes/LBTF/thrustLapse_mil.m</include>
% 
% <include>+PropPrelib/atmos_nondimensionalBE.m</include>
%
% <include>+PropPrelib/atmosisaBE.m</include>
% 
% <include>+PropPrelib/adjust_atmos.m</include>