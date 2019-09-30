function gc = gc()
%Gc Returns the correct value for gc depending on the currently selected unit system
import PropPrelib.units;
system = units;
gc = system.gc;
end

