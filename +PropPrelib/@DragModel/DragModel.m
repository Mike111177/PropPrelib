classdef DragModel
    properties
        data
    end
    methods
        function c = DragModel(datafile)
            data = readtable(PropPrelib.prop_resource(['@DragModel/' datafile]));         
            data.K1 = fillmissing(data.K1, 'linear', 'SamplePoints', data.M);
            data.K2 = fillmissing(data.K2, 'linear', 'SamplePoints', data.M);
            data.CD0 = fillmissing(data.CD0, 'linear', 'SamplePoints', data.M);
            c.data = data;
        end
    end
    enumeration
        CurrentFighter('current_fighter.csv'),
        FutureFighter('future_fighter.csv')
    end 
end

