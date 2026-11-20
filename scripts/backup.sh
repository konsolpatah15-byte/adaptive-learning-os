#!/bin/bash
# ALOS 2.0 — database backup
set -euo pipefail
cd "$(dirname "$0")/.."

BACKUP_DIR="database/backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/alos_backup_$TIMESTAMP.db"

cp database/alos.db "$BACKUP_FILE"
echo "Backup: $BACKUP_FILE ($(ls -lh "$BACKUP_FILE" | awk '{print $5}'))"

# Keep last 14 days
find "$BACKUP_DIR" -name "alos_backup_*.db" -mtime +14 -delete