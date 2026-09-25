# MATLAB 流程步骤

| 顺序 | 函数文件 | 作用 |
|------|----------|------|
| 1 | `make_demo_phantom.m` | 生成与医学影像无关的合成示例图 + bone mask |
| 2 | `build_medium.m` | 由 mask 映射声速/密度/衰减 |
| 3 | `setup_source_sensor.m` | 网格、0.5 MHz 声源、传感器 |
| 4 | `run_simulation.m` | 调用 k-Wave 2D 求解 |
| 5 | `visualize_results.m` | 显示 phantom / mask / 声压 |

入口：`run_pipeline.m`
