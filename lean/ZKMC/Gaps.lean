/-
ZKMC/Gaps.lean: two defects of the volume, stated so that a machine can check them.

NOT COMPILED. Written Friday 6 November 2026 on a machine with no Lean toolchain
installed. Nothing here has been elaborated, built or kernel checked.

Both defects belong to the review's cross-cutting theme T1 of
review/editor_consolidation.md: a relation is written down, a theorem is applied under
hypotheses the relation does not carry, and the chapter then states the theorem's
conclusion. The register entries are E06 and E07, both blocking.

A referee says "the relation does not imply the conclusion". That is an assertion about
a non-implication, and a non-implication is proved by exhibiting a witness that
satisfies the premise and fails the conclusion. Each defect below is turned into exactly
that: a witness, a proof that it satisfies every row of the premise, and a proof that it
fails the conclusion. The statements are small and finite on purpose.

What the file does not do. It does not model BLS12-381, the KZG commitment, Poseidon, or
R1CS. It models each relation by the shape that carries the defect: a polynomial by its
coefficient list over the integers with Horner evaluation, a commitment by an abstract
function of the polynomial handed to it, and a digest by an abstract function of the
guard row. The defect is that nothing in the relation constrains the witness, and that
is visible at this level. Modelling the field would add nothing to the argument and a
great deal that could be wrong. The integers rather than a prime field: the only field
facts used are that evaluation of the empty coefficient list is zero and that zero is
not one, both of which hold over the integers, and `omega` decides them.

E06, the first defect. sections/z03.tex, Equation eq:z03_relation at lines 70 to 77, is
the relation of the explicit-state scheme: a degree bound, vanishing on the three public
evaluation sets, and two commitment openings. Lemma lem:z03_vanish at lines 313 to 316
is what turns vanishing into disjointness, and it holds only under the hypothesis that
the committed polynomial satisfies Equation eq:z03_indicator, that it is the indicator
of the secret set along the embedding. That hypothesis lives in the lemma's premise and
in the honest prover's Python. No relation states it and no verifier checks it. So the
zero polynomial satisfies the relation, and the verdict says nothing about the machine.

E07, the second defect. sections/z08.tex, the `Step(m)` template, constrains a guard row
`A` and a bound vector `b` that are private inputs. Each entry is range checked to a
signed sixteen-bit integer and each row is compared against its bound, and that is all.
So the all-zero program satisfies every row of the premise, whatever the secret states
are, and the proof says nothing about the modem machine. The same shape appears in
sections/z12.tex and sections/z13.tex. The fix the chapter now carries, a public
Poseidon digest of the row that the circuit asserts against, is modelled below as
`Bound`, and the second theorem is the statement that the premise does not imply it.
-/

namespace ZKMC

/-! ## E06: a relation with no zero-one obligation -/

/-- A univariate polynomial over the integers: coefficients, lowest order first. The
empty list is the zero polynomial. -/
abbrev Poly := List Int

/-- Horner evaluation of a coefficient list. -/
def evalPoly : Poly -> Int -> Int
  | [], _ => 0
  | c :: cs, x => c + x * evalPoly cs x

/-- The zero polynomial evaluates to zero everywhere. -/
theorem evalPoly_nil (x : Int) : evalPoly [] x = 0 := rfl

/-- Equation eq:z03_relation of sections/z03.tex for one of the two committed
polynomials, with the three conjuncts it has.

`degree` is the degree bound, written as a bound on the number of coefficients.
`vanishes` is the vanishing on the public evaluation set `E`.
`opens` is the commitment opening; `Com` of Definition def:z04_kzg is a deterministic
function of the polynomial handed to it, so it is modelled as a function of the
polynomial and `c` is the public commitment, which the prover computes from its own
witness. The blinding mask of Remark rem:z03_blind is folded into `Com`, which is sound
for this argument because the mask vanishes on the evaluation domain and so changes
neither `degree` nor `vanishes`.

There is no fourth conjunct, and that absence is the defect. -/
structure RelE (degBound : Nat) (E : Int -> Prop) (Com : Poly -> Int) (c : Int)
    (p : Poly) : Prop where
  degree : List.length p <= degBound
  vanishes : forall e, E e -> evalPoly p e = 0
  opens : Com p = c

/-- The obligation that Lemma lem:z03_vanish needs and that no relation states:
Equation eq:z03_indicator, that `p` takes the value one on the secret set and zero off
it, along the embedding. Written here with the embedded points as the argument. -/
def Indicates (T : Int -> Prop) (p : Poly) : Prop :=
  forall x, (T x -> evalPoly p x = 1) /\ (Not (T x) -> evalPoly p x = 0)

/-- The zero polynomial satisfies the relation, for every degree bound, every public
evaluation set, and every commitment function, with the public commitment the prover
computes from it. This is the machine-checkable form of "the zero polynomial is
accepted". -/
theorem zero_satisfies_RelE (degBound : Nat) (E : Int -> Prop) (Com : Poly -> Int) :
    RelE degBound E Com (Com ([] : Poly)) ([] : Poly) :=
  { degree := Nat.zero_le degBound
    vanishes := fun e _ => evalPoly_nil e
    opens := rfl }

/-- The zero polynomial fails the obligation, as soon as the secret set is not empty.
The hypothesis that it is not empty is needed and is not a weakness of the
counterexample: for the modem machine of Definition def:z03_modem the transition
relation has sixty-one elements. -/
theorem zero_not_Indicates (T : Int -> Prop) (x0 : Int) (hx0 : T x0) :
    Not (Indicates T ([] : Poly)) := by
  intro h
  have h1 : evalPoly ([] : Poly) x0 = 1 := (h x0).1 hx0
  have h0 : evalPoly ([] : Poly) x0 = 0 := evalPoly_nil x0
  have hne : (0 : Int) = 1 := Eq.trans h0.symm h1
  omega

/-- E06, the non-implication: the relation does not imply the zero-one obligation. A
witness satisfies every conjunct of the relation and fails the obligation. -/
theorem relE_does_not_imply_Indicates
    (degBound : Nat) (E : Int -> Prop) (Com : Poly -> Int)
    (T : Int -> Prop) (x0 : Int) (hx0 : T x0) :
    ∃ p : Poly, ∃ c : Int, RelE degBound E Com c p /\ Not (Indicates T p) :=
  Exists.intro ([] : Poly) (Exists.intro (Com ([] : Poly))
    (And.intro (zero_satisfies_RelE degBound E Com) (zero_not_Indicates T x0 hx0)))

/-- E06, the consequence the chapters state. The verdict is read as the disjointness of
the secret set `T` from the enumerated bad set `B`, which is Equation eq:z03_disjoint
reached through Lemma lem:z03_vanish. The relation does not imply that either: there are
sets `T` and `B` and a polynomial satisfying the relation with `T` and `B` meeting.

`T` and `B` are existentially quantified here, and that is the whole content of the
correction made on Saturday 7 November 2026. An earlier form took them as parameters
together with a point `x0` in both, and then discharged the second conjunct from those
hypotheses. That form elaborates and says nothing, because the conjunct it proves never
mentions the polynomial: assuming two sets meet and concluding that they meet is not a
non-implication. A non-implication has to build the counterexample, so the sets are
constructed here rather than assumed. -/
theorem relE_does_not_imply_disjointness
    (degBound : Nat) (E : Int -> Prop) (Com : Poly -> Int) :
    ∃ (T B : Int -> Prop), ∃ p : Poly, ∃ c : Int,
      RelE degBound E Com c p /\ (∃ x, T x /\ B x) :=
  Exists.intro (fun _ => True) (Exists.intro (fun _ => True)
    (Exists.intro ([] : Poly) (Exists.intro (Com ([] : Poly))
      (And.intro (zero_satisfies_RelE degBound E Com)
        (Exists.intro (0 : Int) (And.intro True.intro True.intro))))))

/-- The obligation does the work it is meant to do. Added to the relation, it excludes
the witness above, which is the evidence that the missing conjunct is exactly the
missing conjunct and not a different one. -/
theorem RelE_and_Indicates_excludes_zero
    (degBound : Nat) (E : Int -> Prop) (Com : Poly -> Int) (c : Int)
    (T : Int -> Prop) (x0 : Int) (hx0 : T x0) :
    Not (RelE degBound E Com c ([] : Poly) /\ Indicates T ([] : Poly)) :=
  fun h => zero_not_Indicates T x0 hx0 h.2

/-! ## E07: a guarded update whose matrix and vector are unbound -/

/-- One row of the guarded update of the `Step(m)` template of sections/z08.tex: four
column entries and the bound on their dot product with the state pair. -/
structure Guard where
  a0 : Int
  a1 : Int
  a2 : Int
  a3 : Int
  b : Int

/-- The state pair `y = (x, x')` the row is evaluated on, as four integer signals. -/
structure StatePair where
  y0 : Int
  y1 : Int
  y2 : Int
  y3 : Int

/-- The row holds at the state pair: `A y <= b` for this row. -/
def Guard.holds (g : Guard) (y : StatePair) : Prop :=
  g.a0 * y.y0 + g.a1 * y.y1 + g.a2 * y.y2 + g.a3 * y.y3 <= g.b

/-- The range the circuit's `Num2Bits(16)` on `e + 32768` enforces: a signed sixteen-bit
integer. -/
def inRange16 (e : Int) : Prop := -32768 <= e /\ e < 32768

/-- The prover's program: the guard row, the two linear ranking forms with their
constants, and the fairness flag. In sections/z08.tex every one of these except
`wj, uj, wk, uk, f` is a private input, and the row is private with no public binding,
which is the defect. -/
structure Program where
  g : Guard
  wj0 : Int
  wj1 : Int
  uj : Int
  wk0 : Int
  wk1 : Int
  uk : Int
  f : Int

/-- Every row the `Step(m)` template constrains, for one guard row, written out. This is
the premise of the circuit as the chapter had it before the public digest was added: the
range checks on the row and on the state pair, the guard row itself, the zero-one check
on the fairness flag, and the ranking comparison. -/
structure Premise (P : Program) (y : StatePair) : Prop where
  rangeA0 : inRange16 P.g.a0
  rangeA1 : inRange16 P.g.a1
  rangeA2 : inRange16 P.g.a2
  rangeA3 : inRange16 P.g.a3
  rangeB : inRange16 P.g.b
  rangeY0 : inRange16 y.y0
  rangeY1 : inRange16 y.y1
  rangeY2 : inRange16 y.y2
  rangeY3 : inRange16 y.y3
  guardRow : P.g.holds y
  fBool : P.f = 0 \/ P.f = 1
  rank : P.wk0 * y.y2 + P.wk1 * y.y3 + P.uk + P.f
    <= P.wj0 * y.y0 + P.wj1 * y.y1 + P.uj

/-- The binding the circuit was missing, and which sections/z08.tex now carries as
`allH.out === rowHash`: the guard row hashes to a public digest. `H` is the digest
function and `h` the public value, both abstract here. -/
def Bound (H : Guard -> Int) (h : Int) (P : Program) : Prop := H P.g = h

/-- The all-zero program: `A = 0`, `b = 0`, both ranking forms zero, and the fairness
flag zero. -/
def zeroProgram : Program :=
  { g := { a0 := 0, a1 := 0, a2 := 0, a3 := 0, b := 0 },
    wj0 := 0, wj1 := 0, uj := 0,
    wk0 := 0, wk1 := 0, uk := 0,
    f := 0 }

/-- Zero is a signed sixteen-bit integer. -/
theorem zero_inRange16 : inRange16 0 := And.intro (by omega) (by omega)

/-- The all-zero guard row holds at every state pair, in range or not. This is the heart
of the defect: the row puts no condition at all on the states. -/
theorem zero_guard_holds (y : StatePair) : zeroProgram.g.holds y := by
  show (0 : Int) * y.y0 + 0 * y.y1 + 0 * y.y2 + 0 * y.y3 <= 0
  omega

/-- The all-zero ranking comparison holds at every state pair. -/
theorem zero_rank_holds (y : StatePair) :
    zeroProgram.wk0 * y.y2 + zeroProgram.wk1 * y.y3 + zeroProgram.uk + zeroProgram.f
      <= zeroProgram.wj0 * y.y0 + zeroProgram.wj1 * y.y1 + zeroProgram.uj := by
  show (0 : Int) * y.y2 + 0 * y.y3 + 0 + 0 <= (0 : Int) * y.y0 + 0 * y.y1 + 0
  omega

/-- The all-zero program satisfies every row of the premise, for every state pair whose
four entries are in range. The state pair is quantified, so this is not a statement
about one convenient pair: the premise holds whatever the secret states are. -/
theorem zeroProgram_premise (y : StatePair)
    (h0 : inRange16 y.y0) (h1 : inRange16 y.y1)
    (h2 : inRange16 y.y2) (h3 : inRange16 y.y3) :
    Premise zeroProgram y :=
  { rangeA0 := zero_inRange16
    rangeA1 := zero_inRange16
    rangeA2 := zero_inRange16
    rangeA3 := zero_inRange16
    rangeB := zero_inRange16
    rangeY0 := h0
    rangeY1 := h1
    rangeY2 := h2
    rangeY3 := h3
    guardRow := zero_guard_holds y
    fBool := Or.inl rfl
    rank := zero_rank_holds y }

/-- E07, the non-implication: the premise does not imply the binding. The hypothesis is
that the all-zero row does not hash to the public digest of the honest row, which is
what collision resistance of Poseidon is for and which is assumed here, not proved. -/
theorem premise_does_not_imply_Bound
    (H : Guard -> Int) (h : Int) (hne : Not (H zeroProgram.g = h))
    (y : StatePair)
    (h0 : inRange16 y.y0) (h1 : inRange16 y.y1)
    (h2 : inRange16 y.y2) (h3 : inRange16 y.y3) :
    ∃ P : Program, Premise P y /\ Not (Bound H h P) :=
  Exists.intro zeroProgram
    (And.intro (zeroProgram_premise y h0 h1 h2 h3) hne)

/-- The all-zero state pair, to make the statement above concrete with no hypotheses
left over. -/
def zeroPair : StatePair := { y0 := 0, y1 := 0, y2 := 0, y3 := 0 }

/-- The all-zero program satisfies every row of the premise at the all-zero state pair,
with no hypotheses at all. -/
theorem zeroProgram_premise_zeroPair : Premise zeroProgram zeroPair :=
  zeroProgram_premise zeroPair zero_inRange16 zero_inRange16 zero_inRange16
    zero_inRange16

end ZKMC
