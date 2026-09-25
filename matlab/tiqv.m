% Legacy visualization fragment. Prefer visualize_results in run_pipeline.
% Example (after a pipeline run that left variables in the workspace):
%   visualize_results(phantom, bone_mask, sensor_data)
if exist('phantom', 'var') && exist('bone_mask', 'var')
    if exist('sensor_data', 'var')
        visualize_results(phantom, bone_mask, sensor_data);
    else
        visualize_results(phantom, bone_mask, []);
    end
else
    warning('No phantom/bone_mask in workspace. Run run_pipeline first.');
end
