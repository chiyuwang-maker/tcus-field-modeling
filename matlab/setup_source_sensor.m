function [kgrid, source, sensor] = setup_source_sensor(P)
%SETUP_SOURCE_SENSOR  Grid, parameterized tone-burst arc source, sensor strip.
%   Prefers kWaveGrid + setTime/makeTime; falls back to makeGrid.
%   Source mask accumulates annular-sector rings (bowl/arc aperture) —
%   the old loop overwrote p_source each iteration; that bug is fixed here.

if nargin < 1 || isempty(P)
    P = demo_params();
end

Nx = P.Nx; Ny = P.Ny; dx = P.dx; dy = P.dy;
f0 = P.f0;
c0 = P.water.sound_speed;

%% Grid API: kWaveGrid preferred, else makeGrid
if exist('kWaveGrid', 'class') == 8 || exist('kWaveGrid', 'file') == 2
    kgrid = kWaveGrid(Nx, dx, Ny, dy);
elseif exist('makeGrid', 'file') == 2
    kgrid = makeGrid(Nx, dx, Ny, dy);
else
    error('setup_source_sensor:noGrid', ...
        'Neither kWaveGrid nor makeGrid found. Add k-Wave to the MATLAB path.');
end

%% Time array via setTime / makeTime (avoid hand-written fragile t_array)
dt_pref = 1 / (f0 * 20);   % ~20 samples per period
t_end = P.t_end_cycles / f0;
Nt = max(2, round(t_end / dt_pref));
used_api = false;
% Object API (kWaveGrid): prefer makeTime, then setTime
if ~isstruct(kgrid)
    if ismethod(kgrid, 'makeTime')
        try
            kgrid.makeTime(c0, P.cfl, t_end);
            used_api = true;
        catch
        end
    end
    if ~used_api && ismethod(kgrid, 'setTime')
        kgrid.setTime(Nt, dt_pref);
        used_api = true;
    end
end
if ~used_api
    kgrid.t_array = (0:Nt-1) * dt_pref;
end

%% Tone burst (3–5 cycles typical); prefer toneBurst if present
n_cycles = P.num_cycles;
if exist('toneBurst', 'file') == 2
    % sample at grid dt when available
    fs = 1 / dt_pref;
    try
        if ~isempty(kgrid.dt) && kgrid.dt > 0
            fs = 1 / kgrid.dt;
        end
    catch
        if isfield(kgrid, 't_array') && numel(kgrid.t_array) > 1
            fs = 1 / (kgrid.t_array(2) - kgrid.t_array(1));
        end
    end
    signal_array = P.p0 * toneBurst(fs, f0, n_cycles);
else
    dt = dt_pref;
    try
        if ~isempty(kgrid.dt) && kgrid.dt > 0
            dt = kgrid.dt;
        end
    catch
    end
    t = 0:dt:(n_cycles / f0);
    signal_array = P.p0 * sin(2 * pi * f0 * t);
    % simple raised-cosine envelope
    env = 0.5 - 0.5 * cos(2 * pi * (0:numel(t)-1) / max(numel(t)-1, 1));
    signal_array = signal_array .* env;
end

%% Accumulating arc / annular-sector aperture (parameterized bowl-like)
arc_cx = P.source.arc_cx;
if isempty(P.source.arc_cy)
    arc_cy = round(Ny / 2);
else
    arc_cy = P.source.arc_cy;
end
r0 = P.source.r_inner;
r1 = P.source.r_outer;
theta_span = P.source.theta_span;

p_source = zeros(50, Ny);   % aperture lives in first 50 rows (legacy layout)
if exist('makeCircle', 'file') == 2
    for r = r0:r1
        % full ring minus opposite semicircle → accumulate sector rings
        ring = makeCircle(50, Ny, arc_cx, arc_cy, r, 2*pi) ...
             - makeCircle(50, Ny, arc_cx, arc_cy, r, theta_span);
        p_source = p_source + double(ring ~= 0);
    end
    p_source = double(p_source > 0);
else
    % geometric fallback (no makeCircle): discrete arc voxels
    [yy, xx] = meshgrid(1:Ny, 1:50);
    rr = sqrt((xx - arc_cx).^2 + (yy - arc_cy).^2);
    ang = atan2(yy - arc_cy, xx - arc_cx);
    % face +x hemisphere roughly within theta_span/2 of 0
    in_arc = (rr >= r0) & (rr <= r1) & (abs(ang) <= theta_span / 2);
    p_source = double(in_arc);
end

source.p_mask = [p_source; zeros(Nx - 50, Ny)];
source.p = signal_array;

%% Sensor strip
y0 = max(1, round(P.sensor_y0_frac * Ny));
y1 = min(Ny, round(P.sensor_y1_frac * Ny));
sensor.mask = zeros(Nx, Ny);
sensor.mask(:, y0:y1) = 1;
sensor.record = {'p'};
end
