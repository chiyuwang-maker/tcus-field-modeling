# Demo pipeline changelog (synthetic, privacy-safe)

## 2026-09-25 — reproducible synthetic demo

- Fixed `setup_source_sensor` p_source overwrite bug; arc rings now accumulate; source parameterized via `demo_params`.
- Prefer `kWaveGrid` + `setTime`/`makeTime`; fall back to `makeGrid`.
- Added `demo_params.m`: f0=300 kHz, water/bone nominals with non-zero `alpha_power`, tone-burst 4 cycles, PML default/optional 15.
- Scenarios: `free` | `plate` | `shell` (default shell) in `run_pipeline` / `make_demo_phantom`.
- Renamed medium identifiers `shui`/`lugu` → `water`/`bone` (pinyin kept only in comments).
- Export: PNG + NPZ for repo; MAT local and gitignored.
- `source_2.m` is a legacy stub that errors to `run_pipeline`.
- No real imaging paths; examples regenerated from procedural code only.
