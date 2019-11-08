 function performance = MFTEPCAPerf(design, control, reference)
BTU_to_ft_lb = 780;
BTU_lbm_to_ft2_s2 = 25037.00;
BTU_p_sec_to_KW = 1.055;
import PropPrelib.Mattingly.*
import PropPrelib.gc

if nargin == 2
    reference = MFTEPCA(design);
end

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
        [~, h_0, P_r0, phi_0, C_p0, R_0, gamma_0, p.a0] = FAIR(1, 0, c.T_0);
end

p.V0 = d.M0*r.a0;
p.PTOL__dmdot = h_0*d.CTOL*BTU_p_sec_to_KW;
p.PTOH__dmdot = h_0*d.CTOH*BTU_p_sec_to_KW;

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

Pi_ABdry = 1 - (1 - r.Pi_AB)/2;

%Set initial values:
p.Pi_tH = r.Pi_tH; p.Pi_tL = r.Pi_tL; p.Tau_tH = r.Pi_tH; p.Tau_tL = r.Tau_tL;
p.Pi_f = r.Pi_f; p.Pi_cL = r.Pi_cL; p.Pi_cH = r.Pi_cH;
p.Tau_f = r.Tau_f; p.Tau_cL = r.Tau_cL; p.Tau_cH = r.Tau_cH;
p.Tau_m1 = r.Tau_m1; p.Tau_m2 = r.Tau_m2; p.f = r.f;
p.M4 = 1; p.M4p5 = 1; p.M6A = r.M6A; p.M8 = r.M8;

[~, ht4, Prt4, phit4, cpt4, Rt4, gammat4, at4] = FAIR (1, f, Tt4);
ht4p5 = ht4*p.Tau_m1*p.Tau_tH*p.Tau_m2;
f4p5 = p.f*(1 - d.Beta - d.Eps1 - d.Eps2)/(1 - d.Beta);
[Tt4p5i, ~, Prt4p5, phit4p5, cpt4p5, Rt4p5, gammat4p5, at4p5] = FAIR(2, f4p5, NaN, ht4p5);
ht5 = ht4p5*Tau_tL;
[Tt5i, ~, Prt5, phit5, cpt5, Rt5, gammat5, at5] = FAIR(2, f4p5, NaN, ht4p5);
ht6A = ht5*r.Tau_m %???
f6A = f4p5(1 - ?)/(1 + ? - ?)
[Tt6A, ~, Prt6A, phit6A, cpt6A, Rt6A, gammat6A, at6A] = FAIR(2, f6A, NaN, ht6A);
FAIR (2, f6A, Tt6A, ht6A, Prt6A, ?t6A, cpt6A, Rt6A, ?t6A, at6A)
while true %Label 1
    ht3 = ht0?cL?cH
    FAIR (2, 0, Tt3, ht3, Prt3, ?t3, cpt3, Rt3, ?t3, at3)
    ? = ?/ {(1 + f )(1 - ? - ?1 - ?2) + ?1 + ?2}
    FAIR (1, f, Tt4, ht4, Prt4, ?t4, cpt4, Rt4, ?t4, at4)
    f4.5 = f (1 - ? - ?1 - ?2)/(1 - ?)
    TURBC (Tt4, f, A4/A4.5, M4, M4.5, ?tH, Tt4.5i, Tt3,?,?1, ?2, ?tH, ?tH, Tt4.5)
    TURB (Tt4.5, f4.5, A4.5/A6, M4.5, M6, ?tL, Tt5i, ?tL, ?tL, Tt5)
    ?? = ht4/h0

    ? f = 1 +

    (1 - ?tL)?mL
    (1 - ? - ?1 - ?2) (1 + f )
    ???tH
    ?r
    + (?1?tH + ?2) ?cL?cH 
    - (1 + ?)
    ?r?mPL
    PTOL
    m? 0h0
     
    × {(?cL - 1)R/(? f - 1)R + ?}
    ?cL = 1 + (? f - 1)(?cL - 1)R
    (? f - 1)R
    ?cH = 1 + (1 - ?tH) ?mH 
    (1 - ? - ?1 - ?2) (1 + f ) ??
    ?r ?cL
    + ?1?cH
    - (1 + ?)
    ?r ?cL?mPH
    PTOH
    m? 0h0
    ht2 = ht0
    Prt2 = Prt0
    ht13 = ht2? f
    ht2p5 = ht2?cL
    ht3 = ht2.5?cH
    ht13i = ht2{1 + ? f (? f - 1)}
    ht2.5i = ht2{1 + ?cL(?cL - 1)}
    ht3i = ht2.5{1 + ?cH(?cH - 1)}
    [Tt13  , ~, Prt13  , phit13  , cpt13  , Rt13  , gammat13  , at13  ] = FAIR(2, 0, NaN, ht13  );
    [Tt13i , ~, Prt13i , phit13i , cpt13i , Rt13i , gammat13i , at13i ] = FAIR(2, 0, NaN, ht13i );
    [Tt2p5 , ~, Prt2p5 , phit2p5 , cpt2p5 , Rt2p5 , gammat2p5 , at2p5 ] = FAIR(2, 0, NaN, ht2p5 );
    [Tt2p5i, ~, Prt2p5i, phit2p5i, cpt2p5i, Rt2p5i, gammat2p5i, at2p5i] = FAIR(2, 0, NaN, ht2p5i);
    [Tt3   , ~, Prt3   , phit3   , cpt3   , Rt3   , gammat3   , at3   ] = FAIR(2, 0, NaN, ht3   );
    [Tt3i  , ~, Prt3i  , phit3i  , cpt3i  , Rt3i  , gammat3i  , at3i  ] = FAIR(2, 0, NaN, ht3i  );
    Pi_f  = Prt13i  /Prt2;
    Pi_cL = Prt2p5i /Prt2;
    Pi_cH = Prt3i   /Prt2p5;
    Pi_c  = Pi_cL   *Pi_cH;
    Tau_c = Tau_cL  *Tau_cH;
    while true %Label 2
        ftemp = p.f; 
        [~, ht4, Prt4, phit4, cpt4, Rt4, gammat4, at4] = FAIR(1, f, c.Tt4);
        p.f = (ht4 - ht3)/(hPR*Eta_b - ht4);
        if abs(f - ftemp) > 0.0001 
            continue; % goto 2
        end
        break;
    end
    ht6 = ht5
    Tt6 = Tt5
    ht16 = ht13
    Tt16 = Tt13
    Pt6 = P0 ?r ?d ?cL ?cH ?b ?tH ?tL
    f4.5 = f (1 - ? - ?1 - ?2)/(1 - ?)

    RGCOMPR (1, Tt6, M6, f4.5, TtT, PtP, MFP6)
    P6 = Pt6/PtP
    T6 = Tt6/TtT
    Pt16 = P0?r?d? f
         Pt
    P


    16
    = Pt16/P6
    RGCOMPR (1, Tt16, 1, 0, TtT, PtP, MFP16)
    if (Pt/P)16 > PtP then M6 = M6 - 0.01 goto 1
    if (Pt/P)16 < 1 then M6 = M6 - 0.01 goto 1
    RGCOMPR (3, Tt16, M16, 0, TtT, (Pt/P)16 , MFP16)
    T16 = Tt16/TtT
    ?
    new = Pt16A16MFP16
    Pt6A6MFP6

    Tt6
    Tt16
    ?
    error =



     b
    ?
    new - ?
    ?




    ? = ?
    new {(1 + f ) (1 - ? - ?1 - ?2) + ?1 + ?2}
    if ?
    error > 0.001 then
    %calculate a new ?
    %using Newtonian iteration
    goto 1
    end if
    FAIR (1, f4.5, T6, h6, Pr6, ?6, cp6, R6, ?6, a6)
    FAIR (1, 0, T16, h16, Pr16, ?16, cp16, R16, ?16, a16)
    ht6A = ht6 + ?
    ht16
    1 + ?
    ?M = ht6A
    ht6
    f6A = f4.5 (1 - ?) / (1 + ? - ?)
    FAIR (2, f6A, Tt6A, ht6A, Prt6A, ?t6A, cpt6A, Rt6A, ?t6A, at6A)
    Constant = 1
    1 + ?

    R6T6
    ?6
    1 + ?6M2
    6
    M6
    + ?

    R16T16
    ?16
    1 + ?16M2
    16
    M16 
    while true % Label 3
        [~, TtdT_6A, PtdP_6A, MFP_6A] = RGCOMPR(1, T_t6A, M6Ai, f_6A);
        T6A = Tt6A
        TtT6A
        FAIR (1, f6A, T6A, h6A, Pr6A, ?6A, cp6A, R6A, ?6A, a6A)
        M6Anew =

         R6AT6A
        ?6A
        1 + ?6AM2
        6A
        Constant
        M6Aerror = abs(M6Anew - M6A)
        if M6Aerror > 0.001 
            M6A = M6Anew 
            continue; %goto 3
        end
        break;
    end

    ?M ideal =

     Tt6A
    Tt6
    MFP6
    MFP6A
    1 + ?
    1 + A16/A6
    ?M = ?M max ?M ideal
    Pt9
    P0
    = ?r ?d ?cL ?cH ?b ?tH ?tL ?M ?AB dry ?n
    RGCOMPR (3, Tt6A, M9, f6A, TtT9, Pt9/P0, MFP9)
    if M9 > 1 then M8 = 1 else M8 = M9
    RGCOMPR (1, Tt6A, M8, f6A, TtT8, PtP8, MFP8)
    MFP6 = MFP8
    ?M ?AB dry
    1 + ?
    A8
    A6

    Tt6
    Tt6A
    RGCOMPR (4, Tt6, M6_new, f4p5, TtT6, PtP6, MFP6)
    M6_error = abs(M6 - M6_new);
    if M6_error > 0.0005
        if M6 > M6_new
            M6 = M6 - 0.0001;
        else
            M6 = M6 + 0.002
        end
        continue; % goto 1
    end
    RGCOMPR (1, Tt4, M4, f, TtT, PtP, MFP4)
    m? 0 new = m? 0R
    1 + fR
    1 + f
    P0(1 + ?)?r ?d ?cL ?cH
    {P0 (1 + ?) ?r ?d ?cL ?cH}R
    MFP4
    MFP4R

    Tt4R
    Tt4
    m? 0 error =

    m? 0 new - m? 0
    m? 0R

    if mdot0_error > 0.001
        mdot0 = mdot0_new;
        continue; % goto 1
    end
    break;
end
f7 = f6A
while true %Label 4
	[~, ht7, Prt7, phit7, cpt7, Rt7, gammat7, at7] = FAIR (1, f7, Tt7);
    fAB = (ht7 - ht6A)      /...
          (Eta_AB*hPR - ht6A);
    f7_new = f6A + fAB
    f7_error = abs(f7_new - f7);
    if f7_error > 0.00001
        f7 = f7_new;
        continue; %goto 4
    end
    break;
end
%AB = 100
Tt7 - Tt6A
Tt7R - Tt6A
?AB = ?AB dry + 0.01 × %AB(?ABR - ?AB dry)
Pt9
P0
= ?r ?d ?cL ?cH ?b ?tH ?tL ?M ?AB ?n
Pt9
P9
= Pt9
P0
P9
P0
Tt9 = Tt7
RGCOMPR (3, Tt9, M9, f7, TtT, Pt9/P9, MFP9)

m? 9 = m? 0 (1 + f7)

1 - ?
1 + ?

Pt9 = P0 ?r ?d ?cL ?cH ?b ?tH ?tL ?M ?AB ?n
A9 = m? 9
?Tt9
Pt9MFP9
T9 = Tt9/TtT
FAIR (1, f7, T9, h9, Pr9, ?9, cp9, R9, ?9, a9)
V9 = M9a9
fo = f (1 - ? - ?1 - ?2) + fAB(1 + ? - ?)
1 + ?
F
m? 0
= a0
gc
1 + fo - ?
1 + ?
 V9
a0
- M0
+

1 + fo - ?
1 + ?
 R9
R0
T9/T0
V9/a0
(1 - P0/P9)
?0

S = fo
F/m? 0
F = m? 0
 F
m? 0

RGCOMPR (1, Tt0, M0, 0, TtT, PtP, MFP0)
A0 = m? 0
?Tt0
Pt0MFP0
%RPMLP Spool = 100
h0?r(? f - 1)
[h0?r(? f - 1)]R
%RPMHP Spool = 100
h0?r ?cL(?cH - 1)
[h0?r ?cL(?cH - 1)]R
?P = 2gcM0
a0
F
m? 0

1 + fo - ?
1 + ?
V9
a0
2
- M2
0
	
?TH = 1
2gc

1 + fo - ?
1 + ?

V2
9 - V2
0

+ (CTOL + CTOH) h0
fohPR
?O = ?TH?P
end

