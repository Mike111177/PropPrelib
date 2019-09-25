function model = dragmodel(new_model)
%DRAGMODEL Set or get current DragModel
import PropPrelib.DragModel
global DRAG_MODEL;
if nargin == 1
    DRAG_MODEL = DragModel(new_model);
elseif ~exist('DRAG_MODEL', 'var')
    DRAG_MODEL = DragModel.CurrentFighter;
end
model = DRAG_MODEL;
end

