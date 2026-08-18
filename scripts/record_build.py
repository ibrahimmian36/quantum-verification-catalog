#!/usr/bin/env python3
"""Record a build outcome into an entry YAML. Usage:
   record_build.py <slug> <yes|no|not-attempted> [reason] [toolchain]"""
import datetime
import pathlib
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent
slug, outcome = sys.argv[1], sys.argv[2]
reason = sys.argv[3] if len(sys.argv) > 3 else ""
tool = sys.argv[4] if len(sys.argv) > 4 else ""
p = ROOT / "data" / "entries" / f"{slug}.yaml"
e = yaml.safe_load(p.read_text())
e["builds"] = outcome
e["build_date"] = datetime.date.today().isoformat()
if tool:
    e["toolchain"] = tool
if reason:
    e["build_note"] = reason
p.write_text(yaml.dump(e, sort_keys=False, allow_unicode=True, width=100))
print(f"{slug}: builds={outcome} ({reason or 'ok'})")
