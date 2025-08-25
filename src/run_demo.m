function run_demo()
%RUN_DEMO  End-to-end demo for the quarter-car 2-DOF model.
clc; close all;

P = quarter_car_params();
disp('Parameters:');
disp(P);

% Build model
sys = quarter_car_ss(P);

% --- Step bump ---
h = 0.02; T = 3.0;
out_step = sim_step_bump(sys, P, h, T);
util_plot_step(out_step);

% --- Sine sweep ---
out_sine = sim_sine_sweep(sys, P, 0.005, 0.5, 30, 6.0);
figure('Name','Sine Sweep: Body Accel');
plot(out_sine.t, out_sine.as); xlabel('Time [s]'); ylabel('a_s [m/s^2]'); grid on;

% --- Random road ---
out_rand = sim_random_road(sys, P, 10.0);
fprintf('Random road metrics: a_s_rms=%.3f m/s^2, xtire_rms=%.4f m, xsus_pk=%.4f m\n', ...
    out_rand.metrics.a_s_rms, out_rand.metrics.xtire_rms, out_rand.metrics.xsus_pk);

% --- Bode analysis ---
W = bode_analysis(sys, P, []);
figure('Name','Bode: |a_s / y_r|');
semilogx(W.f, 20*log10(abs(W.G_as_yr))); grid on; xlabel('Frequency [Hz]'); ylabel('Mag [dB]');

figure('Name','Bode: |x_{sus} / y_r|');
semilogx(W.f, 20*log10(abs(W.G_xsus_yr))); grid on; xlabel('Frequency [Hz]'); ylabel('Mag [dB]');

figure('Name','Bode: |F_t / y_r|');
semilogx(W.f, 20*log10(abs(W.G_Ft_yr))); grid on; xlabel('Frequency [Hz]'); ylabel('Mag [dB]');

% --- Optional Pareto sweep (small) ---
doPareto = true;
if doPareto
    R = pareto_sweep(P, [], [], 8.0);
    a = [R.a_s_rms]'; b = [R.xtire_rms]'; zeta = [R.zeta]'; kw = [R.kw]';
    figure('Name','Pareto: Comfort vs Road holding');
    scatter(a, b, 36, zeta, 'filled'); grid on;
    xlabel('Body accel RMS [m/s^2]'); ylabel('Tire deflection RMS [m]');
    cb = colorbar; cb.Label.String = 'Damping ratio \zeta';
    title('Lower-left is better (comfort & grip)');
end

disp('Demo complete.');

end