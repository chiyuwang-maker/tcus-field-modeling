# Transcranial Ultrasound Field Modeling

MATLAB + [k-Wave](http://www.k-wave.org/) **demo pipeline** for acoustic-field simulation related to transcranial ultrasound neuromodulation.

| | |
|---|---|
| **Thesis (ZH)** | 《经颅超声神经调控中声场建模仿真研究》 |
| **English title** | Informal translation only (no official English title on the cover): *Acoustic field modeling and simulation for transcranial ultrasound neuromodulation* |
| **Author** | Chiyu Wang, B.Eng. Biomedical Engineering, Xi’an Jiaotong University |
| **School** | School of Life Science and Technology |
| **Advisor** | Siyuan Zhang (*thesis advisor; did not contribute code to this repository*) |
| **Completed** | June 2024 |

Public code reorganizes scripts that began as an **initial prototype from the advisor’s research group**, then refactored by the author into a runnable, privacy-safe demo.

> **Destructive de-identification:** only procedural, non-anatomical outlines ship here. Thesis imaging, skull segmentations, and local paths are **removed**, not reversibly masked, and **cannot** be recovered from this repository.

---

## Motivation (thesis, summary)

Focused ultrasound for neuromodulation must cross the skull. The undergraduate thesis studied bowl-shaped concave transducers numerically (free field, planar attenuating layer, and transcranial settings in the manuscript) with MATLAB and k-Wave: define the grid → medium properties → source mask and drive signal.

**Public demo vs thesis:** the manuscript discussed image-based skull geometry; that data is **not** in this repo. Demo parameters live in `matlab/demo_params.m` (default **f0 = 300 kHz**, same order of magnitude as the thesis).

Thesis ABSTRACT keywords (as printed): *Transcranial ultrasonic simulation; Neuroregulation; Sonic field simulation*.

### Schematic resolution (the “pixel” contract)

Think of this repository as a **transit-map**, not a satellite photograph.

The thesis ran a heavier, image-informed numerical study. The public tree deliberately keeps a **coarse 2-D pixel grid** and a few procedural silhouettes (`free` / `plate` / `shell`). That is not a failed downscale of the dissertation figures — it is the product boundary:

- **One voxel, one claim.** A cell means “water-like” or “bone-like,” never “this patient’s skull.”
- **Readable on a laptop.** The grid is sized so the *workflow* (params → medium → source → solve → plot) stays inspectable in one sitting.
- **Privacy by coarseness.** Once geometry is only a handful of schematic pixels, there is nothing left to invert back into a scan — the compromise *is* the safeguard.

So when you see blocky rings and strips in `examples/`, read them as **icons of the pipeline**, not as low-quality CT. Fidelity here is fidelity to *steps*, not to anatomy.

### Thesis outline (high level)

1. Introduction  
2. Focused-transducer field simulation (free field, variants, planar layer)  
3. Transcranial study (manuscript only for imaging steps; **no in-repo data**)  
4. Conclusions and outlook  

---

## Quick start

**Requirements:** MATLAB; [k-Wave](http://www.k-wave.org/) on the path (optional if you only need geometry export).

```matlab
cd matlab
% In run_pipeline.m set:  scenario = 'shell' | 'free' | 'plate'
run_pipeline
```

Without k-Wave, synthetic PNGs are still written under `examples/`. Without MATLAB:

```bash
python3 scripts/export_demo_geometry.py --scenario shell
python3 scripts/check_matlab_static.py
```

### Pipeline

```text
demo_params          → central demo defaults / scenario
make_demo_phantom    → procedural free | plate | shell outline
build_medium         → water / bone-like map
setup_source_sensor  → grid (kWaveGrid or makeGrid), arc source, sensor
run_simulation       → k-Wave 2-D (if available)
visualize_results    → figures; examples/*.png (+ npz via Python helper)
```

Committed examples: `demo_*.png` and `demo_geometry.npz`. Local `*.mat` dumps are gitignored.

---

## Privacy & ethics

- No CT / MRI / DICOM, no subject IDs, no recoverable anatomical masks  
- Geometry is a **coarse synthetic outline** only  
- Do not commit blurred real volumes, thesis PDFs with embedded scans, or absolute imaging paths  

---

## Repository layout

| Path | Role |
|------|------|
| `matlab/run_pipeline.m` | Entry point |
| `matlab/demo_params.m` | Parameters |
| `matlab/*.m` | Pipeline steps / legacy redirects |
| `scripts/` | Geometry export + static checks (Python) |
| `examples/` | Synthetic artifacts only |
| `notes/` | Non-sensitive notes / changelog |

---

## Limitations

- Schematic 2-D grid by design (see **Schematic resolution** above); not a figure-for-figure thesis reproduction  
- Arc / sector source is parameterized, not a full bowl `kWaveArray`  
- k-Wave execution depends on your local toolbox install  

---

## Citation

Cite the undergraduate thesis (Chinese title above), Chiyu Wang, Xi’an Jiaotong University, June 2024. This repository is a **code companion**, not a substitute for the full thesis.

## License

No SPDX license file yet. Rights remain with the author unless a license is added later. MATLAB and k-Wave remain under their own terms.
