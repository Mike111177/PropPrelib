function model = dragmodel(new_model)
%DRAGMODEL Set or get current DragModel
import PropPrelib.DragModel_e
global DRAG_MODEL;
if nargin == 1
    DRAG_MODEL = DragModel_e(new_model);
elseif ~exist('DRAG_MODEL', 'var')
    DRAG_MODEL = DragModel_e.CurrentFighter;
end
model = DRAG_MODEL;
end

