# kwave-transcranial-sim

本科毕设相关的 **k-Wave / MATLAB** 经颅超声声场仿真，已整理成一条可运行**流程**。  
声场步骤保留毕设脚本思路；**几何改为与原始 CT/MRI 完全无关的合成示例影像**。

## 流程

```text
make_demo_phantom     合成示例图 + bone mask（非医学影像）
        ↓
build_medium          两相介质（水 / “骨”）
        ↓
setup_source_sensor   网格、0.5 MHz 源、传感器条带
        ↓
run_simulation        k-Wave 2D（需工具箱）
        ↓
visualize_results     出图；并写入 examples/*.png
```

入口（在 MATLAB 中）：

```matlab
cd matlab
run_pipeline
```

无 k-Wave 时仍会导出合成 phantom / mask 图片。

## 隐私

- 不含 CT/MRI/DICOM，不含真实颅骨分割。
- 原始毕设影像获取渠道无法由作者确认，故已移除几何提取草稿与真实几何依赖。
- `examples/demo_phantom.png` 为程序生成的示意假体，**与任何临床扫描无对应关系**。

## 目录

| 路径 | 作用 |
|------|------|
| `matlab/run_pipeline.m` | 总入口 |
| `matlab/make_demo_phantom.m` 等 | 流程各步 |
| `matlab/source_2.m` 等 | 旧文件名薄封装，指向新流程 |
| `examples/` | 合成 PNG / npz |
| `notes/` | 换能器参数片段、路径说明 |

## 依赖

- MATLAB
- [k-Wave](http://www.k-wave.org/)（仅仿真步需要）

## 不要提交

口令、DICOM、真实头颅/颅骨掩膜、论文 PPT、MATLAB 安装树、k-Wave 手册。
