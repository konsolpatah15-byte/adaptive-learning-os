#!/usr/bin/env python3
"""Apply generated curriculum content SQL files to the ALOS database."""

import sqlite3
import sys
import os
from pathlib import Path

DB_PATH = Path(__file__).parent.parent / "database" / "alos.db"

def apply_sql(sql_path: str) -> tuple[int, int]:
    """Apply a content SQL migration. Returns (topics_added, errors)."""
    conn = sqlite3.connect(str(DB_PATH))
    conn.execute("PRAGMA foreign_keys = ON")
    
    with open(sql_path) as f:
        sql = f.read()
    
    statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]
    added = 0
    errors = 0
    
    for stmt in statements:
        try:
            conn.execute(stmt)
            added += 1
        except sqlite3.Error as e:
            print(f"  ERROR: {e}")
            print(f"  Statement: {stmt[:120]}...")
            errors += 1
    
    conn.commit()
    conn.close()
    return added, errors

def verify_counts():
    """Show topic counts per competency."""
    conn = sqlite3.connect(str(DB_PATH))
    rows = conn.execute("""
        SELECT c.code, c.name, COUNT(ct.id) as topic_count
        FROM competencies c
        LEFT JOIN curriculum_topics ct ON ct.competency_id = c.id
        GROUP BY c.id
        ORDER BY topic_count DESC, c.code
    """).fetchall()
    conn.close()
    
    for code, name, count in rows:
        bar = "█" * min(count, 20)
        print(f"  {code:30s} {name:40s} {count:3d} topics {bar}")

if __name__ == "__main__":
    content_dir = Path(__file__).parent
    sql_files = sorted(content_dir.glob("*.sql"))
    
    if not sql_files:
        print("No SQL files found in content_gen/")
        sys.exit(1)
    
    print("=" * 70)
    print("ALOS Curriculum Content Loader")
    print(f"Database: {DB_PATH}")
    print(f"SQL files: {len(sql_files)}")
    print("=" * 70)
    
    total_added = 0
    total_errors = 0
    
    for sql_file in sql_files:
        print(f"\nApplying: {sql_file.name} ...")
        added, errors = apply_sql(str(sql_file))
        print(f"  Added: {added}, Errors: {errors}")
        total_added += added
        total_errors += errors
    
    print("\n" + "=" * 70)
    print(f"TOTAL: {total_added} topics added, {total_errors} errors")
    print("=" * 70)
    
    print("\nTopic counts per competency:")
    verify_counts()