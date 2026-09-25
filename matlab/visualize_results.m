function visualize_results(phantom, bone_mask, sensor_data)
%VISUALIZE_RESULTS  Show demo phantom / mask; plot pressure if available.
%   Figures are for the synthetic demo only — not clinical imaging.

figure('Name', 'demo phantom (not medical imaging)');
imagesc(phantom); axis image; colormap(gray); colorbar;
title('Synthetic example phantom (unrelated to any clinical scan)');

figure('Name', 'demo bone mask');
imagesc(bone_mask); axis image; colormap(gray); colorbar;
title('Synthetic bone mask used as acoustic heterogeneity');

if nargin >= 3 && ~isempty(sensor_data)
    if isstruct(sensor_data) && isfield(sensor_data, 'p')
        p = sensor_data.p;
    else
        p = sensor_data;
    end
    figure('Name', 'sensor pressure (demo)');
    imagesc(abs(p)); axis image; colorbar;
    title('Recorded pressure magnitude (demo run)');
end
end
