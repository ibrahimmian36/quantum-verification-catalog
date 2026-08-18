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
