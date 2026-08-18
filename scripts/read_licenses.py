#!/usr/bin/env python3
"""Read each GitHub entry's LICENSE file via /repos/{slug}/license (the API
serves the actual license file with its detected SPDX id) and record it with
the read date. 404 => 'no LICENSE file found (checked <date>)'."""
import datetime
import json
import pathlib
import re
import subprocess

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent
today = datetime.date.today().isoformat()

for p in sorted((ROOT / "data" / "entries").glob("*.yaml")):
    e = yaml.safe_load(p.read_text())
    m = re.match(r"https?://github\.com/([^/]+/[^/#?]+)", e.get("repo_url", ""))
    if not m:
        continue
    slug = m.group(1)
    r = subprocess.run(["gh", "api", f"/repos/{slug}/license"],
                       capture_output=True, text=True)
    if r.returncode != 0:
        e["licence"] = f"no LICENSE file found (checked {today})"
    else:
        d = json.loads(r.stdout)
        spdx = (d.get("license") or {}).get("spdx_id")
        name = d.get("name", "LICENSE")
        if spdx and spdx != "NOASSERTION":
            e["licence"] = f"{spdx} (LICENSE file read {today})"
        else:
            e["licence"] = f"nonstandard licence in {name} (read {today}; see file)"
    p.write_text(yaml.dump(e, sort_keys=False, allow_unicode=True, width=100))
    print(f"{p.stem}: {e['licence']}")
