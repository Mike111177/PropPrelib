function lapse = thrustLapse(varargin)
import PropPrelib.Engine
global ENGINE_MODEL;
model = ENGINE_MODEL;
lapse = model.thrustLapse(varargin{:});
end

