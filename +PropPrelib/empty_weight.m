function We = empty_weight(Wto, A, B)
%Empty_Weight Calculates empty weight based off of full weight
%You can use A and B vars to choose your own model
if nargin == 1
    import PropPrelib.dragmodel
    model = dragmodel;
    A = model.A;
    B = model.B;
end
We = Wto.*A.*Wto.^-B;
end

