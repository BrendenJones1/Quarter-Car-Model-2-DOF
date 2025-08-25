function out = sim_random_road(sys, P, T)
%SIM_RANDOM_ROAD  Random road input via iso_road_profile over duration T [s].
if nargin < 3 || isempty(T), T = P.T; end

[t, u] = iso_road_profile(P, T);
[y, ~, x] = lsim(sys, u, t);

zs = x(:,1); vs = x(:,2); zu = x(:,3); vu = x(:,4);
xsus = zs - zu;
xtire = zu - u;

as = gradient(vs, t);
au = gradient(vu, t);
Ft = P.kt * xtire;

out.t = t; out.u = u; out.x = x; out.y = y;
out.zs = zs; out.vs = vs; out.zu = zu; out.vu = vu;
out.xsus = xsus; out.xtire = xtire; out.as = as; out.au = au; out.Ft = Ft;

% Metrics
out.metrics.a_s_rms   = rms(as);
out.metrics.xtire_rms = rms(xtire);
out.metrics.xsus_pk   = max(abs(xsus));
end