# Known but not cataloged

Recorded so that "missing" is distinguishable from "not found". Checked
2026-08-18; corrections welcome — if a public artifact exists for any of
these, please open an issue.

## Paper exists, no public artifact located
- **CertiQ** (arXiv:1908.08963) — mostly-automated Qiskit compiler verification;
  no public repository located. Its successor Giallar is released and cataloged.
- **QSolver** (arXiv:2602.20171) — no public repository located.
- **QMC, the quantum model checker** (CAV 2008) — no public repository located.
- **QECV** (arXiv:2111.13728) — stabilizer QEC assertion language; no public
  repository located.
- **FeynmanDD** (CAV 2025, arXiv:2509.08276) — no public repository located.
- **Quantum Abstract Interpretation** (Yu & Palsberg, PLDI 2021) — no public
  repository located.
- **Symbolic model checking of quantum circuits in Maude** (PeerJ CS 10:e2098) —
  no public repository located.
- **Formalization of Quantum Protocols using Coq** (Boender, Kammueller,
  Nagarajan, arXiv:1511.01568) — no public repository located.
- **Automated equivalence checking of concurrent quantum systems**
  (Ardeshir-Larijani, Gay, Nagarajan, DOI 10.1145/3231597) — no public
  repository located.
- **Verified OpenQASM–SQIR translation** (PLanQC 2020) — extended abstract; the
  functionality later appears within the SQIR/VOQC toolchain.
- **DDMF / XQDD** (IEICE 2008) — decision-diagram verification data structures;
  no maintained public tools located.

## Named in a survey, existence not confirmed
The Electronics 2026 review's Table 2 names **QECVerifier, QuaVer, QVVerify,
HQVer, PulseVerifier** without citations. Searches on 2026-08-18 found no
paper or repository for any of them.

## Out of scope
Simulators, SDKs, and compilers with no formal-verification component (Qiskit,
Cirq, ProjectQ, Strawberry Fields, ScaffCC, LIQUi|>, Q#, Quipper as a language,
CutQC, SliQSim, and similar). Property-based testing tools (QSharpCheck).
Post-quantum (classical) cryptography formalizations. General-purpose
verification frameworks that are not quantum-specific (xdsl-smt / First-Class
Verification Dialects for MLIR, PLDI 2025).

## Folded into other entries rather than listed separately
ReQWIRE and the QPL 2017 artifact snapshot (in QWIRE); the certified Shor
implementation and the VOQC proofs (in SQIR); mlvoqc and pyvoqc (packaging of
VOQC); the LSTA POPL 2025 Zenodo artifact (in AutoQ); inQWIRE support and
tooling repositories (LinearTypingContexts, ViZX, VizCaR, openqasm-parser,
qasm_to_sqir, VOQC-benchmarks); qafny-hs (in Qafny); development mirrors of
AFP entries (in their AFP entries).

## Inspected and not included (contents reviewed 2026-08-18)
Repositories we examined at the file level and found outside the inclusion
criteria at the time of review. Several are good software — the criterion here
is only whether the repository itself contains machine-checked verification of
quantum artifacts.

- **Silq** (silq-lang/silq) — a quantum language whose guarantees come from its
  type checker; the repository contains no mechanized metatheory.
- **Qimaera** (zamdzhiev/Qimaera) — type-level guarantees in Idris 2; its
  machine-checked lemmas serve typing side conditions rather than quantum
  program correctness.
- **leaf-qpl** (radumarg/leaf-qpl) — Lean-based verification is on the roadmap
  but not yet present in the repository.
- **iQbricks** (tbc23/iQbricks) — a language frontend that emits WhyML for the
  separately cataloged QBricks framework.
- **Qunity compiler** (mikhailmints/qunity) — validated by differential
  testing; the Coq formalization of Qunity is cataloged separately.
- **qonic-QHoare-logic** — a notebook that simulates quantum Hoare logic
  programs numerically.
- **LeanQEC** (BorissovAnton) — an initial scaffold whose core definitions are
  placeholders at the time of review; distinct from the two other projects of
  the same name.
- **quantum-ci** (hazeltorek) — a single-lemma course exercise.
- **Quantum.lean** (Anderssorby) — an unfinished stub.
- **Quantum4Lean** (Alektronnik) — primarily a simulator with an FFI backend;
  its proof content is a small set of gate identities.
- **QuantumLean-Bench**, **QSpecBench** — benchmark suites for evaluating
  reasoning about quantum claims, not verification developments.
- **ScaLERQEC** — statistical estimation of logical error rates by sampling.
- **VeriQuEST.jl** — simulation of blind-quantum-computing verification
  protocols.
- **QSharpCheck** — property-based statistical testing for Q#.
- **csd-lean4** — a formalization advancing a nonstandard reconstruction of
  quantum mechanics; foundations-of-physics programs are outside this
  catalog's scope.
- **QPMC** — the quantum Markov chain model checker is distributed as binaries
  at https://tis.ios.ac.cn/tool/qmc/ (live as of 2026-08-18); there is no
  public source repository to catalog.
- **AFP Complex_Bounded_Operators and Hilbert_Space_Tensor_Product** — general
  functional-analysis libraries (their stated purpose is not quantum) that
  several cataloged Isabelle entries build on.
