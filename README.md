# 经颅超声声场建模

经颅超声神经调控相关的声场仿真代码（**k-Wave / MATLAB**）。

对应本科毕业设计课题《经颅超声神经调控中声场建模仿真研究》（西安交通大学 · 生物医学工程）。  
完成时间：**2024 年 6 月**（定稿）。

**指导教师：** 张思远（未直接参与本仓库开发）。  
**代码来源：** 基于导师课题组提供的初版仿真脚本，由作者整理、重构并扩展为本仓库中的可运行流程。

公开版本将几何改为与原始 CT/MRI **完全无关**的合成示例影像；声场仿真步骤仍保留毕设脚本思路。

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

## 隐私与去标识（强制）

本仓库要求**完全不含**真实生理影像与可识别隐私：

- 无 CT / MRI / DICOM，无真实颅骨或头部分割，无受试者/患者相关数据。
- 几何仅为程序生成的**大致轮廓**（椭圆环示意），不可还原为任何真实扫描。
- 已大面积去隐私：真实影像依赖、几何提取草稿、本机影像路径均不进入公开仓。
- `examples/` 下 PNG / npz 均为合成示例，**与任何临床或实验影像无对应关系**。

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
