classdef DragModel
    %TODO Rename to airframe model or something more fitting
    properties
        dragdata,
        %Weight Fraction Constants,
        A, B
        
    end
    methods
        function c = DragModel(dragdatafile, A, B)
            data = readtable(PropPrelib.prop_resource(['@DragModel/' dragdatafile]));         
            data.K1 = fillmissing(data.K1, 'linear', 'SamplePoints', data.M);
            data.K2 = fillmissing(data.K2, 'linear', 'SamplePoints', data.M);
            data.CD0 = fillmissing(data.CD0, 'linear', 'SamplePoints', data.M);
            c.A = A;
            c.B = B;
            c.dragdata = data;
        end
    end
    enumeration
        CurrentFighter('current_fighter.csv', 2.34, 0.13),
        FutureFighter('future_fighter.csv', 2.34, 0.13),
        %TODO: implement Cargo/Passenger
        %Cargo('cargo.csv', 1.26, 0.08),
        %Passenger('passenger.csv', 1.02, 0.06),
        %TwinTurboProp('TwinTurboProp.csv', 0.96, 0.05),
    end 
end

