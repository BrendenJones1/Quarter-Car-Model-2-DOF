function out = sim_step_bump(sys, P, h, T)
%SIM_STEP_BUMP  Step bump of height h [m] for duration T [s].
if nargin < 3 || isempty(h), h = 0.02; end
if nargin < 4 || isempty(T), T = P.T;  end

t = (0:P.dt:T)';
u = h*ones(size(t));   % step road input

[y, ~, x] = lsim(sys, u, t);

% Derived signals
zs = x(:,1); vs = x(:,2); zu = x(:,3); vu = x(:,4);
xsus = zs - zu;
xtire = zu - u;

as = gradient(vs, t);
au = gradient(vu, t);
Ft = P.kt * xtire;

out.t = t; out.u = u; out.x = x; out.y = y;
out.zs = zs; out.vs = vs; out.zu = zu; out.vu = vu;
out.xsus = xsus; out.xtire = xtire; out.as = as; out.au = au; out.Ft = Ft;
end