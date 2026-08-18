#!/usr/bin/env python3
"""Refresh GitHub-derived fields (stars, last_commit, licence-from-API fallback,
archived, status) for every entry in data/entries/. Only touches refreshable
fields; everything else is left as the curator wrote it.

Usage: python3 scripts/fetch_github.py [slug ...]
Requires: PyYAML; `gh` CLI authenticated (or GITHUB_TOKEN in CI).
"""
import datetime
import json
import pathlib
import re
import subprocess
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent
ENTRIES = ROOT / "data" / "entries"
DORMANT_DAYS = int(18 * 30.44)  # 18 months

def gh_api(path):
    r = subprocess.run(["gh", "api", path], capture_output=True, text=True)
    if r.returncode != 0:
        return None
    return json.loads(r.stdout)

def repo_slug(url):
    m = re.match(r"https?://github\.com/([^/]+/[^/#?]+)", url or "")
    return m.group(1).removesuffix(".git") if m else None

def refresh(path):
    entry = yaml.safe_load(path.read_text())
    slug = repo_slug(entry.get("repo_url", ""))
    if not slug:
        print(f"  {path.name}: not a GitHub URL, skipped")
        return
    data = gh_api(f"/repos/{slug}")
    if data is None:
        print(f"  {path.name}: API fetch FAILED — left unchanged")
        return
    entry["stars"] = data.get("stargazers_count")
    pushed = data.get("pushed_at") or ""
    entry["last_commit"] = pushed[:10] or "unknown"
    lic = (data.get("license") or {}).get("spdx_id")
    if entry.get("licence") in (None, "unknown") and lic and lic != "NOASSERTION":
        entry["licence"] = f"{lic} (from API; LICENSE file not yet read)"
    if data.get("archived"):
        entry["status"] = "archived"
    elif pushed:
        age = (datetime.datetime.now(datetime.timezone.utc)
               - datetime.datetime.fromisoformat(pushed.replace("Z", "+00:00"))).days
        entry["status"] = "dormant" if age > DORMANT_DAYS else "active"
    path.write_text(yaml.dump(entry, sort_keys=False, allow_unicode=True,
                              width=100, default_flow_style=False))
    print(f"  {path.name}: stars={entry['stars']} last_commit={entry['last_commit']} status={entry['status']}")

def main():
    names = sys.argv[1:]
    paths = sorted(ENTRIES.glob("*.yaml"))
    if names:
        paths = [p for p in paths if p.stem in names]
    for p in paths:
        refresh(p)

if __name__ == "__main__":
    main()
