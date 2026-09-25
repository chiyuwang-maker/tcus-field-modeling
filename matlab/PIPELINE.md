# MATLAB 流程步骤

公开仓为**合成演示管道**：不含且**无法还原**论文用过的真实生理影像（毁信息型去隐私，非可逆马赛克）。

| 顺序 | 函数文件 | 作用 |
|------|----------|------|
| 0 | `demo_params.m` | 集中演示参数（频率、介质、网格、场景） |
| 1 | `make_demo_phantom.m` | 合成大致轮廓 + bone mask（`free` / `plate` / `shell`） |
| 2 | `build_medium.m` | water / bone 两相声速·密度·吸收（`alpha_power` 非零） |
| 3 | `setup_source_sensor.m` | `kWaveGrid`（回退 `makeGrid`）、扇环累积声源、传感器 |
| 4 | `run_simulation.m` | k-Wave 2D（可选） |
| 5 | `visualize_results.m` | 显示 phantom / mask / 声压 |

入口：`run_pipeline.m`

## 切换三场景

在 `run_pipeline.m` 顶部修改：

```matlab
scenario = 'shell';   % 'free' | 'plate' | 'shell'
```

| 场景 | 含义 |
|------|------|
| `free` | 均匀水，无骨 |
| `plate` | 约 1 cm 厚骨样平板（按 `dx` 换算层厚） |
| `shell` | 椭圆环壳（默认） |

参数默认值见 `demo_params.m`（`f0=300e3`，水 c=1500/ρ=1000，骨样演示标称 c≈3360/ρ≈1750，tone burst 约 4 cycle）。

## 导出

- 始终写 `examples/demo_*.png`
- 本地写 `examples/demo_geometry.mat`（`*.mat` 被 `.gitignore` 忽略）
- 若本机有 Python：调用 `scripts/export_demo_geometry.py` 写 `demo_geometry.npz`（可入库）

无 k-Wave 时仍导出合成轮廓图。
