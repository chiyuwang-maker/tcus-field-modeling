function [phantom, bone_mask] = make_demo_phantom(Nx, Ny, scenario)
%MAKE_DEMO_PHANTOM  Synthetic example image + bone mask (NOT medical imaging).
%   Procedural gray-level phantom only. No CT/MRI/DICOM, no real anatomy,
%   and nothing derived from thesis imaging (destructive privacy: real data
%   paths are removed, not blurred).
%
%   scenario: 'free' | 'plate' | 'shell'  (default 'shell')
%
%   Outputs:
%     phantom   - double image in [0,1] for illustration only
%     bone_mask - binary mask used as acoustic "bone" region in the demo

if nargin < 1 || isempty(Nx), Nx = 512; end
if nargin < 2 || isempty(Ny), Ny = 464; end
if nargin < 3 || isempty(scenario), scenario = 'shell'; end

scenario = lower(strtrim(scenario));

[x, y] = ndgrid(linspace(-1, 1, Nx), linspace(-1, 1, Ny));
% soft background texture (deterministic, no external data)
bg = 0.35 + 0.08 * sin(6 * pi * x) .* cos(5 * pi * y);

switch scenario
    case 'free'
        bone_mask = zeros(Nx, Ny);

    case 'plate'
        % ~1 cm bone-like slab; thickness from demo_params when available
        thickness_m = 0.01;
        dx = 0.0004727;
        offset_frac = 0.35;
        try
            P = demo_params();
            thickness_m = P.plate_thickness_m;
            dx = P.dx;
            offset_frac = P.plate_offset_frac;
        catch
        end
        n_thick = max(1, round(thickness_m / dx));
        ix0 = max(1, round(offset_frac * Nx) - floor(n_thick / 2));
        ix1 = min(Nx, ix0 + n_thick - 1);
        bone_mask = zeros(Nx, Ny);
        bone_mask(ix0:ix1, :) = 1;

    case 'shell'
        % elliptical ring (cartoon outline — not a skull segmentation)
        rx_out = 0.72; ry_out = 0.78;
        rx_in  = 0.58; ry_in  = 0.64;
        outer = (x ./ rx_out).^2 + (y ./ ry_out).^2 <= 1;
        inner = (x ./ rx_in).^2  + (y ./ ry_in).^2  <= 1;
        bone_mask = double(outer & ~inner);

    otherwise
        error('make_demo_phantom:badScenario', ...
            'Unknown scenario ''%s''. Use free | plate | shell.', scenario);
end

bone_mask = double(bone_mask > 0);

% brighten bone region so PNG looks like a cartoon phantom, not a CT slice
phantom = bg;
phantom(bone_mask > 0) = 0.85 + 0.1 * bg(bone_mask > 0);
phantom = min(max(phantom, 0), 1);
end
