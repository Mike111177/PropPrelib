function [T, h, Pr, phi, Cp, R, gam, a] = FAIR(Item, f, T, h, Pr, phi)
%Derived from equations
    if f>0.0676
        error('f cannot be greater than 0.0676')
    end
    switch (Item) 
        case 1 %T is known
            if nargin>2
            	[h, Pr, phi, Cp, R, gam, a] = unFAIR(T, f);
            else
                error('T must be defined for case 1');
            end
        case 2 %h is known
            if nargin>3
                T = fminbnd(@(T)abs(h-findh(f,T)),300,4000);
                [h, Pr, phi, Cp, R, gam, a] = unFAIR(T, f);
            else
                error('h must be defined for case 2');
            end
         case 3 %Pr is known
            if nargin>4
                T = fminbnd(@(T)abs(Pr-findPr(f,T)),300,4000);
                [h, Pr, phi, Cp, R, gam, a] = unFAIR(T, f);
            else
                error('Pr must be defined for case 2');
            end
          case 4 %phi is known
            if nargin>5
                T = fminbnd(@(T)abs(phi-findphi(f,T)),300, 4000);
                [h, Pr, phi, Cp, R, gam, a] = unFAIR(T, f);
            else
                error(' must be defined for case 2');
            end
    end
end

function h = findh(f, T)
    h = unFAIR(T, f);
end

function Pr = findPr(f, T)
    [~, Pr] = unFAIR(T, f);
end

function phi = findphi(f, T)
    [~, ~, phi] = unFAIR(T, f);
end

function [h, Pr, phi, Cp, R, gam, a] = unFAIR(T, FAR)
    BTU_lbm_to_ft2_s2 = 25037.00;
    
    [Cp_a, h_a, phi_a] = AFPROP_A(T);
    [Cp_p, h_p, phi_p] = AFPROP_P(T);

    %============ Equation 4.26 a,b,c,d ===================
    R = 1.9857117./(28.97-FAR.*0.946186); %BTU ./( lbm R)
    Cp = (Cp_a+FAR.*Cp_p)./(1+FAR);
    h = (h_a+FAR.*h_p)./(1+FAR);
    phi = (phi_a+FAR.*phi_p)./(1+FAR);
    %============ Equation 2.55 - " reduced pressure " =======
    phi_ref = 1.578420959; %BTU ./( lbm R) phi@492 .00 R    

    Pr = exp((phi-phi_ref)./R);

    gam = Cp./(Cp-R);
    a = sqrt(gam.*R.*BTU_lbm_to_ft2_s2.*T);
end

function [Cp_a, h_a, phi_a] = AFPROP_A(T)
    %===== Define coeficients from Table 2.2 for air alone ======
    A0 =  2.5020051E-01;
    A1 = -5.1536879E-05;
    A2 =  6.5519486E-08;
    A3 = -6.7178376E-12;
    A4 = -1.5128259E-14;
    A5 =  7.6215767E-18;
    A6 = -1.4526770E-21;
    A7 =  1.0115540E-25;
    h_ref  = -1.7558886; %BTU ./lbm
    phi_ref = 0.0454323; %BTU ./(lbm R)
    %====== Equations 2.60 ,2.61 , 2.62 for air alone ===========
    [Cp_a, h_a, phi_a] = AFPROP(T, A0, A1, A2, A3, A4, A5, A6, A7, h_ref, phi_ref);
    %==============================================================
end

function [Cp_p, h_p, phi_p] = AFPROP_P(T)
    %==== Now change coefficients for the products of combustion . 
    A0 =  7.3816638E-02;
    A1 =  1.2258630E-03;
    A2 = -1.3771901E-06;
    A3 =  9.9686793E-10;
    A4 = -4.2051104E-13;
    A5 =  1.0212913E-16;
    A6 = -1.3335668E-20;
    A7 =  7.2678710E-25;
    h_ref  = 30.58153;  %BTU ./lbm
    phi_ref = 0.6483398; %BTU ./( lbm R)
    [Cp_p, h_p, phi_p] = AFPROP(T, A0, A1, A2, A3, A4, A5, A6, A7, h_ref, phi_ref);
end

function [Cp, h, phi] = AFPROP(T, A0, A1, A2, A3, A4, A5, A6, A7, h_ref, phi_ref)
    Cp = A0 + A1.*T + A2.*T.^2 + A3.*T.^3 +...
           A4.*T.^4 + A5.*T.^5 + A6.*T.^6 + A7.*T.^7;

    h = h_ref + A0.*T + A1./2.*T.^2 + A2./3.*T.^3 + A3./4.*T.^4 +...
          A4./5.*T.^5 + A5./6.*T.^6 + A6./7.*T.^7 + A7./8.*T.^8;

    phi = phi_ref + A0.*log(T) + A1.*T + A2./2.*T.^2 + A3./3.*T.^3 +...
            A4./4.*T.^4 + A5./5.*T.^5 + A6./6.*T.^6 + A7./7.*T.^7;
end