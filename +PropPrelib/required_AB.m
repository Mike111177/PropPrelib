function [AB_req, alpha_avail] = required_AB(alpha_req, theta_0, delta_0, TR)
    import PropPrelib.*;
    AB_req = fminbnd(@(ABv)abs(alpha_req-thrustLapse('theta_0', theta_0,...
                                                     'delta_0', delta_0,...
                                                     'TR', TR,...
                                                     'AB', ABv)), 0, 1);
    AB_req = round(AB_req, 3);
    alpha_avail = thrustLapse('theta_0', theta_0,...
                              'delta_0', delta_0,...
                              'TR', TR,...
                              'AB', AB_req);   
end

