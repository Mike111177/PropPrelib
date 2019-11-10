Parametric_Cycle_Analysis %Run Our Parametric_Cycle_Analysis for our design and reference condition

import PropPrelib.*
import PropPrelib.Mattingly.*

%Temporary Assumptions (will fix with further info)
ref.hmodel = 3;
M9 = ref.M9__dM0*design.M0; 
if M9 > 1 % M8      ???
    ref.M8 = 1;
else
    ref.M8 = M9;
end
ref.A4__dA4p5 = .5; % A4/A4.5 ???
ref.A4p5__dA6 = .1; % A4.5/A6 ???
ref.A8__dA6 = 0.1;    % A8/A6 ???
ref.MFP4 = 20;      % MFP4R?
                    % Is M6R a good initial value for M6
                    % All Component Efficencies constant ???
                    % Is CTOL/CTOH constant?
                        % If not, how to non dimensionalize PTOL/(mdot0*h0)
                   % Is M16 Assumed Constant
                   % Is Pi_n, Pi_b, assumed Constant?
                    %Non convergence detection?
                    
[control.T_0, ~, control.P0] = atmos(20000);
control.M0 = 0.5;
control.Tt4 = 3000;
control.Tt7 = 3400;
control.Pi_c_max = 15;

fprintf('Performance\n')
ppstruct(MFTEPCAPerf(design, control, ref, true, true))

