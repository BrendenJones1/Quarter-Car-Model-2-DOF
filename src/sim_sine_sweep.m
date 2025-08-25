function out = sim_sine_sweep(sys, P, A, f1, f2, T)
%SIM_SINE_SWEEP  Logarithmic sine sweep input y_r(t) = A*sin(2*pi*f(t)*t).
% Default: A=5 mm, f: 0.5 -> 30 Hz over T seconds.
if nargin < 3 || isempty(A),  A  = 0.005; end
if nargin < 4 || isempty(f1), f1 = 0.5;   end
if nargin < 5 || isempty(f2), f2 = 30.0;  end
if nargin < 6 || isempty(T),  T  = P.T;   end

t = (0:P.dt:T)';
% Log sweep frequency law
K = (T / log(f2/f1));
phi = 2*pi*f1*K*(exp(t/K)-1);
u = A * sin(phi);

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
end