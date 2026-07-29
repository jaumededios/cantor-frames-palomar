import Mathlib

noncomputable section

open scoped Real Complex InnerProductSpace BigOperators
open MeasureTheory
open ENNReal

/-!
# Challenge: odd-base Cantor measures do not admit Fourier frames

This is the human-auditable statement surface for Theorem 1.1 of
J. de Dios Pont, L. Liehr, and M. A. Taylor,
*Cantor measures with odd base do not admit Fourier frames*
(arXiv:2607.08656v1).
-/

/-! ### Definition of the Cantor measure `μ_b` for odd `b ≥ 3` -/

/-- Infinite fair-bit sequences. -/
abbrev Ω : Type := ℕ → Bool

/-- Interpret a Boolean as the digit `0` or `1`. -/
def bit (u : Bool) : ℝ := if u then 1 else 0

/-- The uniform product measure on infinite fair-bit sequences. -/
noncomputable def uniformBoolSeq : Measure Ω :=
  Measure.infinitePi (fun _ : ℕ ↦ (PMF.uniformOfFintype Bool).toMeasure)

/-- The coding map for the `{0, 2}` base-`b` Cantor measure. -/
noncomputable def code (b : ℝ) (ω : Ω) : ℝ :=
  ∑' n : ℕ, 2 * bit (ω n) / (b ^ (n + 1))

/-- The base-`b` Cantor measure, using digits `{0, 2}`. -/
noncomputable def cantor_μ (b : ℕ) : Measure ℝ :=
  Measure.map (code b) uniformBoolSeq

/-! ### Definition of Fourier frames -/

/-- The complex exponential at frequency `k`. -/
noncomputable def e (k : ℝ) : ℝ → ℂ :=
  fun x ↦ Complex.exp (2 * π * Complex.I * k * x)

/-- A family in a complex Hilbert space is a frame if it satisfies two-sided frame bounds. -/
def IsFrame {ι H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    (atoms : ι → H) : Prop :=
  ∃ A > 0, ∃ B > 0,
    ∀ f : H,
      A * ‖f‖ ^ 2 ≤ ∑' j, ‖⟪f, atoms j⟫_ℂ‖ ^ 2 ∧
      ∑' j, ‖⟪f, atoms j⟫_ℂ‖ ^ 2 ≤ B * ‖f‖ ^ 2

/-- A family of `Lᵖ` functions is an exponential system if its members are
`μ`-almost everywhere equal to complex exponentials. -/
def IsExpSystem {μ : Measure ℝ} {p : ℝ≥0∞} (F : ℕ → Lp ℂ p μ) : Prop :=
  ∀ j : ℕ, ∃ k : ℝ, (F j) =ᵐ[μ] e k

/-! ### Main result -/

/-- No natural-number-indexed exponential system forms a frame for
`L²(cantor_μ b)` when `b > 1` is odd. -/
theorem NoFourierFrameExists
    {b : ℕ} (hb : 1 < b) (hb_odd : Odd b)
    (F : ℕ → Lp ℂ 2 (cantor_μ b)) (hF : IsExpSystem F) :
    ¬ IsFrame F := by
  sorry
