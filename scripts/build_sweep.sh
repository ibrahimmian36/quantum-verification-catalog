#!/usr/bin/env bash
# Attempt to build one catalog entry with the toolchain it declares.
# Usage: scripts/build_sweep.sh <slug> [timeout-seconds]
# Records: outcome (yes|no|not-attempted) + date into the entry YAML via
# scripts/record_build.py, and a full log under build-logs/<slug>.log.
#
# A failed build is a factual observation about THIS machine on THIS date.
# Timeouts are recorded as not-attempted with a reason, never as failures.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SLUG="${1:?usage: build_sweep.sh <slug> [timeout]}"
TIMEOUT="${2:-1800}"
ENTRY="$ROOT/data/entries/$SLUG.yaml"
WORK="$ROOT/build-work/$SLUG"
LOG="$ROOT/build-logs/$SLUG.log"
mkdir -p "$ROOT/build-work" "$ROOT/build-logs"

url=$(grep '^repo_url:' "$ENTRY" | sed 's/repo_url: *//')
[ -z "$url" ] && { echo "no repo_url"; exit 1; }

echo "== $SLUG == $url ==" | tee "$LOG"
date -u +"%Y-%m-%dT%H:%M:%SZ" | tee -a "$LOG"

rm -rf "$WORK"
if ! git clone --depth 1 --recurse-submodules "$url" "$WORK" >>"$LOG" 2>&1; then
  "${PYTHON:-python3}" "$ROOT/scripts/record_build.py" "$SLUG" not-attempted "clone failed"
  exit 0
fi
cd "$WORK"
# build files may live one level down (monorepo layout)
if [ ! -f lakefile.lean ] && [ ! -f lakefile.toml ] && [ ! -f _CoqProject ] && [ ! -f dune-project ] && [ ! -f Makefile ] && [ ! -f ROOT ]; then
  sub=$(find . -maxdepth 2 \( -name lakefile.lean -o -name lakefile.toml -o -name _CoqProject -o -name dune-project -o -name ROOT \) 2>/dev/null | head -1)
  [ -n "$sub" ] && cd "$(dirname "$sub")" && echo "descended into $(pwd)" >>"$LOG"
fi

outcome="not-attempted"; reason="no recognized build system"; tool=""
run() { timeout "$TIMEOUT" "$@" >>"$LOG" 2>&1; }

if [ -f lakefile.lean ] || [ -f lakefile.toml ]; then
  tool="lean $(cat lean-toolchain 2>/dev/null || echo unknown)"
  if command -v lake >/dev/null; then
    if run lake exe cache get; then :; fi
    if run lake build; then outcome=yes; reason=""; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="lake build failed"; }
    fi
  else reason="lake not installed on this machine"; fi
elif [ -f _CoqProject ] || ls *.opam >/dev/null 2>&1 || [ -f Makefile.coq ] || [ -f dune-project ]; then
  tool="coq $(coqc --version 2>/dev/null | head -1 || echo unknown)"
  if command -v coqc >/dev/null || command -v dune >/dev/null; then
    if [ -f dune-project ] && command -v dune >/dev/null; then cmd="dune build";
    elif [ -f Makefile ]; then cmd="make -j4";
    elif [ -f _CoqProject ]; then run coq_makefile -f _CoqProject -o Makefile.coq && cmd="make -f Makefile.coq -j4";
    fi
    if [ -n "${cmd:-}" ]; then
      if run $cmd; then outcome=yes; reason=""; else
        [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="build failed, see log"; }
      fi
    else reason="no usable Makefile/_CoqProject route"; fi
  else reason="coq/dune not installed on this machine"; fi
elif [ -f ROOT ] || [ -f ROOTS ]; then
  tool="isabelle $(isabelle version 2>/dev/null || echo unknown)"
  if command -v isabelle >/dev/null; then
    if run isabelle build -D .; then outcome=yes; reason=""; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="isabelle build failed"; }
    fi
  else reason="isabelle not installed on this machine"; fi
fi

echo "OUTCOME=$outcome REASON=$reason TOOLCHAIN=$tool" | tee -a "$LOG"
"${PYTHON:-python3}" "$ROOT/scripts/record_build.py" "$SLUG" "$outcome" "$reason" "$tool"
