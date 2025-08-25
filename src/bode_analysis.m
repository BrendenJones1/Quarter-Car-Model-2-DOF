function W = bode_analysis(sys, P, fvec)
%BODE_ANALYSIS  Compute magnitude (dB) of transfer functions vs frequency.
% By default, evaluates from 0.5 to 30 Hz.
% Returns a struct with fields for key TFs:
%  G_as_yr : body accel / road disp
%  G_Ft_yr : tire force / road disp
%  G_xsus_yr : suspension travel / road disp

if nargin < 3 || isempty(fvec)
    fvec = logspace(log10(0.5), log10(30), 200);
end
w = 2*pi*fvec;

% Build output maps:
% y = Cx + D u; We'll use ss and frequency response.
G = tf(sys);

% Derived outputs using frequency response "manually":
% State-space: X(jw) = (jwI - A)^(-1) * B * U
% We'll compute outputs without creating new systems for speed.
A = sys.A; B = sys.B; C = sys.C; D = sys.D;
I = eye(size(A));

G_as_yr = zeros(size(w));
G_Ft_yr = zeros(size(w));
G_xsus_yr = zeros(size(w));

for i = 1:numel(w)
    jw = 1i*w(i);
    H = (jw*I - A)\B;     % state per unit input
    % states: [zs vs zu vu]
    vs_idx = 2; zs_idx = 1; zu_idx = 3;
    % body accel = d(vs)/dt = jw * vs(jw)
    X = H;  % 4x1
    vs = X(vs_idx);
    zs = X(zs_idx);
    zu = X(zu_idx);

    G_as_yr(i)   = jw * vs;                 % a_s / y_r
    G_xsus_yr(i) = (zs - zu);               % (zs-zu) / y_r
    G_Ft_yr(i)   = P.kt * (zu - 1);         % careful: input y_r has gain 1, so (zu - y_r) -> (zu - 1)
end

W.f = fvec;
W.G_as_yr   = G_as_yr;
W.G_xsus_yr = G_xsus_yr;
W.G_Ft_yr   = G_Ft_yr;
end