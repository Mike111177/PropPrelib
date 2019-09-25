function system = units(unittype)
import PropPrelib.*
global UNIT_SYSTEM;
if nargin == 1
    UNIT_SYSTEM = UnitSystem(unittype);
elseif ~exist('UNIT_SYSTEM', 'var')
    UNIT_SYSTEM = UnitSystem.BE;
end
system = UNIT_SYSTEM;
end

