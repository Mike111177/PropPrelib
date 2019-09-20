function g = g0()
%G0 Returns the correct value for g0 depending on the currently selected unit system
import PropPrelib.units;
import PropPrelib.unitsystem.*
switch(units)
    case UnitSystem_e.BE
    	g = 32.17;
    case UnitSystem_e.SI
        g = 1;
end
end

