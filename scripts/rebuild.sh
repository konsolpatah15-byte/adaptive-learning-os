#!/bin/bash
# ALOS 2.0 — quick rebuild (Rust only, no frontend)
set -euo pipefail
cd "$(dirname "$0")/.."

echo "=== ALOS 2.0 Rebuild ==="
cargo build --release
echo "Binary: $(ls -lh target/release/alos-api | awk '{print $5}')"

# Restart if service is running
if systemctl is-active --quiet alos-api 2>/dev/null; then
    sudo systemctl restart alos-api
    echo "Service restarted"
fi

sleep 1
curl -s http://127.0.0.1:8000/health
echo ""