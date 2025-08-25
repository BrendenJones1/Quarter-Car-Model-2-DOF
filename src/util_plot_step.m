function util_plot_step(out)
%UTIL_PLOT_STEP  Plot helper for step bump results.
t = out.t;
figure('Name','Step Bump: Displacements'); 
plot(t, out.zs, 'DisplayName','z_s'); hold on;
plot(t, out.zu, 'DisplayName','z_u');
xlabel('Time [s]'); ylabel('Displacement [m]'); grid on; legend;

figure('Name','Step Bump: Suspension Travel');
plot(t, out.xsus); xlabel('Time [s]'); ylabel('z_s - z_u [m]'); grid on;

figure('Name','Step Bump: Body Accel');
plot(t, out.as); xlabel('Time [s]'); ylabel('a_s [m/s^2]'); grid on;

figure('Name','Step Bump: Tire Deflection & Force');
yyaxis left; plot(t, out.xtire, 'DisplayName','x_{tire}'); ylabel('Deflection [m]');
yyaxis right; plot(t, out.Ft, 'DisplayName','F_t'); ylabel('Force [N]');
xlabel('Time [s]'); grid on;
end