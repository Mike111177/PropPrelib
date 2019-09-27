function [K1,CD0,K2] = drag_constants(M, drag_data)
%DRAG_CONSTANTS Summary of this function goes here
if nargin == 1
    import PropPrelib.dragmodel
    model = dragmodel;
    drag_data = model.dragdata;
end
K1 = interp1(drag_data.M, drag_data.K1, M, 'linear');
K2 = interp1(drag_data.M, drag_data.K2, M, 'linear');
CD0 = interp1(drag_data.M, drag_data.CD0, M, 'linear');
end

