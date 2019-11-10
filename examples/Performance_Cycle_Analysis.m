Parametric_Cycle_Analysis %Run Our Parametric_Cycle_Analysis for our design and reference condition

import PropPrelib.*
import PropPrelib.Mattingly.*

%Temporary Assumptions (will fix with further info)
ref.M8 = ref.M9__dM0*design.M0;
ref.hmodel = 3;

[control.T_0, ~, control.P0] = atmos(20000);
control.M0 = 0.5;
control.Tt4 = 3000;

MFTEPCAPerf(design, control, ref)