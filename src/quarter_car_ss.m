function sys = quarter_car_ss(P)
%QUARTER_CAR_SS  Build state-space system for 2-DOF quarter car.
% States: x = [z_s; v_s; z_u; v_u], Input: y_r (road displacement)
% Output order matches states by default; use C,D to add derived outputs.

ms = P.ms; mu = P.mu; kw = P.kw; cs = P.cs; kt = P.kt;

A = [ 0      1      0             0;
     -kw/ms -cs/ms  kw/ms         cs/ms;
      0      0      0             1;
      kw/mu  cs/mu -(kw+kt)/mu   -cs/mu ];

B = [0; 0; 0; kt/mu];

C = eye(4);
D = zeros(4,1);

sys = ss(A,B,C,D);
end