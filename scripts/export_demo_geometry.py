#!/usr/bin/env python3
"""Regenerate synthetic demo geometry (PNG + NPZ). No CT/MRI/DICOM.

Mirrors matlab/make_demo_phantom.m so examples/ stay reproducible without MATLAB.
Real thesis imaging is not used and cannot be restored from these outputs
(destructive privacy: public path has no reversible clinical intermediates).
"""
from __future__ import annotations

import argparse
import struct
import zlib
from pathlib import Path

import numpy as np


def make_demo_phantom(
    nx: int = 512,
    ny: int = 464,
    scenario: str = "shell",
    dx: float = 0.0004727,
    plate_thickness_m: float = 0.01,
    plate_offset_frac: float = 0.35,
):
    scenario = scenario.strip().lower()
    x = np.linspace(-1.0, 1.0, nx)[:, None]
    y = np.linspace(-1.0, 1.0, ny)[None, :]
    bg = 0.35 + 0.08 * np.sin(6 * np.pi * x) * np.cos(5 * np.pi * y)

    if scenario == "free":
        bone_mask = np.zeros((nx, ny), dtype=np.float64)
    elif scenario == "plate":
        n_thick = max(1, int(round(plate_thickness_m / dx)))
        ix0 = max(0, int(round(plate_offset_frac * nx) - n_thick // 2))
        ix1 = min(nx, ix0 + n_thick)
        bone_mask = np.zeros((nx, ny), dtype=np.float64)
        bone_mask[ix0:ix1, :] = 1.0
    elif scenario == "shell":
        rx_out, ry_out = 0.72, 0.78
        rx_in, ry_in = 0.58, 0.64
        outer = (x / rx_out) ** 2 + (y / ry_out) ** 2 <= 1.0
        inner = (x / rx_in) ** 2 + (y / ry_in) ** 2 <= 1.0
        bone_mask = (outer & ~inner).astype(np.float64)
    else:
        raise ValueError(f"Unknown scenario {scenario!r}; use free|plate|shell")

    phantom = bg.copy()
    phantom[bone_mask > 0] = 0.85 + 0.1 * bg[bone_mask > 0]
    phantom = np.clip(phantom, 0.0, 1.0)
    return phantom, bone_mask


def _png_chunk(tag: bytes, data: bytes) -> bytes:
    return (
        struct.pack(">I", len(data))
        + tag
        + data
        + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
    )


def write_png_gray(path: Path, arr: np.ndarray) -> None:
    """Write 8-bit grayscale PNG using stdlib only (no Pillow)."""
    u8 = (np.clip(arr, 0.0, 1.0) * 255.0 + 0.5).astype(np.uint8)
    h, w = u8.shape
    raw = b"".join(b"\x00" + u8[i, :].tobytes() for i in range(h))
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 0, 0, 0, 0)
    png = (
        b"\x89PNG\r\n\x1a\n"
        + _png_chunk(b"IHDR", ihdr)
        + _png_chunk(b"IDAT", zlib.compress(raw, 9))
        + _png_chunk(b"IEND", b"")
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--scenario", default="shell", choices=("free", "plate", "shell"))
    ap.add_argument("--nx", type=int, default=512)
    ap.add_argument("--ny", type=int, default=464)
    ap.add_argument("--out-dir", type=Path, default=None)
    args = ap.parse_args()

    root = Path(__file__).resolve().parents[1]
    out_dir = args.out_dir or (root / "examples")
    out_dir.mkdir(parents=True, exist_ok=True)

    phantom, bone_mask = make_demo_phantom(args.nx, args.ny, args.scenario)
    write_png_gray(out_dir / "demo_phantom.png", phantom)
    write_png_gray(out_dir / "demo_bone_mask.png", bone_mask)
    np.savez_compressed(
        out_dir / "demo_geometry.npz",
        phantom=phantom,
        bone_mask=bone_mask,
        scenario=np.array(args.scenario),
    )
    print(
        f"Wrote {out_dir}/demo_phantom.png, demo_bone_mask.png, demo_geometry.npz "
        f"(scenario={args.scenario})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
