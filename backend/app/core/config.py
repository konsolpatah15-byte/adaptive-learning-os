"""ALOS core: config, paths, tiny YAML loader."""
from __future__ import annotations
import os
from pathlib import Path
from functools import lru_cache
import yaml

ROOT = Path(__file__).resolve().parents[3]          # adaptive-learning-os/
CONFIG_DIR = ROOT / "config"


@lru_cache(maxsize=8)
def load_config(name: str) -> dict:
    with open(CONFIG_DIR / f"{name}.yaml", encoding="utf-8") as f:
        return yaml.safe_load(f)


def system() -> dict:
    return load_config("system")


def db_path() -> Path:
    p = ROOT / system()["database"]["path"]
    p.parent.mkdir(parents=True, exist_ok=True)
    return p


def secret_key() -> str:
    """JWT signing key from env; generated once and persisted outside git."""
    key = os.environ.get("ALOS_SECRET_KEY")
    if key:
        return key
    key_file = ROOT / "database" / ".secret_key"
    if key_file.exists():
        return key_file.read_text().strip()
    import secrets
    key = secrets.token_hex(32)
    key_file.write_text(key)
    key_file.chmod(0o600)
    return key