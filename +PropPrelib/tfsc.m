function tfsc = tfsc(varargin)
import PropPrelib.Engine
global ENGINE_MODEL;
model = ENGINE_MODEL;
tfsc = model.tfsc(varargin{:});
end

