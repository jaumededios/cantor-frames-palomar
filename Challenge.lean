/-
Copyright (c) 2026 Jaume de Dios Pont, Lukas Liehr, Mitchell A. Taylor. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

import Mathlib

noncomputable section

open scoped Real Complex InnerProductSpace BigOperators
open MeasureTheory
open ENNReal

namespace CantorFramesPalomar

/-!
# Odd-base Cantor measures do not admit Fourier frames

Lean  formalization of Theorem 1.1 of
J. de Dios Pont, L. Liehr, and M. A. Taylor,
*Cantor measures with odd base do not admit Fourier frames*
[arXiv:2607.08656v1](https://arxiv.org/abs/2607.08656$0).
-/

/-! ## Definition of the Cantor measure `μ_b` -/

/-- Let `Ω` be set of functions from the natural numbers to `{0, 1}`. -/
abbrev Ω : Type := ℕ → Fin 2

/-- And define `uniformBoolSeq` uniform product measure on `Ω`. -/
noncomputable def uniformBoolSeq : Measure Ω :=
  Measure.infinitePi (fun _ : ℕ ↦ (PMF.uniformOfFintype (Fin 2)).toMeasure)

/-- For a real number `b`, we define the coding map for the `{0, 2}` base-`b` Cantor measure. -/
noncomputable def code (b : ℝ) (ω : Ω) : ℝ :=
  ∑' n : ℕ, 2 * (ω n) / (b ^ (n + 1))

/-- Then we define the base-`b` Cantor measure, using digits `{0, 2}` as the pushforward of `uniformBoolSeq` by `code b`. -/
noncomputable def cantor_μ (b : ℕ) : Measure ℝ :=
  Measure.map (code b) uniformBoolSeq

/-! ## Definition of Fourier frames -/

/-- Shorthand `e` for the complex exponential at frequency `k`. -/
noncomputable def e (k : ℝ) : ℝ → ℂ :=
  fun x ↦ Complex.exp (2 * π * Complex.I * k * x)

/-- A family in a complex Hilbert space is a frame if it satisfies two-sided frame bounds. -/
def IsFrame {ι H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (atoms : ι → H) : Prop :=
  ∃ A > 0, ∃ B > 0,
    ∀ f : H,
      A * ‖f‖ ^ 2 ≤ ∑' j, ‖⟪f, atoms j⟫_ℂ‖ ^ 2 ∧
      ∑' j, ‖⟪f, atoms j⟫_ℂ‖ ^ 2 ≤ B * ‖f‖ ^ 2

/-- A family of `Lᵖ` functions is an exponential system if its
 members are `μ`-almost everywhere equal to complex exponentials. -/
def IsExpSystem {μ : Measure ℝ} {p : ℝ≥0∞} (F : ℕ → Lp ℂ p μ) : Prop :=
  ∀ j : ℕ, ∃ k : ℝ, (F j) =ᵐ[μ] e k

/-! ### Main result -/

/-- No natural-number-indexed exponential system forms a frame for
`L²(cantor_μ b)` when `b > 1` is an odd natural number. -/
theorem NoFourierFrameExists
    {b : ℕ} (hb : 1 < b) (hb_odd : Odd b)
    (F : ℕ → Lp ℂ 2 (cantor_μ b)) (hF : IsExpSystem F) :
    ¬ IsFrame F := by
  sorry

end CantorFramesPalomar
