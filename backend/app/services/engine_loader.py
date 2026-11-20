"""Engine loader — import learning-engine modules (hyphenated dir) once."""
from __future__ import annotations
import importlib.util
import sys
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ENGINE_DIR = ROOT / "learning-engine"


@lru_cache(maxsize=16)
def engine(name: str):
    key = f"alos_engine_{name}"
    if key in sys.modules:
        return sys.modules[key]
    spec = importlib.util.spec_from_file_location(key, ENGINE_DIR / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[key] = mod
    spec.loader.exec_module(mod)
    return mod


def orchestrator():
    return engine("orchestrator")