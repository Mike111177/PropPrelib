clear
clc
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*
units BE;
enginemodel LBTF;

M = linspace(0,2);

% Alt = 0, TR = 1
alt = 0;
TR = 1;
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,1);
hold on
title("Alt = 0, TR = 1");
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'max'));
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'mil'));
xlabel("M0");
ylabel("alpha");
legend("max", "mil", 'Location',"SouthWest");

% Alt = 0, TR = 1.08

alt = 0;
TR = 1.08;
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,2);
hold on
title("Alt = 0, TR = 1.08");
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'max'));
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'mil'));
xlabel("M0");
ylabel("alpha");
legend("max", "mil", 'Location',"SouthWest");

% Alt = 40k, TR = 1
alt = 40000;
TR = 1;
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,3);
hold on
title("Alt = 40k, TR = 1");
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'max'));
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'mil'));
xlabel("M0");
ylabel("alpha");
legend("max", "mil", 'Location',"NorthWest");

% Alt = 40k, TR = 1.08
alt = 40000;
TR = 1.08;
[theta, delta] = atmos_nondimensional(alt);
[theta_0, delta_0] = adjust_atmos(theta, delta, M);

subplot(2,2,4);
hold on
title("Alt = 40k, TR = 1.08");
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'max'));
plot(M, thrustLapse('theta_0', theta_0,...
                    'delta_0', delta_0,...
                    'TR', TR,...
                    'AB', 'mil'));
xlabel("M0");
ylabel("alpha");
legend("max", "mil", 'Location',"NorthWest");

%%
% <include>+PropPrelib/+EngineModels/@EngineSimple/private/thrust_lapse_simple.m</include>
% 
% <include>+PropPrelib/atmos_nondimensional.m</include>
%
% <include>+PropPrelib/atmosisa.m</include>
% 
% <include>+PropPrelib/adjust_atmos.m</include>