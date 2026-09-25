# Transcranial Ultrasound Field Modeling

MATLAB + [k-Wave](http://www.k-wave.org/) pipeline for **demonstrating** acoustic-field simulation related to transcranial ultrasound neuromodulation.

| | |
|---|---|
| **Thesis (ZH)** | 《经颅超声神经调控中声场建模仿真研究》 |
| **English title** | Informal translation only (no official English title on the cover): *Acoustic field modeling and simulation for transcranial ultrasound neuromodulation* |
| **Author** | Chiyu Wang (Wang Chiyu), B.Eng. Biomedical Engineering, Xi’an Jiaotong University |
| **School** | School of Life Science and Technology |
| **Advisor** | Siyuan Zhang (*thesis advisor; did not contribute code to this repository*) |
| **Completed** | June 2024 |

This public repository reorganizes simulation scripts that started from an **initial prototype provided by the advisor’s research group**, then refactored by the author into a runnable demo pipeline.

> **Scope of the public code:** synthetic, non-anatomical geometry only (coarse procedural outlines). Imaging used in the thesis manuscript is **not** included and **cannot** be recovered from this repository (destructive de-identification: real volumes, masks, and local paths were removed rather than reversibly masked).

---

## Motivation (thesis, summary)

Focused ultrasound for neuromodulation must cross the skull, which scatters and attenuates the beam and complicates dose / focus prediction. The undergraduate thesis studied bowl-shaped concave transducers in numerical experiments (free field, planar attenuating layer, and transcranial settings in the manuscript) using MATLAB and k-Wave, with a shared workflow: define the grid → assign medium properties (sound speed, density, absorption) → define the source mask and drive signal.

**Public demo vs thesis:** the manuscript discussed image-based skull geometry. This repository **does not** ship those data or that preprocessing path. **Demo parameters may differ from the thesis** — e.g. the thesis transcranial cases used about **300 kHz**, while the public demo currently drives about **0.5 MHz** in `setup_source_sensor.m`. Treat the code as a privacy-safe pipeline sketch, not a figure-for-figure reproduction.

Thesis ABSTRACT keywords (as printed): *Transcranial ultrasonic simulation; Neuroregulation; Sonic field simulation*.

### Thesis outline (high level)

1. Introduction — neuromodulation context, prior work, study design  
2. Focused-transducer field simulation — free field, parameter variants, planar attenuating layer; tools and grid requirements  
3. Transcranial field study — domain / medium / transducer setup and result groups (**imaging steps described in the thesis only; data not in-repo**)  
4. Conclusions and outlook  

**Takeaways (author’s own summary):** larger radius of curvature (same aperture) tended to focus better in the free-field comparisons; a planar attenuating layer blocked and spread energy along the interface; the skull strongly disturbed the free-field focus; transcranial cases were exploratory. The work set up a transcranial simulation workflow but was not intended as a clinical protocol.

Keywords: transcranial ultrasound simulation; neuromodulation; acoustic field modeling

---

## Quick start

**Requirements**

- MATLAB  
- [k-Wave](http://www.k-wave.org/) on the MATLAB path (optional for geometry export only)

```matlab
cd matlab
run_pipeline
```

Without k-Wave, the pipeline still writes synthetic example images under `examples/`.

### Pipeline

```text
make_demo_phantom  →  procedural outline + bone mask
build_medium       →  two-material water / “bone” map
setup_source_sensor → grid, demo source & sensor strip
run_simulation     → k-Wave 2-D (if available)
visualize_results  → figures + examples/
```

---

## Privacy & ethics

This project uses **destructive de-identification** for anything that could point back to real physiological imaging:

- No CT / MRI / DICOM, no subject identifiers, no recoverable skull segmentations  
- Geometry is a **coarse synthetic outline** (e.g. elliptical ring), not an anatomical phantom derived from a scan  
- Local paths and thesis imaging directories are omitted from the public tree  

Do **not** commit real head volumes, clinical exports, full thesis PDFs with embedded scans, or reversible “masked” copies of the same data.

---

## Repository layout

| Path | Role |
|------|------|
| `matlab/run_pipeline.m` | End-to-end entry point |
| `matlab/*.m` | Pipeline steps and legacy redirects |
| `examples/` | Synthetic PNGs / arrays only |
| `notes/` | Non-sensitive parameter notes |

---

## Citation

If you use this demo pipeline, please cite the undergraduate thesis (Chinese title above), author Chiyu Wang, Xi’an Jiaotong University, June 2024. This repository is a **code companion**, not a substitute for the full thesis.

---

## License

No SPDX license file is attached yet. All rights reserved by the author unless a license is added later. Third-party toolboxes (MATLAB, k-Wave) remain under their own terms.

---

## Related

- Do not vendor MATLAB or k-Wave into this repo.  
- Companion student projects on the same account include course algorithm drills and MCU lab notes; this tree is ultrasound-field modeling only.
