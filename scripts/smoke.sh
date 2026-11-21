#!/usr/bin/env bash
# Smoke-test the live ALOS backend end to end.
set -euo pipefail
cd "$(dirname "$0")/.."
PW=$(cat database/.bootstrap_password)
TOKEN=*** -s -X POST http://127.0.0.1:8000/api/auth/login \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"learner\",\"password\":\"$PW\"}" | jq -r .access_token)
if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then echo "LOGIN FAILED"; exit 1; fi
echo "== login OK =="
curl -s http://127.0.0.1:8000/api/dashboard -H "Authorization: Bearer $TOKEN" \
  | jq '{overall_mastery, goals: [.goals[].title], weakest: [.weakest_competencies[:3][] | {code, mastery}], unresolved_mistakes}'
echo "== IELTS progress (provisional estimates + disclaimer) =="
curl -s http://127.0.0.1:8000/api/ielts/progress -H "Authorization: Bearer $TOKEN" | jq '{estimates: (.band_estimates_provisional | length), disclaimer}'
echo "== SNBT subtests =="
curl -s http://127.0.0.1:8000/api/snbt/subtests | jq '{count: (.subtests | length), active: [.subtests[] | select(.active) | .code]}'
echo "== recommendations =="
curl -s http://127.0.0.1:8000/api/learning/recommendations -H "Authorization: Bearer $TOKEN" | jq '{policy, plan_items: (.plan | length)}'
echo "== analytics weaknesses =="
curl -s http://127.0.0.1:8000/api/analytics/weaknesses -H "Authorization: Bearer $TOKEN" | jq '{weakest: (.weakest | length), error_patterns}'
echo "== unauthorized blocked =="
CODE=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8000/api/dashboard)
[ "$CODE" = "401" ] && echo "401 OK" || { echo "EXPECTED 401 GOT $CODE"; exit 1; }
echo "== ALL SMOKE TESTS PASSED =="