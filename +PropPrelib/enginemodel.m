function model = enginemodel(new_type, varargin)
%ENGINEMODEL Set or get current Engine Model
import PropPrelib.Engine
global ENGINE_MODEL;
if nargin > 0
    ENGINE_MODEL = Engine.CreateEngine(new_type, varargin);
end
model = ENGINE_MODEL;
end