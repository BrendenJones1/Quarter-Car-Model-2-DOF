function [t, yr] = iso_road_profile(P, T)
%ISO_ROAD_PROFILE  Generate time-domain road displacement yr(t) via
% frequency-domain synthesis matching S(f) ~ C * f^{-n} over [fmin, fmax].
% Simple ISO-8608-like profile (not exact standard mapping).
%
% Inputs: P.road fields: fmin, fmax, Gd0, n, v_ms, seed
% Output: time vector t and road displacement yr(t) [m]

dt = P.dt;
t  = (0:dt:T)';       % time [s]
N  = numel(t);
fs = 1/dt;

f  = (0:N-1)'*(fs/N); % frequency grid [Hz]

fmin = P.road.fmin;
fmax = min(P.road.fmax, fs/2);
band = (f >= fmin) & (f <= fmax);

n  = P.road.n;
C  = P.road.Gd0;      % roughness scale (tune as needed)

% Random phases, fixed seed for repeatability
rng(P.road.seed);
phi = 2*pi*rand(N,1);

S = zeros(N,1);
S(band) = C .* (f(band).^-n + eps);  % PSD ~ C f^{-n}

% Approximate amplitude spectrum for finite signal length
amp = zeros(N,1);
amp(band) = sqrt(S(band) * fs / 2);

Y = zeros(N,1) + 1i*zeros(N,1);
Y(band) = amp(band) .* exp(1i*phi(band));

% Hermitian symmetry (real signal)
for k = 2:floor(N/2)
    Y(N-k+2) = conj(Y(k));
end

y = real(ifft(Y));
yr = y - y(1); % remove DC offset
yr = yr(:);
end