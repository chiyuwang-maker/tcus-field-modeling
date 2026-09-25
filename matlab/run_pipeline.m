%RUN_PIPELINE  End-to-end synthetic demo (privacy-safe; no CT/MRI/DICOM).
%
% Flow:
%   1) make synthetic phantom + bone mask  (scenario: free|plate|shell)
%   2) build acoustic medium from the mask
%   3) setup grid / source / sensor
%   4) run k-Wave (optional if toolbox missing — still exports example PNGs)
%   5) visualize + write examples/ (png always; mat local; npz via Python helper)
%
% Switch scenario (edit here or pass via demo_params override):
%   scenario = 'shell';   % 'free' | 'plate' | 'shell'
%
% Usage:
%   >> cd matlab
%   >> run_pipeline

clear; close all;

here = fileparts(mfilename('fullpath'));
addpath(here);
out_dir = fullfile(fileparts(here), 'examples');
if ~exist(out_dir, 'dir'); mkdir(out_dir); end

%% --- scenario switch (synthetic only) ---
scenario = 'shell';   % change to 'free' or 'plate' as needed
P = demo_params(struct('scenario', scenario));

%% Step 1 — synthetic geometry (NOT from thesis imaging; not restorable)
[phantom, bone_mask] = make_demo_phantom(P.Nx, P.Ny, P.scenario);
imwrite(phantom, fullfile(out_dir, 'demo_phantom.png'));
imwrite(bone_mask, fullfile(out_dir, 'demo_bone_mask.png'));
% .mat is for local MATLAB reloads; *.mat is gitignored — do not rely on git for it
save(fullfile(out_dir, 'demo_geometry.mat'), 'phantom', 'bone_mask', 'P');

% Prefer committed format: npz (written by Python helper when available)
py_helper = fullfile(fileparts(here), 'scripts', 'export_demo_geometry.py');
if exist(py_helper, 'file') == 2
    try
        cmd = sprintf('python3 "%s" --scenario %s --out-dir "%s"', ...
            py_helper, P.scenario, out_dir);
        [status, cmdout] = system(cmd);
        if status ~= 0
            warning('npz export via Python failed (%d): %s', status, strtrim(cmdout));
        end
    catch ME
        warning('npz export skipped: %s', ME.message);
    end
end

%% Step 2 — medium
medium = build_medium(bone_mask, P);

%% Step 3 — source / sensor
has_kwave = (exist('makeGrid', 'file') == 2) || (exist('kWaveGrid', 'file') == 2) ...
    || (exist('kWaveGrid', 'class') == 8);
sensor_data = [];
if has_kwave
    [kgrid, source, sensor] = setup_source_sensor(P);
    %% Step 4 — simulate
    try
        sensor_data = run_simulation(kgrid, medium, source, sensor, P);
    catch ME
        warning('k-Wave run failed (%s). Pipeline still keeps geometry demos.', ME.message);
    end
else
    warning('k-Wave not on path; exporting synthetic geometry only.');
end

%% Step 5 — visualize
visualize_results(phantom, bone_mask, sensor_data);

fprintf('Pipeline done. scenario=%s. Example images in: %s\n', P.scenario, out_dir);
fprintf('Committed artifacts: demo_*.png + demo_geometry.npz (mat is local / gitignored).\n');
