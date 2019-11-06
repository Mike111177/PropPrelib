function VT = ConstantPs(H,V, TR, TL, WL, Beta_TO, n, AB)
import PropPrelib.*    
VT = zeros(length(H),length(V));
for i = 1:length(H)
    for j = 1:length(V)
        VT(i, j) = PsFVh(V(j), H(i), TR, TL, WL, Beta_TO, n, AB);
    end
end
end

