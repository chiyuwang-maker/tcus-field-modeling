function P = demo_params(overrides)
%DEMO_PARAMS  Central demo defaults for the synthetic k-Wave pipeline.
%   All geometry is procedural (free / plate / shell). No CT/MRI/DICOM.
%   Nominal acoustic values are literature-order demos, not patient-specific.
%
%   Optional: P = demo_params(struct('scenario','free','f0',300e3));

if nargin < 1 || isempty(overrides)
    overrides = struct();
end

%% Scenario (synthetic only)
% 'free'  — uniform water, no bone
% 'plate' — ~1 cm bone-like slab (defocus demo)
% 'shell' — elliptical ring shell (default)
P.scenario = 'shell';

%% Grid (lightweight 2-D demo)
% Paper-scale reference (NOT used here): ~120 x 120 x 56, dx = 2 mm (3-D).
% This demo keeps a finer 2-D grid so a laptop can finish quickly.
P.Nx = 512;
P.Ny = 464;
P.dx = 0.0004727;   % m (~0.47 mm)
P.dy = P.dx;

%% Source / drive
P.f0 = 300e3;           % Hz (demo; notes also mention 0.3 MHz class)
P.num_cycles = 4;       % tone-burst length (3–5 typical)
P.p0 = 5e5;             % Pa, demo-level amplitude (1e5–1e6)
P.cfl = 0.3;            % used if makeTime path is chosen
P.t_end_cycles = 40;    % simulate ~40 periods (short demo)

%% PML
% Hand off to k-Wave defaults when possible; otherwise explicit size.
P.pml_size = 15;        % cells (10–20); used if DataCast/PML args are set
P.use_explicit_pml = false;

%% Water (shui → water) — k-Wave absorption: alpha_coeff [dB/(MHz^y cm)], alpha_power = y
P.water.sound_speed = 1500;     % m/s
P.water.density     = 1000;     % kg/m^3
P.water.alpha_coeff = 0.0022;   % nominal water-like
P.water.alpha_power = 2.0;

%% Bone-like (lugu → bone) — demo nominals, not a scanned skull
P.bone.sound_speed = 3360;      % m/s, demo order-of-magnitude
P.bone.density     = 1750;      % kg/m^3
P.bone.alpha_coeff = 8.0;       % dB/(MHz^y cm), literature-order demo
P.bone.alpha_power = 1.1;       % bone-like power law (must be non-zero)

%% Plate scenario thickness
P.plate_thickness_m = 0.01;     % ~1 cm
P.plate_offset_frac = 0.35;     % slab center along x (source side → focus demo)

%% Sensor strip (fraction of Ny)
P.sensor_y0_frac = 89 / 464;
P.sensor_y1_frac = (89 + 290) / 464;

%% Arc / bowl aperture (parameterized; replaces fragile overwrite loop)
P.source.arc_cx = 25;           % grid index (x)
P.source.arc_cy = [];           % default: Ny/2
P.source.r_inner = 1;           % makeCircle radius start (cells)
P.source.r_outer = 5;           % inclusive outer radius rings
P.source.theta_span = pi;       % half-circle facing +x (bowl-like)

%% Apply overrides
fn = fieldnames(overrides);
for i = 1:numel(fn)
    P.(fn{i}) = overrides.(fn{i});
end

%% Grid / wavelength sanity comment check (water)
lambda = P.water.sound_speed / P.f0;
P.points_per_wavelength = lambda / P.dx;
if P.points_per_wavelength < 3
    warning('demo_params:ppw', ...
        ['dx may violate < lambda/3 rule of thumb: ppw=%.2f (need >=3). ', ...
         'Raise resolution or lower f0 for a credible demo.'], ...
        P.points_per_wavelength);
end
end
