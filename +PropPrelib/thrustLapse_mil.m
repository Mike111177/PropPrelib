function alpha = thrustLapse_mil(theta_0, delta_0, TR, M_0)
import PropPrelib.enginetypes.*
global ENGINE_TYPE
if ENGINE_TYPE == "LBTF"
    alpha = LBTF.thrustLapse_mil(theta_0, delta_0, TR, M_0);
elseif ENGINE_TYPE == "TURBOJET"
    alpha = TURBOJET.thrustLapse_mil(theta_0, delta_0, TR, M_0);
end
end
