import CantorMeasureFrames.MainTheorem

noncomputable section

open scoped Real Complex InnerProductSpace BigOperators
open MeasureTheory
open ENNReal

/-!
# Solution

The public declarations below match Appendix 5 of the source paper. The final
proof is transported across the canonical equivalence `Fin 2 ≃ Bool` to the
proof-backed declarations in the pinned `jaumededios/Cantor_Measure_Frames`
dependency. Comparator checks this surface against `Challenge.lean`.
-/

namespace CantorFramesPalomar

/-! ### Definition of the Cantor measure `μ_b` for odd `b ≥ 3` -/

/-- The set of functions from the natural numbers to `{0, 1}`. -/
abbrev Ω : Type := ℕ → Fin 2

/-- The uniform product measure on `Ω`. -/
noncomputable def uniformBoolSeq : Measure Ω :=
  Measure.infinitePi (fun _ : ℕ ↦ (PMF.uniformOfFintype (Fin 2)).toMeasure)

/-- The coding map for the `{0, 2}` base-`b` Cantor measure. -/
noncomputable def code (b : ℝ) (ω : Ω) : ℝ :=
  ∑' n : ℕ, 2 * (ω n) / (b ^ (n + 1))

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

/-! ### Bridge to the pinned proof development -/

/-- Convert a `Fin 2` digit sequence to the Boolean representation used
internally by the pinned proof library. -/
private def toBoolSeq (ω : Ω) : _root_.Ω :=
  fun n ↦ finTwoEquiv (ω n)

private lemma measurable_toBoolSeq : Measurable toBoolSeq := by
  unfold toBoolSeq
  exact measurable_pi_lambda _ fun n ↦
    (measurable_of_finite finTwoEquiv).comp (measurable_pi_apply n)

private lemma uniformFinTwo_map_bool :
    (PMF.uniformOfFintype (Fin 2)).map finTwoEquiv =
      PMF.uniformOfFintype Bool := by
  ext u
  cases u <;> norm_num [PMF.map_apply, finTwoEquiv]

private lemma uniformBoolSeq_map_toBool :
    uniformBoolSeq.map toBoolSeq = _root_.uniformBoolSeq := by
  unfold uniformBoolSeq toBoolSeq _root_.uniformBoolSeq
  rw [Measure.infinitePi_map_pi
    (μ := fun _ : ℕ ↦ (PMF.uniformOfFintype (Fin 2)).toMeasure)
    (f := fun _ : ℕ ↦ finTwoEquiv)
    (fun _ ↦ measurable_of_finite _)]
  congr 1
  funext n
  rw [PMF.toMeasure_map finTwoEquiv (PMF.uniformOfFintype (Fin 2))
    (measurable_of_finite _)]
  exact congrArg PMF.toMeasure uniformFinTwo_map_bool

private lemma fin_digit_eq_bool_bit (u : Fin 2) :
    (u : ℝ) = _root_.bit (finTwoEquiv u) := by
  fin_cases u <;> norm_num [_root_.bit, finTwoEquiv]

private lemma code_eq_bool_code (b : ℝ) :
    code b = _root_.code b ∘ toBoolSeq := by
  funext ω
  unfold code _root_.code toBoolSeq
  congr 1
  funext n
  rw [fin_digit_eq_bool_bit]

private lemma measurable_bool_bit : Measurable (_root_.bit) :=
  measurable_of_finite _

private lemma measurable_bool_code (b : ℝ) : Measurable (_root_.code b) := by
  unfold _root_.code
  apply Measurable.tsum
  intro n
  exact ((measurable_bool_bit.comp (measurable_pi_apply n)).const_mul 2).div_const _

private lemma cantor_μ_eq_bool_cantor_μ (b : ℕ) :
    cantor_μ b = _root_.cantor_μ b := by
  unfold cantor_μ _root_.cantor_μ
  rw [code_eq_bool_code]
  rw [← Measure.map_map (measurable_bool_code b) measurable_toBoolSeq]
  rw [uniformBoolSeq_map_toBool]

/-! ### Main result -/

/-- No natural-number-indexed exponential system forms a frame for
`L²(cantor_μ b)` when `b > 1` is odd. -/
theorem NoFourierFrameExists
    {b : ℕ} (hb : 1 < b) (hb_odd : Odd b)
    (F : ℕ → Lp ℂ 2 (cantor_μ b)) (hF : IsExpSystem F) :
    ¬ IsFrame F := by
  intro hFrame
  have h : ∃ F : ℕ → Lp ℂ 2 (cantor_μ b), IsExpSystem F ∧ IsFrame F :=
    ⟨F, hF, hFrame⟩
  rw [cantor_μ_eq_bool_cantor_μ b] at h
  rcases h with ⟨F, hF, hFrame⟩
  have hFroot : _root_.IsExpSystem F := by
    intro j
    rcases hF j with ⟨k, hk⟩
    exact ⟨k, by simpa [e, _root_.e] using hk⟩
  exact (_root_.NoFourierFrameExists hb hb_odd F hFroot)
    (by simpa [IsFrame, _root_.IsFrame] using hFrame)

end CantorFramesPalomar
