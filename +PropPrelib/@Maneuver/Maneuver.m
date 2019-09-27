% A Maneuver is a function that given a value for beta and other required
% arguments will yeild a PI weight ratio
classdef Maneuver
    properties
        name,
        func
    end
    methods
        function c = Maneuver(name, f)
            c.name = name;
            c.func = f;
        end
        function [res, varargout] = subsref(c, args)
            switch(args.type)
                case '()'
                    if isa(c.func,'function_handle')
                        [res, varargout{1}] = c.func(args.subs{:});
                    else
                        error(['This maneuver is not implemented yet!: ' c.name]);
                    end
                case '.'
                    res = c.(args.subs);
            end
        end
    end
    enumeration
        A('A - Constant Speed Climb', @ConstantSpeedClimb),
        B('B - Horizontal Acceleration', @HorizontalAcceleration),
        C('C - Climb and Acceleration', NaN),
        D('D - Takeoff Acceleration', NaN),
        E('E - Constant Altitude/Speed Cruise', @ConstantAltitudeSpeedCruise),
        F('F - Constant Altitude/Speed Turn', @ConstantAltitudeSpeedTurn),
        G('G - Best Cruise Mach and Altitude', NaN),
        H('H - Loiter', NaN),
        I('I - Warm-up', @WarmUp),
        J('J - Takeoff Rotation', NaN),
        K('K - Constant Energy Height Maneuver', NaN),
        L('L - Deliver Payload', NaN),
        M('M - Climb/Descend Angle', NaN),
        N('N - Fuel Reserves', NaN),
        O('O - Specified PI', @(PI)PI)
    end
end

