#!/usr/bin/env bash
# Run the build sweep over every entry (or those matching a system filter).
# Usage: scripts/sweep_all.sh [system-substring] [timeout-per-entry]
# e.g.:  scripts/sweep_all.sh "Lean" 1800
# Skips entries whose builds field is already recorded (yes/no); reruns only
# not-attempted. Records land in the entry YAML; logs in build-logs/.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILTER="${1:-}"
TIMEOUT="${2:-1800}"
for f in "$ROOT"/data/entries/*.yaml; do
  slug=$(basename "$f" .yaml)
  sys=$(grep '^system:' "$f" | cut -d: -f2-)
  builds=$(grep '^builds:' "$f" | awk '{print $2}' | tr -d "'\"")
  case "$builds" in yes|no) echo "skip $slug (recorded: $builds)"; continue;; esac
  if [ -n "$FILTER" ] && ! echo "$sys" | grep -qi "$FILTER"; then continue; fi
  grep -q 'repo_url: https://github.com' "$f" || { echo "skip $slug (not GitHub)"; continue; }
  echo ">>> $slug"
  bash "$ROOT/scripts/build_sweep.sh" "$slug" "$TIMEOUT"
  rm -rf "$ROOT/build-work/$slug"
done
