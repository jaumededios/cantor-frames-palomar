# Cantor measure frames — Palomar workspace

This repository is the small, standalone Comparator workspace for the main
result of:

> Jaume de Dios Pont, Lukas Liehr, and Mitchell A. Taylor,
> *Cantor measures with odd base do not admit Fourier frames*,
> [arXiv:2607.08656v1](https://arxiv.org/abs/2607.08656).

The result says that if `b > 1` is odd, then the `{0, 2}` base-`b` Cantor
measure does not admit a Fourier frame.

## What to audit

[`Challenge.lean`](Challenge.lean) is the complete human-auditable statement
surface. It imports only Mathlib and defines:

- the fair `{0, 2}` base-`b` Cantor measure;
- complex exponentials;
- frames and exponential systems; and
- the theorem `NoFourierFrameExists`.

[`Solution.lean`](Solution.lean) imports the proof from
[`jaumededios/Cantor_Measure_Frames`](https://github.com/jaumededios/Cantor_Measure_Frames)
at the immutable commit recorded in [`lakefile.toml`](lakefile.toml).
Comparator checks that the challenge and solution expose the same theorem and
that the proof uses only `propext`, `Quot.sound`, and `Classical.choice`.

## Statement fidelity

The public theorem deliberately uses an `ℕ`-indexed exponential family, as
does the Lean-facing statement displayed in Appendix 5 of the paper. This is
the accessible sequence formulation of a countable family, not a restriction
introduced by this wrapper.

The challenge uses `Bool` for a fair two-point digit space where the appendix
prints `Fin 2`. The explicit map `false ↦ 0`, `true ↦ 1` canonically identifies
the resulting product measures. The coding map, pushforward measure, complex
exponentials, almost-everywhere equality, and two-sided frame inequalities
otherwise follow Appendix 5 directly. The complete field-by-field account is
in [`formalization.yaml`](formalization.yaml).

## Provenance and review

The paper authors are Jaume de Dios Pont, Lukas Liehr, and Mitchell A. Taylor.
The paper reports that they curated and reviewed the public Lean statement and
its supporting definitions. It also reports extensive language-model
involvement: the proof files were generated with language-model assistance and
are not presented here as hand-written or line-by-line human-reviewed code.
Jaume de Dios Pont maintains the source formalization and is the responsible
maintainer for this wrapper.

The theorem settles Strichartz's question about Fourier frames for the
middle-third Cantor measure and strengthens it to all odd bases. The key
historical references and their precise relationship to the result are
recorded in [`formalization.yaml`](formalization.yaml). That record also
identifies the `VibeProving/Strichartz-Problem` development-history repository:
its pinned tree is byte-for-byte the same artifact as the proof dependency,
not an unacknowledged second formalization.

## Build and verify

The project uses the Palomar-supported Lean toolchain in `lean-toolchain`.

```bash
lake exe cache get
lake build
```

On Linux, the full Comparator check can be run with:

```bash
./verify.sh
```

The verification script pins Comparator, `lean4export`, and `landrun` to the
same revisions used by Palomar's experimental submission service.

## Submission status

This repository is being prepared for Palomar review and has not been
submitted. Final approval of the immutable submission commit belongs to the
responsible maintainer named in [`formalization.yaml`](formalization.yaml).
