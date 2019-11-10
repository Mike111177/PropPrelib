function eta = Eta_Rspec(M)
%ETA_RSPEC Summary of this function goes here
%   Detailed explanation goes here
if M <= 1
    eta = 1;
elseif M <= 5
    eta = 1-0.075*(M - 1)^1.35;
else
    eta = 800/(M^4 + 935);
end
end

