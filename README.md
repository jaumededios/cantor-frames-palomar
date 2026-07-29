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

This repository is being prepared for Palomar review. Before an immutable
commit is submitted:

- [ ] choose a repository license, add `LICENSE`, and replace the license TODO
  in `formalization.yaml`;
- [ ] have an author confirm the submission metadata and clear its review TODO.
