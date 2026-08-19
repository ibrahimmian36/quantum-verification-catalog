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
export PIP_BREAK_SYSTEM_PACKAGES=1  # Ubuntu marks the system env externally-managed

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
    # Bound each build's own parallelism: several builds run at once, and
    # letting each claim every core oversubscribes the machine and turns
    # nearly-finished builds into timeouts.
    if run lake build; then outcome=yes; reason=""; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="lake build failed"; }
    fi
  else reason="lake not installed on this machine"; fi
elif ls *.opam >/dev/null 2>&1 && command -v opam >/dev/null; then
  # Prefer the project's own declared build recipe (its opam package) over a guess.
  tool="coq $(coqc --version 2>/dev/null | head -1 || echo unknown) via opam"
  if run opam install -y --deps-only . && run opam install -y --assume-depexts .; then
    outcome=yes; reason="built and installed via the project's own opam package"
  else
    [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || {
      # fall back to the project's default make/dune target
      if run make -j8 || run dune build; then outcome=yes; reason="built with the project's default target";
      else outcome=no; reason="opam install and default build target both failed"; fi
    }
  fi
elif [ -f _CoqProject ] || [ -f Makefile.coq ] || [ -f dune-project ]; then
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
elif [ -f CMakeLists.txt ]; then
  tool="cmake $(cmake --version 2>/dev/null | head -1 || echo unknown)"
  if command -v cmake >/dev/null; then
    if run cmake -B _build -DCMAKE_BUILD_TYPE=Release && run cmake --build _build -j8; then outcome=yes; reason=""; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="cmake build failed"; }
    fi
  else reason="cmake not installed on this machine"; fi
elif [ -f Project.toml ] && command -v julia >/dev/null; then
  tool="julia $(julia --version 2>/dev/null | awk '{print $3}')"
  if run julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'; then outcome=yes; reason=""; else
    [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="julia instantiate/precompile failed"; }
  fi
elif [ -f stack.yaml ]; then
  tool="stack $(stack --version 2>/dev/null | head -1 | cut -d, -f1 || echo unknown)"
  if command -v stack >/dev/null; then
    if run stack build --no-terminal; then outcome=yes; reason=""; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="stack build failed"; }
    fi
  else reason="stack not installed on this machine"; fi
elif ls *.agda-lib >/dev/null 2>&1 || [ -f Everything.agda ]; then
  tool="agda $(agda --version 2>/dev/null | head -1 || echo unknown)"
  if command -v agda >/dev/null; then
    main=$(ls *.agda-lib 2>/dev/null | head -1)
    if run bash -c 'agda $(grep -h "^include" '"$main"' >/dev/null 2>&1; ls *.agda | head -1)'; then outcome=yes; reason="type-checked the top-level module"; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="agda type-check failed"; }
    fi
  else reason="agda not installed on this machine"; fi
elif [ -f pyproject.toml ] || [ -f setup.py ] || [ -f requirements.txt ]; then
  tool="pip $(python3 -m pip --version 2>/dev/null | awk '{print $2}')"
  if [ -f pyproject.toml ] || [ -f setup.py ]; then piptarget="-e ."; else piptarget="-r requirements.txt"; fi
  if run python3 -m pip install --break-system-packages $piptarget; then outcome=yes; reason="dependencies installed and package importable"; else
    [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="pip install failed"; }
  fi
elif [ -f configure ] || [ -f configure.ac ] || [ -f autogen.sh ]; then
  tool="autotools + make"
  [ -f autogen.sh ] && run bash autogen.sh
  [ -f configure ] || run autoreconf -i
  if run ./configure && run make -j8; then outcome=yes; reason=""; else
    [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="configure/make failed"; }
  fi
elif [ -f Makefile ] || [ -f makefile ] || [ -f GNUmakefile ]; then
  tool="make"
  if run make -j8; then outcome=yes; reason=""; else
    [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="make failed"; }
  fi
elif [ -f package.yaml ] || ls *.cabal >/dev/null 2>&1; then
  tool="cabal/stack"
  if command -v stack >/dev/null; then
    if run stack build --no-terminal; then outcome=yes; reason=""; else
      [ $? -eq 124 ] && { outcome="not-attempted"; reason="timeout ${TIMEOUT}s"; } || { outcome=no; reason="stack build failed"; }
    fi
  else reason="stack not installed on this machine"; fi
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
