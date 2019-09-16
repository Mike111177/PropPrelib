function path = prop_resource(res)
%PROP_RESOURCE Summary of this function goes here
%   Detailed explanation goes here
[filepath,name,ext] = fileparts(mfilename('fullpath'));
path=[filepath, '\', res];
end

