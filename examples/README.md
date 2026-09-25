# examples

仅**程序合成**示意资源。公开仓**不含** CT/MRI/DICOM，也**不是**对真实扫描模糊/马赛克后的产物；论文用过的真实影像无法从本目录还原。

| 文件 | 含义 | 是否建议入库 |
|------|------|----------------|
| `demo_phantom.png` | 合成灰度假体 | 是 |
| `demo_bone_mask.png` | 合成 “骨” 掩膜（默认 shell） | 是 |
| `demo_geometry.npz` | 同上数组（Python 可读） | 是 |
| `demo_geometry.mat` | MATLAB 本地缓存 | 否（被 `*.mat` ignore） |

重新生成（无需 MATLAB）：

```bash
python3 scripts/export_demo_geometry.py --scenario shell
```
