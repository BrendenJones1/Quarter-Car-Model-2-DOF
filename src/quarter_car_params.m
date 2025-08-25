function P = quarter_car_params()
%QUARTER_CAR_PARAMS
% Units: SI (m, s, N, kg)

P.ms = 90;        % sprung mass per corner [kg]
P.mu = 30;        % unsprung mass [kg]

% Wheel-space spring/damper
P.kw = 45e3;      % wheel rate [N/m]
P.cs = 2.0e3;     % damping at wheel [N*s/m] (linearized around mid-speed)

P.kt = 240e3;     % tire vertical stiffness [N/m]

% Simulation settings
P.dt = 1e-3;      % time step [s]
P.T  = 3.0;       % default duration [s]

% Random road / ISO-like settings
P.road.fmin = 0.5;        % min frequency for profile [Hz]
P.road.fmax = 200;        % max frequency for profile [Hz]
P.road.Gd0  = 1e-6;       % ISO 8608 ref PSD @ 1 m^-1 equivalent (tunable)
P.road.n    = 2.0;        % slope exponent (≈ 2 for typical asphalt)
P.road.v_ms = 15.0;       % vehicle speed [m/s] used to map spatial PSD -> time
P.road.seed = 42;         % RNG seed for repeatability

end