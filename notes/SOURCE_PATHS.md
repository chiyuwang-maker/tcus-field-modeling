# 源位置说明

公开仓**不收录**本机绝对路径、学号、原始毕设影像目录，或任何可指向真实生理影像的位置。

几何一律由 `matlab/make_demo_phantom.m`（或 `scripts/export_demo_geometry.py`）程序生成：

- `free` / `plate` / `shell` 三种**合成**场景
- 仅为大致轮廓，用于演示声学流程

**毁信息型去隐私：** 真实 CT/MRI/DICOM 与可识别中间数组已从公开路径剔除，而非可逆模糊。本仓无法还原论文阶段用过的真实扫描。
