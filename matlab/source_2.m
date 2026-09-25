% Legacy snippet: grid + kWaveArray mask (see setup_source_sensor / run_pipeline).
% Prefer: run_pipeline
kgrid = makeGrid(512, 0.0004727, 464, 0.0004727);
karray = kWaveArray('BLITolerance', 0.01, 'UpsamplingRate', 10);
unk = karray.getArrayBinaryMask(kgrid);
