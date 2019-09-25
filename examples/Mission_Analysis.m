clc
clear
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*;

units BE;
dragmodel FutureFighter;
enginemodel LBTF;

%mcfg is a struct with variables that will be the same throughout the mission.
mcfg.TR = 1.07; %Throttle Ratio
mcfg.TLto = 1.24; %Wing Loading (Takeoff)
mcfg.WLto = 70; %Thrust Loading (Takeoff)

beta(1) = 0.9;

[PI(1), stats{1}] = Maneuver.E('beta', beta(end),...
                               'M'   , 0.9,... 
                               'alt' , 42000,...
                               'D'   , 200*5280,...
                                mcfg); %Rest of mission parameters
            
beta(end+1) = PI(end)*beta(end);

[PI(end+1), stats{end+1}] = Maneuver.E('beta', beta(end),...
                                       'M'   , 1.6    ,... 
                                       'alt' , 30000   ,...
                                       'D'   , 100*5280,...
                                       mcfg); %Rest of mission parameters
beta(end+1) = PI(end)*beta(end);
if any([stats{2}.AB_req]>0)
    warning('It is impossible subsonic cruise for maneuver 2: (AB_req=%.0f%%)\n', max([stats{2}.AB_req])*100);
else
    fprintf('It is impossible for subsonic cruise for maneuver 2: (AB_req=0)\n');
end

[PI(end+1), stats{end+1}] = Maneuver.F('beta', beta(end),...
                                       'M'   , 0.9    ,... 
                                       'alt' , 30000   ,...
                                       'n'  , 4.5,...
                                       'Turns', 1,...
                                       mcfg); %Rest of mission parameters     
beta(end+1) = PI(end)*beta(end);
fprintf('The minimum required afterburner for maneuver 3 is %.0f%%\n', max([stats{3}.AB_req])*100); 

hold on
bar(PI)
plot(beta,'LineWidth',3)
xlabel('Maneuver')
xticks(1:length(PI))
legend('PI', 'Beta')
beta
PI