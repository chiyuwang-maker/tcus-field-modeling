function sensor_data = run_simulation(kgrid, medium, source, sensor, P)
%RUN_SIMULATION  Call k-Wave 2-D solver (requires k-Wave on the MATLAB path).
%   PML: use k-Wave defaults unless P.use_explicit_pml is true.

if nargin < 5 || isempty(P)
    P = demo_params();
end

input_args = {};
if isfield(P, 'use_explicit_pml') && P.use_explicit_pml
    input_args = {'PMLSize', P.pml_size, 'PMLInside', false};
end

if isempty(input_args)
    sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor);
else
    sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor, input_args{:});
end
end
