function model = atmodel(new_model)
%ATGMODEL Set or get current Atmosphere Model
import PropPrelib.AtmosModel_e
persistent atmos_model;
if nargin == 1
    atmos_model = AtmosModel_e(new_model);
elseif isempty(atmos_model)
    atmos_model = AtmosModel_e.Standard;
end
if atmos_model == AtmosModel_e.Cold
    warning([sprintf('The Temperature scale for the cold atmospheric model is currently inaccurate!\n')... 
            '         Do not use for submitted assignments until further notice!']);
    %TODO Improve atmosphere calculations to more closley follow Fig B.1
    %from textbook
end
model = atmos_model;
end