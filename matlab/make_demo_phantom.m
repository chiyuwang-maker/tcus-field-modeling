function [phantom, bone_mask] = make_demo_phantom(Nx, Ny)
%MAKE_DEMO_PHANTOM  Synthetic example image + bone mask (NOT medical imaging).
%   Procedural gray-level phantom: smooth background + elliptical ring.
%   No CT/MRI/DICOM and no anatomical correspondence to any real scan.
%
%   Outputs:
%     phantom   - double image in [0,1] for illustration only
%     bone_mask - binary mask used as acoustic "bone" region in the demo

if nargin < 2
    Nx = 512;
    Ny = 464;
end

[x, y] = ndgrid(linspace(-1, 1, Nx), linspace(-1, 1, Ny));
% soft background texture (deterministic, no external data)
bg = 0.35 + 0.08 * sin(6 * pi * x) .* cos(5 * pi * y);

rx_out = 0.72; ry_out = 0.78;
rx_in  = 0.58; ry_in  = 0.64;
outer = (x ./ rx_out).^2 + (y ./ ry_out).^2 <= 1;
inner = (x ./ rx_in).^2  + (y ./ ry_in).^2  <= 1;
bone_mask = double(outer & ~inner);

% brighten the ring so the PNG looks like a cartoon phantom, not a CT slice
phantom = bg;
phantom(bone_mask > 0) = 0.85 + 0.1 * bg(bone_mask > 0);
phantom = min(max(phantom, 0), 1);
end
