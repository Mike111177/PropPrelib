function performance = MFTEPCAPerf(design, control, reference, control_iterate, debug)
BTU_to_ft_lb = 780;
BTU_lbm_to_ft2_s2 = 25037.00;
BTU_p_sec_to_KW = 1.055;
import PropPrelib.Mattingly.*
import PropPrelib.gc

if nargin == 2
    reference = MFTEPCA(design);
end

%Whether or not to iterate if control values exceeded
if nargin < 4
    control_iterate = true;
end

if nargin < 5
    debug = false;
end

p.itercount = 0;

d = design;
r = reference;
c = control;

heatmodel = r.hmodel;

%Preliminary computations:
%Ambient Gas Properties
switch (heatmodel)
    case 1
        R_c = d.C_pc - d.C_pc/d.gamma_c;
        R_0 = R_c;
        C_p0 = d.C_pc;
        gamma_0 = d.gamma_c;
        p.a0 = sqrt(d.gamma_c*R_c*c.T_0*gc*BTU_to_ft_lb);
        h_0 = d.C_pc*d.T_0;
    case 3
        [~, h_0, P_r0, phi0, Cp0, R0, gamma0, p.a0] = FAIR(1, 0, c.T_0);
end

p.V0 = d.M0*r.a0;
%CTOL/CTOH constant?
p.PTOL__dmdot = h_0*d.CTOL*BTU_p_sec_to_KW;
p.PTOH__dmdot = h_0*d.CTOH*BTU_p_sec_to_KW;

p.Pi_d = d.Pi_dmax * Eta_Rspec(c.M0);

%Tau R, Pi R
switch (heatmodel)
    case 1 % Constant Specific Heat
        p.Tau_r = 1 + (gamma_0-1)/2*c.M0^2;     % 4.5a-CPG
        p.Pi_r = p.Tau_r^(gamma_0/(gamma_0-1)); % 4.5b-CPG
        T_t0 = c.T_0*p.Tau_r;
    case 3 % Variable Specific Heat
        h_t0 = h_0 + (p.V0^2)/(2*gc)/BTU_to_ft_lb;
        [T_t0, ~, P_rt0, phi_t0, c_pt0, R_t0, gamma_t0, a_t0] = FAIR(2, 0, NaN, h_t0);
        p.Tau_r = h_t0/h_0;  % 4.5a
        p.Pi_r = P_rt0/P_r0; % 4.5b
        h_t2 = h_t0;
        P_rt2 = P_rt0;
end

Pi_ABdry = 1 - (1 - d.Pi_AB)/2;

%Set initial values:
p.Pi_tH = r.Pi_tH; p.Pi_tL = r.Pi_tL; p.Tau_tH = r.Pi_tH; p.Tau_tL = r.Tau_tL;
p.Pi_f = d.Pi_f; p.Pi_cL = d.Pi_cL; p.Pi_cH = d.Pi_cH;
p.Tau_f = r.Tau_f; p.Tau_cL = r.Tau_cL; p.Tau_cH = r.Tau_cH;
p.Tau_m1 = r.Tau_m1; p.Tau_m2 = r.Tau_m2; p.f = r.f;
p.M4 = 1; p.M4p5 = 1; p.M6A = r.M6A; p.M8 = r.M8;
%Initial Estimations
p.mdot0__dmdot0R = 1;
p.M6 = d.M6;
alpha = d.alpha*(c.T_0/d.T_0)*(p.Tau_r/r.Tau_r); % EQ (5.19d) 2nd. Ed

[~, ht4, Prt4, phit4, cpt4, Rt4, gammat4, at4] = FAIR(1, p.f, c.Tt4); %This is also iterated later
ht4p5 = ht4*p.Tau_m1*p.Tau_tH*p.Tau_m2;
f4p5 = p.f*(1 - d.Beta - d.Eps_1 - d.Eps_2)/(1 - d.Beta);
[Tt4p5i, ~, Prt4p5, phit4p5, cpt4p5, Rt4p5, gammat4p5, at4p5] = FAIR(2, f4p5, NaN, ht4p5);
ht5 = ht4p5*p.Tau_tL;
[Tt5i, ~, Prt5, phit5, cpt5, Rt5, gammat5, at5] = FAIR(2, f4p5, NaN, ht4p5);
ht6A = ht5*r.Tau_M;
f6A = f4p5*(1 - d.Beta)/(1 + d.alpha - d.Beta);
[Tt6A, ~, Prt6A, phit6A, cpt6A, Rt6A, gammat6A, at6A] = FAIR(2, f6A, NaN, ht6A);

%Iterate rest of calculations
TT4_Upper = c.Tt4; %Goal for TT4, will be reduced if needed
runEngine(TT4_Upper);
if control_iterate && ~checkLimits()
    offset = 0.01;
    if debug
        fprintf('Lowering TT4_Lower until a passing case is found')
    end
    while ~checkLimits()
        %Find lower bound where test passes
        TT4_Lower = TT4_Upper*(1 - offset);
        runEngine(TT4_Lower);
        offset = offset+0.005;
    end
    if debug
        fprintf('Maximising Tt4 within passing space')
    end
    while abs((TT4_Upper - TT4_Lower)/TT4_Upper) > 0.01
        TestTT4 = TT4_Lower+(TT4_Upper-TT4_Lower)/2;
        runEngine(TestTT4);
        if checkLimits()
            TT4_Lower = TestTT4;
            if debug
                fprintf('Increasing Lower Bound to %f\n', TT4_Lower);
            end
        else
            TT4_Upper = TestTT4;
            if debug
                fprintf('Decresing Upper Bound to %f\n', TT4_Upper);
            end
        end
    end
end
    function runEngine(Tt4)
        import PropPrelib.Mattingly.*
        import PropPrelib.gc
        while true %Label 1
            p.itercount = p.itercount + 1;
            if debug
                disp(p)
            end
            p.Tt4 = Tt4;
            ht3 = h_t0*p.Tau_cL*p.Tau_cH;
            [p.Tt3, ~, Prt3, phit3, cpt3, Rt3, gammat3, at3] = FAIR(2, 0, NaN, ht3);
            alpha_p = alpha/((1 + p.f)*(1 - d.Beta - d.Eps_1 - d.Eps_2) + d.Eps_1 + d.Eps_2);
            [~, ht4, Prt4, phit4, cpt4, Rt4, gammat4, at4] = FAIR(1, p.f, Tt4);
            f4p5 = p.f*(1 - d.Beta - d.Eps_1 - d.Eps_2)/(1 - d.Beta);
            [p.Pi_tH, p.Tau_tH, Tt4p5] = TURBC(Tt4  ,    p.f, r.A4__dA4p5, p.M4  , p.M4p5, r.Eta_tH, Tt4p5i, p.Tt3, d.Beta, d.Eps_1, d.Eps_2);
            [p.Pi_tL, p.Tau_tL, Tt5  ] =  TURB(Tt4p5, f4p5, r.A4p5__dA6, p.M4p5, p.M6    , r.Eta_tL, Tt5i); % TODO: Is M6 Constant or does it need to be iterated?
            p.Tau_L = ht4/h_0;
            
            %Typo in mattingly? last line mult or div?
%             p.Tau_f = 1 + (...
%                             (1 - p.Tau_tL)*d.Eta_mL*(...
%                             (1-d.Beta-d.Eps_1-d.Eps_2)*(1+p.f)*(p.Tau_L*p.Tau_tH/p.Tau_r)+...
%                             (d.Eps_1*p.Tau_tH + d.Eps_2)*p.Tau_cL*p.Tau_cH)...
%                             - (1+alpha)/(p.Tau_r*d.Eta_mPL)*PTOL/(mdot0*h0))...
%                             *((r.Tau_cL-1)/(r.Tau_f-1)+alpha);
            % is CTOL Constant, if so...
            p.Tau_f = 1 + (...
                            (1 - p.Tau_tL)*d.Eta_mL*(...
                                                        (1-d.Beta-d.Eps_1-d.Eps_2)*(1+p.f)*(p.Tau_L*p.Tau_tH/p.Tau_r)...
                                                        +(d.Eps_1*p.Tau_tH + d.Eps_2)*p.Tau_cL*p.Tau_cH)...
                            - (1+alpha)/(p.Tau_r*d.Eta_mPL)*d.CTOL)...
                            *((r.Tau_cL-1)/(r.Tau_f-1)+alpha);
                        
            p.Tau_cL = 1 + (p.Tau_f - 1)*((r.Tau_cL - 1)/(r.Tau_f-1));
            
%             p.Tau_cH = 1 + (1 - p.Tau_tH)*d.Eta_mH*(...
%                                                 (1 - d.Beta - d.Eps_1 - d.Eps_2)*(1+p.f)*(p.Tau_L/(p.Tau_r*p.Tau_cL)) + d.Eps_1*p.Tau_cH)...
%                        - (1+alpha)/(p.Tau_r*p.Tau_cL*d.Eta_mPH)*PTOH/(mdot*h0);
            % is CTOH Constant, if so...
            p.Tau_cH = 1 + (1 - p.Tau_tH)*d.Eta_mH*(...
                                                (1 - d.Beta - d.Eps_1 - d.Eps_2)*(1+p.f)*(p.Tau_L/(p.Tau_r*p.Tau_cL)) + d.Eps_1*p.Tau_cH)...
                       - (1+alpha)/(p.Tau_r*p.Tau_cL*d.Eta_mPH)*d.CTOH;

            ht13   = h_t2  * p.Tau_f;
            ht2p5  = h_t2  * p.Tau_cL;
            ht3    = ht2p5 * p.Tau_cH;
            ht13i  = h_t2  * (1 + r.Eta_f  * (p.Tau_f  - 1));
            ht2p5i = h_t2  * (1 + r.Eta_cL * (p.Tau_cL - 1));
            ht3i   = ht2p5 * (1 + r.Eta_cH * (p.Tau_cH - 1));
            [Tt13  , ~, Prt13  , phit13  , cpt13  , Rt13  , gammat13  , at13  ] = FAIR(2, 0, NaN, ht13  );
            [Tt13i , ~, Prt13i , phit13i , cpt13i , Rt13i , gammat13i , at13i ] = FAIR(2, 0, NaN, ht13i );
            [Tt2p5 , ~, Prt2p5 , phit2p5 , cpt2p5 , Rt2p5 , gammat2p5 , at2p5 ] = FAIR(2, 0, NaN, ht2p5 );
            [Tt2p5i, ~, Prt2p5i, phit2p5i, cpt2p5i, Rt2p5i, gammat2p5i, at2p5i] = FAIR(2, 0, NaN, ht2p5i);
            [Tt3   , ~, Prt3   , phit3   , cpt3   , Rt3   , gammat3   , at3   ] = FAIR(2, 0, NaN, ht3   );
            [Tt3i  , ~, Prt3i  , phit3i  , cpt3i  , Rt3i  , gammat3i  , at3i  ] = FAIR(2, 0, NaN, ht3i  );
            p.Pi_f  = Prt13i  / P_rt2;
            p.Pi_cL = Prt2p5i / P_rt2;
            p.Pi_cH = Prt3i   / Prt2p5;
            p.Pi_c  = p.Pi_cL  * p.Pi_cH;
            p.Tau_c = p.Tau_cL * p.Tau_cH;
            % Post-Burner Fuel Air Ratio Loop
            while true %Label 2
                ftemp = p.f;
                [~, ht4, Prt4, phit4, cpt4, Rt4, gammat4, at4] = FAIR(1, p.f, Tt4);
                p.f = (ht4 - ht3)/(d.h_Pr*d.Eta_b - ht4);
                if abs(p.f - ftemp) > 0.0001
                    continue; % goto 2
                end
                break;
            end
            ht6  = ht5;
            Tt6  = Tt5;
            ht16 = ht13;
            Tt16 = Tt13;
            Pt6  = c.P0*p.Pi_r*p.Pi_d*p.Pi_cL*p.Pi_cH*d.Pi_b*p.Pi_tH*p.Pi_tL;
            f4p5 = p.f*(1 - d.Beta - d.Eps_1 - d.Eps_2)/(1 - d.Beta);
            % Start of Page 566 2nd ED.
            [~, TtT, PtP, MFP6] = RGCOMPR(1, Tt6, p.M6, f4p5);
            P6 = Pt6/PtP;
            T6 = Tt6/TtT;
            Pt16 = c.P0*p.Pi_r*p.Pi_d*p.Pi_f;
            PtdP_16 = Pt16/P6;
            [~, TtT, PtP, MFP16] = RGCOMPR (1, Tt16, 1, 0);
            if PtdP_16 > PtP || PtdP_16 < 1
                p.M6 = p.M6 - 0.01;
                if debug
                    fprintf('PtdP_16 > PtP || PtdP_16 < 1\n')
                    PtdP_16
                    PtP
                end %This could be made much more efficient
                continue; % goto 1
            end
            [~, TtT, PtdP_16, MFP16] = RGCOMPR(3, Tt16, r.M16, 0, TtT, PtdP_16);
            T16 = Tt16/TtT;
            alpha_p_new = (Pt16*MFP16)/(Pt6*MFP6)*r.A16__dA6*sqrt(Tt6/Tt16);
            alpha_p_error = abs((alpha_p_new - alpha_p)/alpha_p);
            alpha = alpha_p_new*((1 + p.f)*(1 - d.Beta - d.Eps_1 - d.Eps_2) + d.Eps_1 + d.Eps_2);
            if alpha_p_error > 0.001
                % calculate a new alpha_p using Newtonian iteration
                if debug
                    fprintf('alpha_p_error > 0.001\n')                
                end
                continue; %goto 1
            end
            [~, h6 , Pr6 , phi6 , cp6 , R6 , gamma6 , a6 ] = FAIR(1, f4p5, T6 );
            [~, h16, Pr16, phi16, cp16, R16, gamma16, a16] = FAIR(1, 0   , T16);
            ht6A = (ht6 + alpha_p*ht16)/(1+alpha_p);
            p.Tau_M = ht6A/ht6;
            f6A = f4p5*(1 - d.Beta)/(1 + alpha - d.Beta);
            [Tt6A, ht6A, Prt6A, phit6A, cpt6A, Rt6A, gammat6A, at6A] = FAIR (2, f6A, NaN, ht6A);
            Constant = 1/(1+alpha_p)*(...
                                        sqrt(R6*T6/gamma6)*((1+gamma6*p.M6^2)/p.M6)...
                                        +alpha_p*sqrt(R16*T16/gamma16)*((1+gamma16*r.M16^2)/r.M16));
            while true % Label 3
                [~, TtdT_6A, PtdP_6A, MFP6A] = RGCOMPR(1, Tt6A, p.M6A, f6A);
                T6A = Tt6A/TtdT_6A;
                [~, h6A, Pr6A, phi6A, cp6A, R6A, gamma6A, a6A] = FAIR(1, f6A, T6A);
                M6Anew = sqrt(R6A*T6A/gamma6A)*(1+gamma6A*p.M6A^2)/Constant;
                M6Aerror = abs(M6Anew - p.M6A);
                if M6Aerror > 0.001
                    p.M6A = M6Anew;
                    continue; %goto 3
                end
                break;
            end
            % Start of Page 567 2nd ED.
            Pi_M_ideal = sqrt(Tt6A/Tt6)*(MFP6/MFP6A)*(1+alpha_p)/(1+r.A16__dA6);
            p.Pi_M = d.Pi_Mmax*Pi_M_ideal;
            Pt9dP0 = p.Pi_r*p.Pi_d*p.Pi_cL*p.Pi_cH*d.Pi_b*p.Pi_tH*p.Pi_tL*p.Pi_M*Pi_ABdry*d.Pi_n;
            [M9, TtT9, ~, MFP9] = RGCOMPR (3, Tt6A, NaN, f6A, NaN, Pt9dP0, NaN);
            if M9 > 1
                p.M8 = 1;
            else
                p.M8 = M9;
            end
            [~, TtT8, PtP8, MFP8] = RGCOMPR(1, Tt6A, p.M8, f6A);
            MFP6 = ((MFP8*p.Pi_M*Pi_ABdry)/(1 + alpha_p))*(r.A8__dA6)*sqrt(Tt6/Tt6A);
            [M6_new, TtT6, PtP6] = RGCOMPR(5, Tt6, NaN, f4p5, NaN, NaN, MFP6);
            M6_error = abs(p.M6 - M6_new);
            if M6_error > 0.0005
                if debug
                    fprintf('M6_error > 0.0005\n');
                    M6_error
                end
                if p.M6 > M6_new
                    p.M6 = p.M6 - 0.0001;
                else
                    p.M6 = p.M6 + 0.002;
                end
                continue; % goto 1
                %Okay this is one of the dumber optimisation strategies i have seen....
                %Thanks for the debug chore mattingly
            end
            [~, TtT, PtP, MFP4] = RGCOMPR(1, Tt4, p.M4, p.f);
            % I Nondimesionalised these EQ's with respect to mdot0_R
            mdot0_new = ((1 + r.f)/(1 + p.f))...
                                    *((c.P0*(1 + alpha)*p.Pi_r*p.Pi_d*p.Pi_cL*p.Pi_cH)/(d.P0*(1 + d.alpha)*r.Pi_r*r.Pi_d*d.Pi_cL*d.Pi_cH))...
                                    *((MFP4/r.MFP4))...
                                    *sqrt(d.Tt4/Tt4);
            mdot0_error = abs((mdot0_new - p.mdot0__dmdot0R));
            if mdot0_error > 0.001
                p.mdot0__dmdot0R = mdot0_new;
                continue; % goto 1
            end
            break;
        end
        % Pre control Iterations complete, on to final calcs
        f7 = f6A;
        while true %Label 4
            [~, ht7, Prt7, phit7, cpt7, Rt7, gammat7, at7] = FAIR (1, f7, c.Tt7);
            p.fAB = (ht7 - ht6A)/(d.Eta_AB*d.h_Pr - ht6A);
            f7_new = f6A + p.fAB;
            f7_error = abs(f7_new - f7);
            if f7_error > 0.00001
                f7 = f7_new;
                continue; %goto 4
            end
            break;
        end
        p.AB = (c.Tt7 - Tt6A)/(d.Tt7_max-Tt6A); %Fraction of AB used
        p.Pi_AB = Pi_ABdry + p.AB*(d.Pi_AB - Pi_ABdry);
        Pt9dP0 = p.Pi_r*p.Pi_d*p.Pi_cL*p.Pi_cH*d.Pi_b*p.Pi_tH*p.Pi_tL*p.Pi_M*p.Pi_AB*d.Pi_n;
        PtdP_9 = Pt9dP0/d.P0dP9;
        Tt9 = c.Tt7;
        [M9, TtT, ~, MFP9] = RGCOMPR (3, Tt9, M9, f7, NaN, PtdP_9, MFP9);
        % Start of Page 568 2nd ED.
%         mdot9 = mdot0*(1 + f7)*(1-d.Beta/(1+alpha)); Dimensional, Will be calculated elsewhere
        Pt9 = c.P0*p.Pi_r*p.Pi_d*p.Pi_cL*p.Pi_cH*d.Pi_b*p.Pi_tH*p.Pi_tL*p.Pi_M*p.Pi_AB*d.Pi_n;
%         A9 = mdot9*sqrt(Tt9)/(Pt9*MFP9); Dimensional, Will be calculated elsewhere
        T9 = Tt9/TtT;
        [~, h9, Pr9, phi9, cp9, R9, gamma9, a9] = FAIR(1, f7, T9);
        V9 = M9*a9;
        fo = (p.f*(1 - d.Beta - d.Eps_1 - d.Eps_2) + p.fAB*(1 + alpha - d.Beta))...
            /(1+alpha);
        p.F__dmdot0 = (p.a0/gc)*(...
                                    (1+fo-d.Beta/(1+alpha))*(V9/p.a0)...
                                    -c.M0...
                                    +(1+fo-d.Beta/(1+alpha))*(R9/R0)*((T9/c.T_0)/(V9/p.a0))*((1-d.P0dP9)/gamma0));
        p.S = fo*(p.F__dmdot0);
        [TtT, PtP, MFP0] = RGCOMPR(1, T_t0, c.M0, 0);
%       p.A0 = mdot0*sqrt(Tt0)/(Pt0*MFP0); Dimensional, Will be calculated elsewhere
        p.RPM_p_LP_Spool = 100*sqrt((h_0*p.Tau_r*(p.Tau_f-1))/(r.h_0*r.Tau_r*(r.Tau_f-1)));
        p.RPM_p_HP_Spool = 100*sqrt((h_0*p.Tau_r*p.Tau_cL*(p.Tau_f-1))/(r.h_0*r.Tau_r*r.Tau_cL*(r.Tau_f-1)));
        
        kf = (1+fo-(d.Beta/(1+d.alpha)))*(V9/p.V0)^2-1;
        PTOdm = (p.PTOL__dmdot + p.PTOH__dmdot)/BTU_p_sec_to_KW/BTU_to_ft_lb;
        p.Eta_TH = (r.V0^2/(2*gc))*(kf+PTOdm)/(fo*d.h_Pr*BTU_to_ft_lb); % 4.32b Modified
        p.Eta_P = 2*(p.F__dmdot0*gc/p.V0)/kf;%(4.32a)
        p.S = fo/p.F__dmdot0*3600;
        p.Eta_O = p.Eta_TH*p.Eta_P;     
    end
    function pass = checkLimits()
        pass = ~(limit('Pi_c_max', p.Pi_c, c) ||...
                 limit('Tt3_max' , p.Tt3 , c)); %Will add other limits later
        function exceeds_limit = limit(var, val, s)
            exceeds_limit = isfield(s, var) && s.(var)~=0 && val>s.(var);
        end
    end
    performance = p;
end




