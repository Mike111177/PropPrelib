function Gamma = WtodWe(Wto, A, B)
%Calculuates  off of full weight
%You can use A and B vars to choose your own model
if nargin == 1
    import PropPrelib.*
    model = dragmodel;
    A = model.A;
    B = model.B;
end
Gamma = A.*Wto.^-B;
end

