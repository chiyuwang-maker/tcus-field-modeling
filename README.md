# kwave-transcranial-sim

本科毕设相关的 **k-Wave / MATLAB** 经颅超声声场仿真脚本整理稿（可入库最小化树）。

原题方向：经颅超声神经调控中的声场建模仿真（西安交通大学生物医学工程本科毕业设计）。

## 内容

| 路径 | 说明 |
|------|------|
| `matlab/source_2.m` | 网格与 `kWaveArray` 掩膜 |
| `matlab/stimulation_1.m` | 2D `kspaceFirstOrder2D` 主仿真（介质/源/传感器） |
| `matlab/tiqv.m` | 结果场可视化片段 |
| `matlab/jihe_gu_draft.m` | 颅骨几何阈值草稿（未整理，仅备份） |
| `notes/transducer_A_params_snippet.txt` | 「精准聚焦 / 换能器A」参数草稿片段 |

## 运行前提

1. 已安装 MATLAB，并将 [k-Wave](http://www.k-wave.org/) 工具箱加入 path。
2. `stimulation_1.m` 依赖颅骨几何变量 `v`（脚本内注释指向毕设资料中的颅骨几何数据）；本仓库**不包含** DICOM / 体数据。
3. 细网格全颅仿真可能受内存限制，历史上多用简化模型。

## 明确排除（勿再拷入本仓）

- 阿里云等明文口令文件
- CT/MRI DICOM 与大型几何数据包
- 论文 Word/PDF、答辩 PPT、结果大图 zip
- MATLAB 安装树、k-Wave 官方手册 PDF（第三方版权）

## 已知问题（保持原稿，入库时未强行改逻辑）

- `stimulation_1.m` 中存在拼写不一致：`soure` / `senor` 等，需在可运行整理时统一。
- `medium.density` 一行对颅骨分支疑似误用 `shui_density`，跑通前应核对。
- `tiqv.m` 依赖工作区中的 `stimulation` / `lou` 变量。

## 来源路径（本机）

- 仿真脚本：`D:\毕业设计\毕业设计资料\仿真文件\`
- 参数片段：`D:\毕业设计\毕业设计资料\精准聚焦\换能器A\参数.txt`
- 归档副本（电脑总管）：`D:\重要文档归档_20260925\03_毕设\`