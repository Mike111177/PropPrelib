function [performance, reference] = MFTEPCA(design, control)
import PropPrelib.Mattingly.MixedFlowTurboFan.CSH.*

[r, d] = resolve_ambient(build_stations(), design_comp(design));

r.mdot(0) = d.mdot0;
r = design_point(d,r);

if nargin == 1 || nargout > 1 %If only doing design point, or if outputting reference
    reference = tidy_results(d, perf_metrics(d, r));
end
        
if nargin == 1
    performance = reference;
else
    [p, c] = resolve_ambient(build_stations(), d, control);
    p = off_design(d, c, r, p);
    performance = p;
end
end




    
