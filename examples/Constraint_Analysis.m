clc
clear
close all

addpath("..")% Not needed if +PropPrelib folder is in your current path.

import PropPrelib.*;

units BE;
enginetype LBTF;
dragmodel FutureFighter;

WL = linspace(20,120);

%HorizontalAcceleration
TLd = Constraint.D('WL'        , WL   ,...
                  'beta'      , 0.78 ,...
                  'TR'        , 1.06 ,...
                  'alt'       , 30E3 ,...
                  'dt'        , 45   ,...
                  'M1'        , 0.8  ,...
                  'M2'        , 1.6  ,...
                  'Throttle'  , 'max');

hold on
plot(WL, TLd);
ylabel('TL');
xlabel('WL');
legend(Constraint.D.name);
              
 