function sensor_data = run_simulation(kgrid, medium, source, sensor)
%RUN_SIMULATION  Call k-Wave 2-D solver (requires k-Wave on the MATLAB path).

sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor);
end
