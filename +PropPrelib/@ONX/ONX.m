classdef ONX
    properties
        Cycle, GasModel, UnitSystem,
        Mach, Altitude, Tempurature, Pressure, 
        Cp_c, Gamma_c, Cp_t, Gamma_t,
        FuelHeatingValue, Tt4, Tt7, Gamma_AB, 
        BleedAirFlow, CoolingAirFlow1, CoolingAirFlow2,
        CTOL, CTOH,
        PiDiffuserMax, PiBurner, PiAfterBurner, PiNozzle,
        eta_Fan, eta_LPC, eta_HPC, eta_HPT, eta_LPT
        nu_Burner, nu_Afterburner, nu_LPS, nu_HPS, nu_PTO_L, nu_PTO_H, P0dP9
        PiMixerMax, Ma6
        CPR, LPCPR, FPR, BR
    end
    methods
        function obj = ONX(filename)
            load_from_file(obj, filename);
        end
        function save(obj,filename)
            save_to_file(obj, filename);
        end
    end
    methods (Static)
        function obj = loadDefaults()
            obj = ONX(PropPrelib.prop_resource('@ONX/Onx.onx'));
        end
    end
end

