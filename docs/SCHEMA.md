# Entry schema

One YAML record per repository in `data/entries/<slug>.yaml`. Every field is
verified from the source (repository, LICENSE file, paper, GitHub API) — never
from memory. `unknown` is the required fallback for anything unverified.

```yaml
name:         # canonical tool/library name
repo_url:     # public repository URL
system:       # Coq/Rocq | Lean 4 | Isabelle/HOL | Why3 | Dafny | F* | other (state which)
role:         # verifier | library | language | compiler | model-checker
verifies:     # list drawn from: circuits, program semantics, compiler passes,
              # error correction, protocols, mathematics
description:  # one sentence, plain, factual, no adjectives of praise
paper:        # title + arXiv id or DOI, or `none` / `unknown`
authors:      # people or group, from the repo/paper
licence:      # from the LICENSE file itself, not a README badge
stars:        # integer, from GitHub API (refreshed by CI)
last_commit:  # ISO date, from GitHub API (refreshed by CI)
status:       # active | dormant | archived  (dormant = no commit in 18 months)
builds:       # yes | no | not-attempted
build_date:   # ISO date the build was attempted on our machine, or null
toolchain:    # exact version used if a build was attempted
source:       # where this entry was discovered (survey arXiv id, quantumpl-bib,
              # afp, github-org-sweep, github-search, venue name, seed-list)
automated:    # true if SMT/model-checking rather than an interactive proof assistant
notes:        # factual only; e.g. "superseded by SQIR"
```

Two hard rules: `description` is what the thing does, never how good it is.
`builds` records what happened on our machine on `build_date`; the date is part
of the record, and a failed build is a factual observation about our machine on
that date, not a judgment of the project.
