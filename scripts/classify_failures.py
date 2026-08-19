#!/usr/bin/env python3
"""Reclassify build failures whose logs show an environment mismatch rather
than a defect in the project.

A `builds: no` should mean "this project did not build in the stated
environment". It should NOT be used when the log shows that we never gave the
project the environment it asks for — an unsatisfiable dependency solve, or a
prover generation it predates. Those become `not-attempted` with the reason
stated, because that is the honest description of what happened.

Usage: python3 scripts/classify_failures.py [--apply]
"""
import pathlib
import re
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent
LOGS = ROOT / "build-logs"
APPLY = "--apply" in sys.argv

# (regex over log text, new build_note). Order matters; first match wins.
SIGNALS = [
    (r"No solution found|Package conflict|Sorry, no solution found",
     "declared dependencies could not be resolved in this environment"),
    (r"was not found in the current environment|Unknown interpretation for notation|"
     r"The reference \S+ was not found",
     "appears to target a different prover version than the one used here"),
    (r"Error when parsing \.vo|compiled with a different version|"
     r"was compiled with an incompatible version",
     "repository artifacts were compiled with a different prover version"),
    (r"Unbound module|Cannot find a physical path bound to logical path",
     "a declared dependency was not available in this environment"),
    (r"error: externally-managed-environment|No matching distribution found",
     "dependency installation was blocked in this environment"),
    (r"failed to fetch GitHub release|external command 'tar' exited|"
     r"curl: \(\d+\)|Could not resolve host|Connection timed out",
     "a dependency download failed from this machine"),
    (r"unknown short option|unknown long option|unexpected argument",
     "the build invocation used an option this toolchain does not accept"),
    (r"CMake Error.{0,400}?find_package|Boost not found|"
     r"Could NOT find|No package '[^']+' found",
     "a required library was not installed in this environment"),
    (r"make: \S+: No such file or directory|"
     r"(?:^|\n)\S+: command not found|/bin/sh: \d+: \S+: not found",
     "a required build tool was not installed in this environment"),
    (r"/Applications/|C:\\\\|/Users/[^/]+/",
     "the repository's build files refer to a path specific to another machine"),
    (r"invalid subtyping in definition|ERROR: LoadError: .*Julia",
     "the language runtime version in this environment differs from the one expected"),
    (r"could not find a package configuration file|collect2: error: ld returned|"
     r"cannot find -l\w+|undefined reference to",
     "a required library was not available when linking in this environment"),
    (r"pip-build-env|subprocess-exited-with-error.{0,200}?setuptools|"
     r"error: metadata-generation-failed",
     "the Python build environment here could not satisfy the project's build requirements"),
    (r"aclocal|autoreconf: not found|automake.*not found",
     "the autotools files the build expects were not present in this environment"),
]

changed = 0
for p in sorted((ROOT / "data" / "entries").glob("*.yaml")):
    e = yaml.safe_load(p.read_text())
    if e.get("builds") != "no":
        continue
    log = LOGS / f"{p.stem}.log"
    if not log.exists():
        continue
    text = " ".join(log.read_text(errors="replace").split())
    for pattern, reason in SIGNALS:
        if re.search(pattern, text, re.I):
            print(f"{p.stem}: no -> not-attempted ({reason})")
            if APPLY:
                e["builds"] = "not-attempted"
                e["build_note"] = reason
                p.write_text(yaml.dump(e, sort_keys=False, allow_unicode=True, width=100))
            changed += 1
            break
print(f"{changed} reclassified" + ("" if APPLY else " (dry run; pass --apply)"))
