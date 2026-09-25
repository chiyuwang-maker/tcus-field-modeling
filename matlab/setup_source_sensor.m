function [kgrid, source, sensor] = setup_source_sensor()
%SETUP_SOURCE_SENSOR  Grid, 0.5 MHz tone burst source, and sensor strip.
%   Logic follows the undergraduate demo scripts (names kept close to originals).

Nx = 512; dx = 0.0004727;
Ny = 464; dy = 0.0004727;
kgrid = makeGrid(Nx, dx, Ny, dy);

dt = 1 / (5e5) / 20;
kgrid.t_array = 0:dt:360*dt;

% 0.5 MHz tone, 20 cycles, phase step pi/10 (as in original notes)
n = 1:1:20*18;
signal_array = cos(pi/10 * n);

% annular-sector like mask built from makeCircle differences (original style)
p_source = [];
for i = 1:5
    p_source = makeCircle(50, Ny, 25, 232, i, 2*pi) - makeCircle(50, Ny, 25, 232, i, pi);
end
source.p_mask = [p_source; ones(Nx - 50, Ny)];
source.p = signal_array;

sensor.mask = [zeros(Nx, 89), ones(Nx, 290), zeros(Nx, 65)];
sensor.record = {'p'};
end
