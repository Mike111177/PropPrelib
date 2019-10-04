function lapse = thrustLapse(varargin)
import PropPrelib.*
model = enginemodel;
lapse = model.thrustLapse(varargin{:});
end

