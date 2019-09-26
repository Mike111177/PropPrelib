classdef AtmosModel
    properties
        lapsedata
    end
    properties (Constant)
        Psl = 101325;
    end
    methods
        function m = AtmosModel(file)
            lapse = readtable(PropPrelib.prop_resource(['@AtmosModel/' file '.csv']));
            lapse.h = lapse.h*1000;
            lapse.L = lapse.L./-1000;
            if strcmp(file,'Standard')
                lapse.P(1) = PropPrelib.AtmosModel.Psl;
            end
            for i = 2:length(lapse.h)
                %[lapse.T(i), ~, lapse.P(i),lapse.rho(i)] = atmoslapse(lapse.h(i), lapse.L(i-1), lapse.rho(i-1), lapse.P(i-1), lapse.T(i-1), lapse.h(i-1));
                [lapse.T(i), theta] = temp(lapse.h(i), lapse.L(i-1), lapse.T(i-1),lapse.h(i-1));
                if strcmp(file,'Standard')
                    lapse.P(i) = press(lapse.T(i),theta,lapse.L(i-1),lapse.P(i-1),lapse.h(i)-lapse.h(i-1));          
                end
            end
            m.lapsedata = lapse;
        end
        function [T, a, P, rho] = airAt(m, h)
            import PropPrelib.vecfun;
            T = vecfun(@tempAtAlt, h, m.lapsedata);
            a = spdofsnd(T);
            P = vecfun(@pressAtAlt, h);
            rho = dense(T, P);
        end
    end
    methods(Static)
        function [T, a, P, rho] = stdAir()
            import PropPrelib.AtmosModel;
            T = AtmosModel.Standard.lapsedata.T(1);
            a = spdofsnd(T);
            P = AtmosModel.Standard.lapsedata.P(1);
            rho = dense(T, P);
        end
    end
    enumeration
        Standard('Standard'),
        Cold('Cold'),
        Hot('Hot'),
        Tropic('Tropic')
    end
end

function [T, theta] = temp(h, L, T0, H0)
    if nargin == 3
        H0 = 0;
    end
    T = T0 - L.*(h-H0);
    theta = T./T0;
end

function T = tempAtAlt(h, lapse)
    id = find(lapse.h<=h, 1, 'last');
    T = temp(h, lapse.L(id), lapse.T(id), lapse.h(id));
end

function a = spdofsnd(T)
    gamma = 1.4;
    R = 287.0531;
    a = sqrt(T.*gamma.*R);
end

function P = press(T, theta, L, P0, dh)
    g = 9.80665;
    R = 287.0531;
    if L == 0
        P = P0.*exp(-g*dh/(R.*T));
    else
        P = P0.*theta.^(g./(L.*R));
    end
    
end

function P = pressAtAlt(h)
    lapse = PropPrelib.AtmosModel.Standard.lapsedata;
    id = find(lapse.h<=h, 1, 'last');
    [T, theta] = temp(h, lapse.L(id), lapse.T(id), lapse.h(id));
    P = press(T, theta, lapse.L(id), lapse.P(id), h-lapse.h(id));
end

function rho = dense(T, P)
    rho = P./(287.0531.*T);
end

