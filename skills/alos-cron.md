# ALOS Daily Maintenance Cron Job
# Runs on Hermes cron — executes daily backup, review queue refresh, weekly digest

## Daily (runs at 02:00 Asia/Jakarta)
```bash
#!/bin/bash
# Daily ALOS maintenance
ALOS_DIR="/data/workspace/adaptive-learning-os"
cd "$ALOS_DIR"

# 1. Backup SQLite database
cp database/alos.db "database/backups/alos_$(date +%Y%m%d).db"
# Keep last 14 days
find database/backups -name "alos_*.db" -mtime +14 -delete
echo "[$(date)] Backup complete: $(ls -lh database/backups/alos_$(date +%Y%m%d).db | awk '{print $5}')"

# 2. Refresh review queue
curl -s http://127.0.0.1:8000/health > /dev/null
echo "[$(date)] Review queue refresh triggered via health check"

# 3. Log system event
echo "[$(date)] Daily maintenance complete"
```

## Weekly (runs every Monday at 08:00 Asia/Jakarta)
```bash
#!/bin/bash
# Weekly progress digest
ALOS_DIR="/data/workspace/adaptive-learning-os"
cd "$ALOS_DIR"

# Count sessions this week
SESSIONS=$(sqlite3 database/alos.db "SELECT COUNT(*) FROM learning_sessions WHERE started_at >= date('now','-7 days');")
REVIEWS_DONE=$(sqlite3 database/alos.db "SELECT COUNT(*) FROM review_queue WHERE status='done' AND created_at >= date('now','-7 days');")
MISTAKES_RESOLVED=$(sqlite3 database/alos.db "SELECT COUNT(*) FROM mistake_bank WHERE resolved=1 AND resolved_at >= date('now','-7 days');")

echo "=== ALOS Weekly Digest $(date +%Y-%m-%d) ==="
echo "Sessions this week: $SESSIONS"
echo "Reviews completed: $REVIEWS_DONE"
echo "Mistakes resolved: $MISTAKES_RESOLVED"
echo "==========================================="
```