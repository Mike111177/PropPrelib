function g0 = g0()
%G0 Returns the correct value for g0 depending on the currently selected unit system
import PropPrelib.units;
system = units;
g0 = system.g0;
end

