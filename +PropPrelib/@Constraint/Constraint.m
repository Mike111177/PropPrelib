% A constraint is a function that given wing loading and other required
% variables will yeild thrust loading.
classdef Constraint
    properties
        name,
        f
    end
    methods
        function c = Constraint(name, f)
            c.name = name;
            c.f = f;
        end
        function res = subsref(c, args)
            switch(args.type)
                case '()'
                    if isa(c.f,'function_handle')
                        TL = c.f(args.subs{:});
                        res = TL;
                    else
                        error(['This constraint is not implemented yet!: ' c.name]);
                    end
                case '.'
                    res = c.(args.subs);
            end
        end
    end
    enumeration
        A('A - Constant Altitude/Speed Cruise', @ConstantAltitudeSpeedCruise),
        B('B - Constant Speed Climb', @ConstantSpeedClimb),
        C('C - Constant Altitude/Speed Turn', @ConstantAltitudeSpeedTurn),
        D('D - Horizontal Acceleration', @HorizontalAcceleration),
        E('E - Service Ceiling', @ServiceCeiling),
        F('F - Takeoff (No obstacle)', NaN),
        G('G - Takeoff', NaN),
        H('H - Landing (No obstacle)', NaN),
        I('I - Landing', NaN),
        J('J - Acceleration Time', @HorizontalAcceleration),
        K('K - Takeoff Climb Angle', NaN),
        L('L - Carrier Takeoff', NaN),
        M('M - Carrier Landing', NaN),
        N('N - Carrier Approach', NaN),
    end
end

