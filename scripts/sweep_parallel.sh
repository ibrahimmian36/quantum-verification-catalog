#!/usr/bin/env bash
# Parallel build sweep: N entries at a time, each time-capped, cleanup per entry.
# Usage: scripts/sweep_parallel.sh [system-substring] [timeout-per-entry] [jobs]
# e.g.:  scripts/sweep_parallel.sh ""     1800 10   (everything, 10-wide)
#        scripts/sweep_parallel.sh Coq    3600 8
# Entries with builds already recorded (yes/no) are skipped. Safe to re-run.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILTER="${1:-}"
TIMEOUT="${2:-1800}"
JOBS="${3:-8}"
export ROOT TIMEOUT
list=$(mktemp)
for f in "$ROOT"/data/entries/*.yaml; do
  slug=$(basename "$f" .yaml)
  sys=$(grep '^system:' "$f" | cut -d: -f2-)
  builds=$(grep '^builds:' "$f" | awk '{print $2}' | tr -d "'\"")
  case "$builds" in yes|no) continue;; esac
  if [ -n "$FILTER" ] && ! echo "$sys" | grep -qi "$FILTER"; then continue; fi
  grep -q 'repo_url: https://github.com' "$f" || continue
  echo "$slug" >> "$list"
done
n=$(wc -l < "$list" | tr -d ' ')
echo "sweeping $n entries, $JOBS at a time, ${TIMEOUT}s cap each"
xargs -P "$JOBS" -I{} bash -c '
  bash "$ROOT/scripts/build_sweep.sh" "{}" "$TIMEOUT" >/dev/null 2>&1
  rm -rf "$ROOT/build-work/{}"
  grep -H "^builds:" "$ROOT/data/entries/{}.yaml"
' < "$list"
rm -f "$list"
echo "done; outcomes:"
grep -c "^builds: .yes.$" "$ROOT"/data/entries/*.yaml 2>/dev/null | grep -c ':1$' || true
