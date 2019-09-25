function [K1,CD0,K2] = drag_constants(M)
%DRAG_CONSTANTS Summary of this function goes here
import PropPrelib.dragmodel
model = dragmodel;
d = model.data;
K1 = interp1(d.M, d.K1, M, 'linear');
K2 = interp1(d.M, d.K2, M, 'linear');
CD0 = interp1(d.M, d.CD0, M, 'linear');
end

