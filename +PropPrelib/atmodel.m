function model = atmodel(new_model)
%ATGMODEL Set or get current Atmosphere Model
import PropPrelib.*
global atmos_model;
if nargin == 1
    atmos_model = AtmosModel(new_model);
    clearAllMemoizedCaches;
elseif isempty(atmos_model)
    atmos_model = AtmosModel.Standard;
    clearAllMemoizedCaches;
end
model = atmos_model;
end