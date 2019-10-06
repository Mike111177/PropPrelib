function [V, Ps] = VmaxPs(h,TR, TL, WL, Beta_TO, n, AB)
%[V, Ps] = VMAXPS (h, TR, TL, WL, beta, n, AB)
%Given altitude, Throttle Ratio, Thrust Loading, Wing Loading,
%beta, n, and AB settting, calculate velocity for maxexcess power.
%Requires dragmodel set.
%Requires enginemodel set.
%Requires units set.
%Requires atmodel set.
    opts = optimoptions(@fmincon,'Algorithm','sqp');
    problem = createOptimProblem('fmincon','objective',...
        @negPs,'x0',1000,'lb',200,'ub',2000,'options',opts);
    ms = MultiStart('Display', 'off');
    [V,Ps] = run(ms,problem,8);
    Ps = Ps.*-1;
    
    function nPs = negPs(V)
        import PropPrelib.*
        nPs = 0-PsFVh(V, h, TR, TL, WL, Beta_TO, n, AB);
    end
end