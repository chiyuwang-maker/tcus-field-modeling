#!/usr/bin/env python3
"""Lightweight static checks for matlab/*.m (no MATLAB required)."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MATLAB = ROOT / "matlab"

REQUIRED = [
    "demo_params.m",
    "make_demo_phantom.m",
    "build_medium.m",
    "setup_source_sensor.m",
    "run_pipeline.m",
    "run_simulation.m",
    "visualize_results.m",
    "source_2.m",
]

BANNED = [
    re.compile(r"/home/\w+", re.I),
    re.compile(r"/Users/\w+"),
    re.compile(r"学号"),
    re.compile(r"\bDICOM\b.*load", re.I),
    re.compile(r"imread\s*\(.*\.(dcm|nii)", re.I),
]


def main() -> int:
    errors = []
    for name in REQUIRED:
        p = MATLAB / name
        if not p.exists():
            errors.append(f"missing {p}")
            continue
        text = p.read_text(encoding="utf-8", errors="replace")
        if name == "setup_source_sensor.m":
            if "p_source = p_source +" not in text and "p_source = p_source +" not in text:
                # accept either accumulation or geometric fallback assigning once after loop
                if "for r = r0:r1" not in text and "for i = 1:5" in text:
                    errors.append("setup_source_sensor.m still has overwrite-style for i=1:5")
            if re.search(r"for i\s*=\s*1:5\s*\n\s*p_source\s*=\s*makeCircle", text):
                errors.append("p_source overwrite bug still present")
        if name == "build_medium.m":
            # allow pinyin对照 in comments; ban identifiers in executable code only
            code_lines = []
            for ln in text.splitlines():
                s = ln.strip()
                if not s or s.startswith("%"):
                    continue
                code_lines.append(re.sub(r"%.*$", "", ln))
            joined = "\n".join(code_lines)
            if re.search(r"\bshui\b", joined) or re.search(r"\blugu\b", joined):
                errors.append("build_medium.m still uses shui/lugu identifiers in code")
            if "alpha_power" not in text:
                errors.append("build_medium.m missing alpha_power")
        if name == "source_2.m":
            if "makeGrid" in text and not text.strip().startswith("%"):
                # executable makeGrid leftover
                code = "\n".join(
                    ln for ln in text.splitlines()
                    if ln.strip() and not ln.strip().startswith("%")
                )
                if "makeGrid" in code or "kWaveArray" in code:
                    errors.append("source_2.m still has executable half-config code")
        for pat in BANNED:
            if pat.search(text):
                errors.append(f"{name} matches banned pattern {pat.pattern}")

    # privacy: examples only synthetic keys
    npz = ROOT / "examples" / "demo_geometry.npz"
    if npz.exists():
        import numpy as np

        z = np.load(npz, allow_pickle=False)
        keys = set(z.files)
        if not {"phantom", "bone_mask"}.issubset(keys):
            errors.append(f"npz missing expected keys: {keys}")

    if errors:
        print("FAIL:")
        for e in errors:
            print(" -", e)
        return 1
    print("OK: static checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
