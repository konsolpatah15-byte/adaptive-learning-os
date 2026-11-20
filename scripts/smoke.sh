#!/usr/bin/env bash
# Smoke-test the live ALOS backend end to end.
set -euo pipefail
cd "$(dirname "$0")/.."
PW=$(cat database/.bootstrap_password)
TOKEN=*** -s -X POST http://127.0.0.1:8000/api/auth/login \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"learner\",\"password\":\"$PW\"}" | jq -r .access_token)
echo "== login OK =="
curl -s http://127.0.0.1:8000/api/dashboard -H "Authorization: Bearer $TOKEN" \
  | jq '{overall_mastery, goals: [.goals[].title], weakest: [.weakest_competencies[:3][] | {code, mastery}], unresolved_mistakes}'
echo "== generate 7-day plan =="
curl -s -X POST "http://127.0.0.1:8000/api/schedule/generate?days=7" -H "Authorization: Bearer $TOKEN" | jq '.created | length'
echo "== learner says: aku masih bingung =="
curl -s "http://127.0.0.1:8000/api/learning/next-lesson?say=aku%20masih%20bingung" -H "Authorization: Bearer $TOKEN" \
  | jq '{intent, action, assessment_allowed, competency, strategy_label_id}'
echo "== SNBT official info status =="
curl -s http://127.0.0.1:8000/api/snbt/subtests -H "Authorization: Bearer $TOKEN" | jq '.official_info.status'