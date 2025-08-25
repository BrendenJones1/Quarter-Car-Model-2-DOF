function R = pareto_sweep(P, kw_vec, zeta_vec, random_T)
%PARETO_SWEEP  Sweep spring (kw) and damping ratio (zeta) to trade off comfort/grip.
% R returns a struct array with fields: kw, cs, a_s_rms, xtire_rms, xsus_pk.

if nargin < 2 || isempty(kw_vec),   kw_vec   = linspace(0.7*P.kw, 1.3*P.kw, 9); end
if nargin < 3 || isempty(zeta_vec), zeta_vec = linspace(0.15, 0.45, 7); end
if nargin < 4 || isempty(random_T), random_T = 10.0; end

ms = P.ms;
R = [];
idx = 1;
for kw = kw_vec
    wn = sqrt(kw/ms);
    ccrit = 2*sqrt(kw*ms);
    for zeta = zeta_vec
        P2 = P;
        P2.kw = kw;
        P2.cs = zeta * ccrit;
        sys = quarter_car_ss(P2);
        out = sim_random_road(sys, P2, random_T);
        R(idx).kw = kw;
        R(idx).cs = P2.cs;
        R(idx).zeta = zeta;
        R(idx).a_s_rms = out.metrics.a_s_rms;
        R(idx).xtire_rms = out.metrics.xtire_rms;
        R(idx).xsus_pk = out.metrics.xsus_pk;
        idx = idx + 1;
    end
end
end