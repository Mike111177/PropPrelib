%% Setup
clc
clear
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*;

units BE;
atmodel Standard;
dragmodel FutureFighter;
enginemodel LBTF;

%mcfg is a struct with variables that will be the same throughout the mission.
mcfg.TR = 1.07; %Throttle Ratio
mcfg.TLto = 1.24; %Wing Loading (Takeoff)
mcfg.WLto = 70; %Thrust Loading (Takeoff)
beta(1) = 0.9;

%% Maneuver 1

[PI(1), stats{1}] = Maneuver.E('beta', beta(end),...
                               'M'   , 0.9,... 
                               'alt' , 42000,...
                               'D'   , 200*5280,...
                                mcfg); %Rest of mission parameters
beta(end+1) = PI(end)*beta(end);
fprintf('\nManeuver %d: (%s)\n', length(PI), Maneuver.E.name);
ppstruct(stats{end}, 4);                            
            
%% Maneuver 2

[PI(end+1), stats{end+1}] = Maneuver.E('beta', beta(end),...
                                       'M'   , 1.6    ,... 
                                       'alt' , 30000   ,...
                                       'D'   , 100*5280,...
                                       mcfg); %Rest of mission parameters
beta(end+1) = PI(end)*beta(end);
fprintf('\nManeuver %d: (%s)\n', length(PI), Maneuver.E.name);
ppstruct(stats{end}, 4);
if any([stats{2}.AB_req]>0)
    warning('It is impossible subsonic cruise for maneuver 2: (AB_req=%.0f%%)\n', max([stats{2}.AB_req])*100);
else
    fprintf('It is possible for subsonic cruise for maneuver 2: (AB_req=0)\n');
end

%% Maneuver 3
[PI(end+1), stats{end+1}] = Maneuver.F('beta', beta(end),...
                                       'M'   , 0.9    ,... 
                                       'alt' , 30000   ,...
                                       'n'  , 4.5,...
                                       'Turns', 1,...
                                       mcfg); %Rest of mission parameters     
beta(end+1) = PI(end)*beta(end);
fprintf('\nManeuver %d: (%s)\n', length(PI), Maneuver.F.name);
ppstruct(stats{end}, 4);
fprintf('The minimum required afterburner for maneuver 3 is %.0f%%\n', max([stats{3}.AB_req])*100);

%% Maneuver 4

%Parameters for single maneuvers can also be stacked in structs
m4cfg.beta = beta(end);
m4cfg.M1 = 0.9;
m4cfg.M2 = 1.6;
m4cfg.alt = 30000;
m4cfg.AB = 1; 

%Trying maneuver 4 with 1 interval
PI1int = Maneuver.B('Intervals', 1,...
                    m4cfg,... %Rest of Manuever 4 parameters
                    mcfg); %Rest of mission parameters

%Trying maneuver 4 with 1 interval
[PI(end+1), stats{end+1}] = Maneuver.B('Intervals', 3,...
                                       m4cfg,... %Rest of Manuever 4 parameters
                                       mcfg); %Rest of mission parameters                                   
beta(end+1) = PI(end)*beta(end);
fprintf('\nManeuver %d: (%s)\n', length(PI), Maneuver.B.name);
ppstruct(stats{end}, 4);
fprintf('Maneuver 4 (1 Interval(s)): PI = %.5f\nManeuver 4 (3 Interval(s)): PI = %.5f\n', PI1int, PI(end));

hold on
bar(PI)
plot(beta,'LineWidth',3)
xlabel('Maneuver')
xticks(1:length(PI))
legend('PI', 'Beta')

%% Important External Functions
%
% <include>+PropPrelib/@Maneuver/private/ConstantAltitudeSpeedCruise.m</include>
%
% <include>+PropPrelib/@Maneuver/private/ConstantAltitudeSpeedTurn.m</include>
%
% <include>+PropPrelib/@Maneuver/private/HorizontalAcceleration.m</include>