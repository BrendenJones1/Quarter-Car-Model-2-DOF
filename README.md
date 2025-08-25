# Quarter-Car 2-DOF MATLAB Repo (FSAE)

This repository contains a clean, modular MATLAB implementation of a **2-DOF quarter-car** model
(sprung mass + unsprung mass) with tools to simulate step bumps, sine sweeps, random roads (ISO 8608-like),
frequency response (Bode), and Pareto sweeps for spring/damper tuning.

## Quick start
1. Open MATLAB and `cd` into `src/`.
2. Run:
   ```matlab
   run_demo
   ```
   This will:
   - Build the state-space model
   - Run a step-bump, sine-sweep, and random road simulation
   - Plot key outputs (accelerations, travel, tire deflection)
   - Perform a basic Bode analysis
   - (Optional) Run a Pareto sweep for spring/damper tuning

## Folder structure
```
src/   % MATLAB source files
data/  % Placeholder for logs/exports
docs/  % PDF/notes (empty placeholder by default)
```

## Model overview
- States: `[z_s, v_s, z_u, v_u]` (sprung/unsprung displacements and velocities)
- Input: road displacement `y_r(t)` (can be step, sine, or random profile)
- Parameters:
  - `m_s` (sprung mass per corner)
  - `m_u` (unsprung mass)
  - `k_w` (wheel rate, spring at wheel)
  - `c_s` (damping at wheel, linearized)
  - `k_t` (tire stiffness)

Equations of motion (upward positive):
```
m_s * z̈_s + c_s (ż_s - ż_u) + k_w (z_s - z_u)              = 0
m_u * z̈_u + c_s (ż_u - ż_s) + k_w (z_u - z_s) + k_t(z_u - y_r) = 0
```

## Requirements
- MATLAB R2018a+ 
- Control System Toolbox (for Bode plots); core simulations use basic ODE/lsim-compatible methods

## Useful entry points
- `run_demo.m` — end-to-end demo
- `quarter_car_params.m` — parameter set (edit here for your car)
- `quarter_car_ss.m` — builds state-space model A,B,C,D given params
- `sim_step_bump.m`, `sim_sine_sweep.m`, `sim_random_road.m` — simulations
- `bode_analysis.m` — frequency response
- `pareto_sweep.m` — quick tuning study for spring/damper

## License
MIT — see `LICENSE`.
