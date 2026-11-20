#!/bin/bash
# ALOS 2.0 — build & deploy script
set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== ALOS 2.0 Build & Deploy ==="

# 1. Build Rust backend
echo "[1/4] Building Rust backend (release)..."
cargo build --release
echo "  Binary: $(ls -lh target/release/alos-api | awk '{print $5}')"

# 2. Build Next.js frontend
echo "[2/4] Building Next.js frontend..."
cd apps/web
npm install --silent
npm run build
cd ../..
echo "  Frontend built"

# 3. Install systemd service (optional, requires sudo)
echo "[3/4] Installing systemd service..."
if [ -f /etc/systemd/system/alos-api.service ]; then
    sudo systemctl stop alos-api || true
fi
sudo cp scripts/alos-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable alos-api
sudo systemctl start alos-api
echo "  Service installed and started"

# 4. Verify
echo "[4/4] Verifying..."
sleep 2
HEALTH=$(curl -s http://127.0.0.1:8000/health)
echo "  Health: $HEALTH"

echo "=== Deploy complete ==="