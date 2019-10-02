function [K1,CD0,K2] = drag_constants(M, drag_data)
%DRAG_CONSTANTS Summary of this function goes here
if nargin == 1
    import PropPrelib.dragmodel
    model = dragmodel;
end
[K1, CD0, K2] = model.getConstants(M);
end

