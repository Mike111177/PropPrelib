function system = units(unittype)
import PropPrelib.unitsystem.*
global UNIT_SYSTEM;
if nargin == 1
    UNIT_SYSTEM = UnitSystem_e(unittype);
elseif ~exist('UNIT_SYSTEM', 'var')
    UNIT_SYSTEM = UnitSystem_e.BE;
end
system = UNIT_SYSTEM;
end

