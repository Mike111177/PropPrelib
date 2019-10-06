function [V, H, Ps, M] = MinTimeClimbSch(h, TR, TL, WL, Beta_TO, h_TO, n, AB, inc, M_Max)
    %MINTIMECLIMBSCH 
    import PropPrelib.*
    persistent memMinTimeClimbSch
    if isempty(memMinTimeClimbSch)
        % Useful when running comparisons between mach limited and unrestriced velocities
        % Dont have to recalculate Ps/V relations, since this func can take like 30 seconds
        % per run
        memMinTimeClimbSch = memoize(@MinTimeClimbSchIMPL); 
    end
    if nargin == 8
       inc = 5;
    end
    H = linspace(h_TO, h, inc);

    [V, Ps] = memMinTimeClimbSch(H, TR, TL, WL, Beta_TO, n, AB);

    [~, a] = atmos(H);
    M = V./a;
    if nargin == 10
        M(M>M_Max) = M_Max;
        V = M.*a;
    end
end

function [V, Ps] = MinTimeClimbSchIMPL(H, TR, TL, WL, Beta_TO, n, AB)
    import PropPrelib.*
    [V, Ps] = vecfun(@VmaxPs, H, TR, TL, WL, Beta_TO, n, AB);
end