function [SCHED, VT] = MinTimeClimb(H,V, TR, TL, WL, Beta_TO, n, AB)
    if nargin == 3
        VT = TR;
    else
        VT = Contours.ConstantPs(H,V, TR, TL, WL, Beta_TO, n, AB);
    end
    for i = 1:length(H)
        [k,j] = max(VT(i,:));
        SCHED(i) = V(j);
    end
end

