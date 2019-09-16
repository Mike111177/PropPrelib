classdef DragModel_e
    properties
        data
    end
    methods
        function c = DragModel_e(data)
            data.K1 = fillmissing(data.K1, 'linear', 'SamplePoints', data.M);
            data.CD0 = fillmissing(data.CD0, 'linear', 'SamplePoints', data.M);
            c.data = data;
        end
    end
    enumeration
        CurrentFighter(readtable(PropPrelib.prop_resource('drag_model_data/current_fighter.csv'))),
        FutureFighter(readtable(PropPrelib.prop_resource('drag_model_data/future_fighter.csv')))
    end 
end

