# Known but not cataloged

Recorded so that "missing" is distinguishable from "not found". Last checked
2026-08-18; corrections welcome — if a public artifact exists for any of
these, please open an issue.

## Paper exists, no public artifact located
- **CertiQ** (arXiv:1908.08963) — Qiskit compiler verification; successor
  Giallar is released and cataloged.
- **QSolver** (arXiv:2602.20171); **QMC**, the quantum model checker (CAV 2008);
  **QECV** (arXiv:2111.13728); **Quantum Abstract Interpretation** (PLDI 2021;
  artifact on the ACM DL only); the **concurrent-protocol equivalence checker**
  of Ardeshir-Larijani, Gay, and Nagarajan (DOI 10.1145/3231597);
  **Formalization of Quantum Protocols using Coq** (Boender, Kammueller,
  Nagarajan, arXiv:1511.01568); **DDMF / XQDD** (IEICE 2008); the
  **verified OpenQASM-SQIR translation** abstract (PLanQC 2020, functionality
  later within SQIR/VOQC).
- Recent papers without located artifacts: **RapunSL** (quantum separation
  logic, POPL 2026, arXiv:2511.23472); **Formal Verification of Quantum
  Ancilla Safety** (CAV 2026, arXiv:2608.13099); **A Practical Specification
  Language for Automatic Quantum Program Verification** (CAV 2026,
  arXiv:2605.05786); **Verification of Recursively Defined Quantum Circuits**
  (PLDI 2026, DOI 10.1145/3808273); **Scalable Equivalence Checking of Shallow
  Quantum Circuits** (OOPSLA 2025, DOI 10.1145/3763153); **Cutoff Theorems for
  Parameterized Quantum Circuits** (MFCS 2025); **QuBEC** (TCAD 2024,
  arXiv:2309.10728); symbolic TDD equivalence checking (QCE 2023,
  arXiv:2308.00440); **Formal Verification of Variational Quantum Circuits**
  (arXiv:2507.10635); **Grover's algorithm in HOL Light** (arXiv:2601.02435);
  **Formal Verification of Quantum Stabilizer Code** (CoqPL 2025); **DisQ**
  (arXiv:2407.09710).

## Named in a survey, existence not confirmed
The Electronics 2026 review's Table 2 names **QECVerifier, QuaVer, QVVerify,
HQVer, PulseVerifier** without citations. Searches on 2026-08-18 found no
paper or repository for any of them.

## Inspected and not included (contents reviewed 2026-08-18)
Several of these are good software — the criterion is only whether the
repository itself contains machine-checked verification of quantum artifacts.

- **Silq** (silq-lang/silq) — guarantees come from its type checker; no
  mechanized metatheory in the repository. Its programs can be verified with
  the cataloged SilVer tool.
- **Qimaera**, **Qurts**, **QuRA** — type-level guarantees for quantum
  languages; machine-checked lemmas serve typing side conditions.
- **leaf-qpl** — Lean-based verification on the roadmap, not yet present.
- **iQbricks** — frontend emitting WhyML for the cataloged QBricks.
- **Qunity compiler** (mikhailmints/qunity) — validated by differential
  testing; the Qunity Coq formalization is cataloged separately.
- **qonic-QHoare-logic** — numerical notebook demo.
- **LeanQEC** (BorissovAnton) — initial scaffold, core definitions placeholders
  at review time; distinct from the two cataloged same-named projects.
- **quantum-ci** (hazeltorek) — single-lemma course exercise.
- **Quantum.lean** — unfinished stub. **Quantum4Lean** — primarily a simulator;
  proof content is a small set of gate identities.
- **csd-lean4** — advances a nonstandard reconstruction of quantum mechanics;
  foundations-of-physics programs are outside scope.
- **QSharpCheck** — statistical property-based testing. **ScaLERQEC** —
  statistical error-rate estimation. **VeriQuEST.jl** — simulation of
  verification protocols.
- **QuantumLean-Bench**, **QSpecBench** — LLM/claims benchmark suites.
- **isQ** (gitee.com/arclight_quantum/isq) and **Q|SI>** — quantum compiler and
  programming platform from the ISCAS line; no proof-assistant component in
  the repositories.
- **QSeqSim, Fault-Simulation, Q-ATPG, TDD** (Veri-Q roster) — simulation,
  fault-injection, and test-generation tools.
- **pfoq-compiler** (gitlab.inria.fr) — compiler for the PFOQ polytime quantum
  language; no machine-checked proofs.
- **EasyPQC** — an EasyCrypt extension for post-quantum security reasoning
  (QROM lemmas axiomatized, soundness argued on paper); no quantum program
  semantics inside the tool. Survives as the `deploy-quantum-upgrade` branch
  of EasyCrypt.
- **QPMC** — binary-only distribution, live at https://tis.ios.ac.cn/tool/qmc/;
  no public source repository.
- **phase-rs** (POPL 2026) — a language implementation, not verification.
- Quantum-logic foundations without quantum-computing content: Mizar's QMAX_1
  and Metamath's Quantum Logic Explorer (ql.mm).

## Related resources (not code, but adjacent)
- The [Quantum PL & Verification Bibliography](https://quantumpl.github.io/bib/) —
  the literature map this catalog complements.
- The [VQC workshop](https://verifiedqc.github.io/) (Verified Quantum
  Computing, first edition co-located with CAV 2025).
- [VeriQBench](https://github.com/Veri-Q/Benchmark) — 966 OpenQASM benchmark
  circuits for quantum verification tools (arXiv:2206.10880).

## Folded into other entries rather than listed separately
ReQWIRE and the QPL 2017 artifact snapshot (in QWIRE); the certified Shor
implementation and the VOQC proofs (in SQIR); mlvoqc and pyvoqc (packaging of
VOQC); the LSTA POPL 2025 Zenodo artifact (in AutoQ); inQWIRE support and
tooling repositories; qafny-hs (in Qafny); silspeq (in SilVer);
discrete-quantum-bc (in Quantum barrier certificates); prob-bellkat (in
BellKAT); development mirrors of AFP entries (in their AFP entries).
