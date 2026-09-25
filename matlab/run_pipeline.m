%RUN_PIPELINE  End-to-end demo for kwave-transcranial-sim (synthetic geometry only).
%
% Flow:
%   1) make synthetic phantom + bone mask  (no CT/MRI)
%   2) build acoustic medium from the mask
%   3) setup grid / source / sensor
%   4) run k-Wave (optional if toolbox missing — still exports example PNGs)
%   5) visualize
%
% Usage (MATLAB, repo root or matlab/ on path):
%   >> cd matlab
%   >> run_pipeline

clear; close all;

here = fileparts(mfilename('fullpath'));
addpath(here);
out_dir = fullfile(fileparts(here), 'examples');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end

%% Step 1 — synthetic example image (NOT from thesis imaging)
[phantom, bone_mask] = make_demo_phantom(512, 464);
imwrite(phantom, fullfile(out_dir, 'demo_phantom.png'));
imwrite(bone_mask, fullfile(out_dir, 'demo_bone_mask.png'));
save(fullfile(out_dir, 'demo_geometry.mat'), 'phantom', 'bone_mask');

%% Step 2 — medium
medium = build_medium(bone_mask);

%% Step 3 — source / sensor
has_kwave = (exist('makeGrid', 'file') == 2) || (exist('kWaveGrid', 'file') == 2);
sensor_data = [];
if has_kwave
    [kgrid, source, sensor] = setup_source_sensor();
    %% Step 4 — simulate
    try
        sensor_data = run_simulation(kgrid, medium, source, sensor);
    catch ME
        warning('k-Wave run failed (%s). Pipeline still keeps geometry demos.', ME.message);
    end
else
    warning('k-Wave not on path; exporting synthetic geometry only.');
end

%% Step 5 — visualize
visualize_results(phantom, bone_mask, sensor_data);

fprintf('Pipeline done. Example images in: %s\n', out_dir);
