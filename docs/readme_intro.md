# Formally Verified Quantum Computing: a catalog of the code

A maintained map of public repositories whose purpose is machine-checked
verification of quantum programs, circuits, protocols, error-correcting codes,
or the mathematics underneath them — with the proof system each is written in,
where it came from, and when it was last touched.

**What this is.** The [Quantum PL & Verification Bibliography](https://quantumpl.github.io/bib/)
maps the *literature* of this field. This catalog is the companion piece: it
maps the *artifacts* — the actual code. Each entry records the repository, the
proof system, what it verifies, the associated paper, the licence, and a
build observation (whether the code built on our machine on a stated date).

**How to read the build column.** `yes` means the project built in the
environment recorded on its page, on the date recorded there. `no` means it did
not build in that environment — which is a statement about our machine on that
day, not a judgment of the project: the most common cause is simply that a
project targets a different prover version than the one we had installed. Where
the logs showed that we never gave a project the environment it declares (an
unsatisfiable dependency solve, a prover generation it predates, a distribution
we could not download), the record says `not-attempted` with the reason, rather
than blaming the project for our setup. Where a project ships its own build
recipe, we use it. Corrections are welcome: if your project builds and we say
otherwise, tell us what we got wrong and we will re-run it and fix the record.

**What this is not.** Not a ranking, not an audit, not an assessment of anyone's
proofs. Descriptions state what a project does, never how good it is. Entries
are sorted by proof system and then alphabetically. A `dormant` or `archived`
status is a fact about commit dates, nothing more; a `builds: no` is a fact
about our machine on the recorded date, nothing more.

**Inclusion criteria.** In scope: any public repository whose purpose is
machine-checked verification of quantum programs, circuits, protocols,
error-correcting codes, or their underlying mathematics, in a proof assistant
(Coq/Rocq, Lean, Isabelle/HOL, Why3, Dafny, F*, …). Foundational libraries
built as quantum substrate are included and tagged `role: library`.
Automated and SMT-backed formal tools appear in their own section.
Out of scope: simulators, SDKs, and compilers with no formal-verification
component. Inactive projects stay listed, marked by status.

**Corrections and additions are welcome** — please open an issue or a PR; an
entry is one small YAML file (see [docs/SCHEMA.md](docs/SCHEMA.md)).
Maintainers: if anything about your project is described inaccurately, tell us
and we will fix it.

**Prior work.** This catalog would be pointless without the surveys that
mapped the field first: the
[Quantum PL & Verification Bibliography](https://quantumpl.github.io/bib/);
Chareton, Bardin, Lee, Valiron, Vilmart, Xu,
*Formal Methods for Quantum Programs: A Survey* ([arXiv:2109.06493](https://arxiv.org/abs/2109.06493));
Lewis, Soudjani, Zuliani,
*Formal Verification of Quantum Programs: Theory, Tools and Challenges*
([arXiv:2110.01320](https://arxiv.org/abs/2110.01320), [DOI:10.1145/3624483](https://doi.org/10.1145/3624483));
and *A Review of Formal Methods in Quantum-Circuit Verification* (Electronics, 2026).
Those map the papers; this maps the code.

This catalog was suggested by [Robert Rand](https://rand.cs.uchicago.edu/)
(University of Chicago), whose feedback also shaped its structure.

Maintained by [Millennium Research](https://millenniumresearch.ai)
(Ibby Mian, Shayaan Siddique). Contact: ibrahimnmian@gmail.com

Mathematical infrastructure whose stated purpose is broader than quantum
(for example the Isabelle entries Complex Bounded Operators and Hilbert Space
Tensor Product) is included only where it is the acknowledged substrate of
cataloged quantum developments, and its entry says so. See
[docs/NOT_INCLUDED.md](docs/NOT_INCLUDED.md) for everything we know about and
deliberately did not list — paper-only tools, out-of-scope software, and
related resources — so that "missing" is distinguishable from "not found".
