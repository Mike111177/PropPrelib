function p = off_design(d, c, r, p)
import PropPrelib.gc

%Whether or not to iterate if control values exceeded
control_iterate = true;
debug = true;
p.itercount = 0;

Pi_ABdry = 1 - (1 - d.Pi_AB)/2;

%Set initial values:
p.Pi_tH = r.Pi_tH; p.Pi_tL = r.Pi_tL; p.Tau_tH = r.Pi_tH; p.Tau_tL = r.Tau_tL;
p.Pi_f = d.Pi_f; p.Pi_cL = d.Pi_cL; p.Pi_cH = d.Pi_cH;
p.Tau_f = r.Tau_f; p.Tau_cL = r.Tau_cL; p.Tau_cH = r.Tau_cH;
p.Tau_m1 = r.Tau_m1; p.Tau_m2 = r.Tau_m2; p.f(4) = r.f(4);
p.M(4) = 1; p.M(4.5) = 1; p.M6A = r.M6A; p.M(8) = 1;%r.M(8);

%Initial Estimations
p.mdot(0) = r.mdot(0);
p.M(6) = d.M6;
alpha = d.alpha*(c.T0/d.T0)*(p.Tau_r/r.Tau_r); % EQ (5.19d) 2nd. Ed
f4p5 = p.f(4)*(1 - d.Beta - d.Eps_1 - d.Eps_2)/(1 - d.Beta);
f6A = f4p5*(1 - d.Beta)/(1 + d.alpha - d.Beta);

%Calculations from reference

%5.1CPG
A4dA4p5 = r.Pi_tH/sqrt(r.Tau_tH)/((1+(d.Eps_1+d.Eps_2)/((1 - d.Beta - d.Eps_1 - d.Eps_2)*(1+r.f(4))))*sqrt(r.Tau_m1*r.Tau_m2));

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
            p.Tt(4) = Tt4;
            alpha_p = alpha/((1 + p.f(4))*(1 - d.Beta - d.Eps_1 - d.Eps_2) + d.Eps_1 + d.Eps_2);
            f4p5 = p.f(4)*(1 - d.Beta - d.Eps_1 - d.Eps_2)/(1 - d.Beta);
            p.Tau_L = (d.C_pc*p.Tt(4)/p.h(0));
            
            p.Tau_f = 1 + (...
                            (1 - p.Tau_tL)*d.Eta_mL*(...
                                                        (1-d.Beta-d.Eps_1-d.Eps_2)*(1+p.f(4))*(p.Tau_L*p.Tau_tH/p.Tau_r)...
                                                        +(d.Eps_1*p.Tau_tH + d.Eps_2)*p.Tau_cL*p.Tau_cH)...
                            - (1+alpha)/(p.Tau_r*d.Eta_mPL)*r.PTOL/(p.mdot(0)*p.h(0)))...
                            /((r.Tau_cL-1)/(r.Tau_f-1)+alpha);
                        
            p.Tau_cL = 1 + (p.Tau_f - 1)*((r.Tau_cL - 1)/(r.Tau_f-1));
            
            p.Tau_cH = 1 + (1 - p.Tau_tH)*d.Eta_mH*(...
                                                (1 - d.Beta - d.Eps_1 - d.Eps_2)*(1+p.f(4))*(p.Tau_L/(p.Tau_r*p.Tau_cL)) + d.Eps_1*p.Tau_cH)...
                       - (1+alpha)/(p.Tau_r*p.Tau_cL*d.Eta_mPH)*r.PTOH/(p.mdot(0)*p.h(0));

            p.Pi_f  = (1 + r.Eta_f *(p.Tau_f-1)) ^(d.gamma_c/(d.gamma_c-1)); %(5.6b-CPG)
            p.Pi_cL = (1 + r.Eta_cL*(p.Tau_cL-1))^(d.gamma_c/(d.gamma_c-1)); %(5.6d-CPG)
            p.Pi_cH = (1 + r.Eta_cH*(p.Tau_cH-1))^(d.gamma_c/(d.gamma_c-1)); %(5.8b-CPG)
            p.Pi_c  = p.Pi_cL  * p.Pi_cH;
            p.Tau_c = p.Tau_cL * p.Tau_cH;
            p.f(4) = (p.Tau_L - p.Tau_r*p.Tau_cL*p.Tau_cH)/(d.h_Pr*d.Eta_b/p.h(0) - p.Tau_L);
            
            p.Tt(5) = p.Tt(4)*p.Tau_cL*p.Tau_cH;
            p.Tt(6) = p.Tt(5);
            
            f4p5 = p.f(4)*(1 - d.Beta - d.Eps_1 - d.Eps_2)/(1 - d.Beta);        
            
            Pt16dPt6 = p.Pi_f/(p.Pi_cL*p.Pi_cH*d.Pi_b*p.Pi_tH*p.Pi_tL);
            PtdP_6 = (1+(d.gamma_t-1)/2*p.M(6)^2)^(d.gamma_t/(d.gamma_t-1)); %(5.9a-CPG)  
            PtdP_16 = Pt16dPt6*PtdP_6;
            
            if PtdP_16 < 1
                p.M(6) = p.M(6) - 0.01;
                if debug
                    fprintf('PtdP_16 > PtP || PtdP_16 < 1\nM6 was: %.3f\n', p.M(6));
                    
                end %This could be made much more efficient
                continue; % goto 1
            end
            
            sqrt(2/(d.gamma_c - 1)*(Pt16dPt6^((d.gamma_c-1)/d.gamma_c)-1)) %(5.9b-CPG)
            
            [~, TtT, PtdP_16, MFP16] = RGCOMPR(3, Tt16, r.M16, 0, TtT, PtdP_16);
            T16 = Tt16/TtT;
            alpha_p_new = (Pt16*MFP16)/(Pt6*MFP6)*r.A16__dA6*sqrt(Tt6/Tt16);
            alpha_p_error = abs((alpha_p_new - alpha_p)/alpha_p);
            alpha = alpha_p_new*((1 + p.f(4))*(1 - d.Beta - d.Eps_1 - d.Eps_2) + d.Eps_1 + d.Eps_2);
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
            
            %Mach number at station 8 (M8).
            Pt9dP0dry = p.Pi_r*p.Pi_d*p.Pi_cL*p.Pi_cH*d.Pi_b*p.Pi_tH*p.Pi_tL*p.Pi_M*Pi_ABdry*d.Pi_n; %(5.15)
            p.M(9) = sqrt(2/(gamma6A-1)*(Pt9dP0dry^((gamma6A-1)/gamma6A)));
            if p.M(9) > 1; p.M(8) = 1; else; p.M(8) = p.M(9); end
            
            %Mach number at station 6 (M6).
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
            [~, TtT, PtP, MFP4] = RGCOMPR(1, Tt4, p.M4, p.f(4));
            % I Nondimesionalised these EQ's with respect to mdot0_R
            mdot0_new = ((1 + r.f)/(1 + p.f(4)))...
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




