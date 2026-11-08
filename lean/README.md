# zkmc: the Lean 4 development for the embedded-zkmc volume

Written Friday 6 November 2026, published Saturday 7 November 2026. See
[`STATUS.md`](STATUS.md) first: the build passes, and that file says what a passing
build does and does not establish.

## The first thing to know

**This project builds.** `lake build` passes on a clean checkout in GitHub Actions,
pinned to `leanprover/lean4:v4.35.0`, with no Mathlib and no placeholder proof. A kernel
has accepted every declaration here. Lean is still installed on neither machine this
volume is written on, so the runner is the only kernel that has read it.

So the words used below are chosen carefully, and the distinction they keep is now a
different one.

- **Elaborates** means the kernel accepted it: the statement is well formed, the term has
  the type it claims, and nothing rests on an unproved step. That is what the build
  establishes.
- **Correct** means the theorem states what it was meant to state. The build cannot
  establish that, and in this project it did not: a review found one theorem that compiled
  and proved nothing, because it assumed its own conclusion. It is recorded in
  [`STATUS.md`](STATUS.md) and corrected in place rather than removed.
- **Theorem 3.2 is not formalised end to end.** What is proved here is the
  ranking-function argument. The step to emptiness of the language intersection, and
  Corollary 3.3 from there to satisfaction, are absent.

The volume was corrected on Friday 6 November 2026 because a chapter titled "machine
checked" contained an unproved step. A green build makes that mistake easier to repeat,
not harder, which is why the three distinctions above are kept in every file.

## What is in it

```
lean/
  lakefile.toml          the Lake package, no dependencies
  lean-toolchain         leanprover/lean4:stable, to be pinned, see below
  ZKMC.lean              the library root, imports the four modules
  ZKMC/Basic.lean        the four structures of chapter 14
  ZKMC/Descent.lean      le_of_mono and no_infinite_descent
  ZKMC/Theorem32.lean    Theorem 3.2, with the chapter's sorry closed
  ZKMC/Gaps.lean         two defects of the volume as non-implication theorems
  README.md              this file
  STATUS.md              what is claimed, what is not, and everything still open
```

## What is written out in full, and what it says

### ZKMC/Basic.lean

The four structures of the listing in `sections/z14.tex`, with the field names
unchanged, so that the chapter and the project name the same things: `TS` with `init`,
`trans`, `obs`; `NBA` with `init`, `delta`, `fair`, `fairSub`; `FairExec` with `s`, `q`,
`init`, `step`, `fairInf`; `Ranking` with `V`, `c4`, `c5`, `c6`. No proofs.

### ZKMC/Descent.lean

- `le_of_add`: non-increase at every step composes along an interval of any length.
  A helper the chapter does not have.
- `le_of_mono`: the chapter's statement, proved from `le_of_add`.
- `no_infinite_descent`: Lemma `lem:z14_descent`. The chapter's own counting argument,
  with `omega` at the two places the prose says "chaining the three inequalities" and
  "no natural number satisfies this".

### ZKMC/Theorem32.lean

`no_fair_execution`, the chapter's `sorry` at `sections/z14.tex` line 318, closed.
The statement is the chapter's, unchanged.

The chapter's docstring says the open step is a recursive construction over the
existential of `c5`, needing "either a choice principle or a reformulation of `V`
through a total projection". The reformulation is what is done, and no choice principle
is needed, because nothing is in fact chosen: `V (e.s i) (e.q i)` is already a definite
element of `Option Nat`. So the sequence of natural numbers is defined outright,

```
rankAt M A R e i = (R.V (e.s i) (e.q i)).getD 0
```

a total projection whose default is never reached, and the existential of `c5` is used
only to prove the Prop that the projection is faithful, `R.V (e.s i) (e.q i) = some
(rankAt M A R e i)`. An induction whose conclusion is a Prop needs no choice.

The rest is the prose proof of `thm:z03_ranking` in `sections/z03.tex`, lines 199 to
231, step for step:

| Prose step | Here | From |
| --- | --- | --- |
| Step 1, the base case | `rank_some`, the `zero` case | `c4` |
| Step 2, finiteness and monotonicity | `rank_some` succ case, `rank_mono` | `c5` |
| Step 3, strict decrease on fair indices | `rank_strict` | `c6` |
| Step 4, the descent | `no_fair_execution` | `no_infinite_descent` |

Step 4 is the step most write-ups skip, and the prose does it: the chaining of the
non-increase across the gap between consecutive fair indices, `v (i_{k+1}) <= v (i_k +
1)` whenever `i_k + 1 <= i_{k+1}`. In this development that chaining is `le_of_mono`,
and `no_infinite_descent` calls it at exactly that point, so the gap is crossed by the
same inequality the prose uses.

One honest note on the statement. `NBA.fairSub` is never used. It is in the structure
because the paper states it, and the proof does not need it: `c6` carries its own
`M.trans` premise and the `A.delta` step at a fair index comes from `FairExec.step`.

### ZKMC/Gaps.lean

Two defects of the volume turned into theorems of the shape a non-implication needs: a
witness, a proof that it satisfies every row of the premise, and a proof that it fails
the conclusion. Both belong to the review's theme T1 in
`review/editor_consolidation.md`.

**E06, the relation with no zero-one obligation.** `sections/z03.tex` Equation
`eq:z03_relation` has a degree bound, vanishing on the public sets, and the commitment
openings. Lemma `lem:z03_vanish`, which turns vanishing into disjointness, holds only
under Equation `eq:z03_indicator`, that the committed polynomial is the indicator of the
secret set. No relation states it.

- `zero_satisfies_RelE`: the zero polynomial satisfies all three conjuncts, for every
  degree bound, every public evaluation set and every commitment function.
- `zero_not_Indicates`: it fails the obligation, as soon as the secret set is not empty.
- `relE_does_not_imply_Indicates`: the non-implication.
- `relE_does_not_imply_disjointness`: the same witness satisfies the relation while the
  secret set and the enumerated bad set do meet, which is the conclusion the chapters
  draw from the verdict.
- `RelE_and_Indicates_excludes_zero`: with the obligation added, the witness is
  excluded. This is the evidence that the missing conjunct is the one named and not
  another.

**E07, a guarded update whose matrix and vector are unbound.** The `Step(m)` template of
`sections/z08.tex` range checks the private guard row and compares each row against its
bound, and that is all.

- `zero_guard_holds`: the all-zero row holds at every state pair, in range or not.
- `zeroProgram_premise`: the all-zero program satisfies every row of the premise, with
  the state pair quantified, so it is not a statement about one convenient pair.
- `zeroProgram_premise_zeroPair`: the same with no hypotheses at all.
- `premise_does_not_imply_Bound`: the non-implication against the public digest binding
  the chapter now carries as `allH.out === rowHash`.

What `Gaps.lean` does not model: BLS12-381, KZG, Poseidon, R1CS. A polynomial is a
coefficient list over the integers with Horner evaluation, a commitment is an abstract
function of the polynomial handed to it, a digest is an abstract function of the guard
row. The defect is that nothing in the relation constrains the witness, and that is
visible at this level. The only field facts used are that the zero polynomial evaluates
to zero and that zero is not one, both true over the integers.

Two hypotheses in `Gaps.lean` are assumptions and are named as such in the file: that
the secret transition relation is not empty, which for the modem machine of
`def:z03_modem` holds with sixty-one transitions; and that the all-zero row does not
hash to the public digest of the honest row, which is collision resistance of Poseidon,
assumed and not proved.

## Why there is no Mathlib dependency

Nothing here needs it. Every tactic used is in core Lean 4: `intro`, `induction`,
`cases`, `refine`, `exact`, `rw`, `show`, `unfold`, `omega`. Every lemma used by name is
in core: `Nat.le_refl`, `Nat.le_trans`, `Nat.zero_le`, `congrArg`, `Eq.trans`,
`Exists.intro`, `And.intro`, `Or.inl`. `omega` has been in core Lean 4 for a long time
and decides everything it is asked to decide here, which is linear arithmetic over `Nat`
and over `Int` with numeral coefficients.

Two consequences, both deliberate.

1. The project builds with the toolchain alone. No `lake exe cache get`, no Mathlib
   revision to pin, no olean tree of several gigabytes, which also means the Pi 4B
   replay of `sections/z14.tex` becomes a much smaller thing to ship.
2. The chapter's listing imports `Mathlib.Tactic` and uses `rcases`, which is a Mathlib
   tactic and not a core one. `ZKMC/Descent.lean` proves the same `le_of_mono` statement
   by a different core-only script, and says so in its header. This is a deviation from
   the chapter and is listed in `STATUS.md`.

If a future addition does need Mathlib, the parts that would need it first are the
Corollary `cor:z03_mc` step from emptiness to satisfaction, which wants a real treatment
of omega-words, and anything about the finite field, which wants `ZMod` and
`Polynomial`.

## How to check it

The `lean` workflow runs these on every push, and that runner is the only kernel that has
read this project: Lean is installed on neither machine this volume is written on. To run
them yourself, from a clone of this repository with `elan` installed:

    cd lean
    lake build 2>&1 | tee build.log

The acceptance test, read from `build.log`:

1. Zero errors.
2. Zero occurrences of `declaration uses 'sorry'`. There is no `sorry` in the sources,
   so any such warning means a file was edited.
3. One check that the check can fail: weaken `mono` in `ZKMC/Descent.lean` to
   `n (i + 1) <= n i + 1` and confirm that `no_infinite_descent` now reports an error. A
   check that cannot fail is not a check.

To replay a single module against built oleans, which is the verifier's side of the
chapter's protocol:

    lake env lean ZKMC/Theorem32.lean

## The toolchain pin

`lean-toolchain` reads `leanprover/lean4:v4.35.0`, and that is a real pin rather than a
placeholder. It was an earlier `leanprover/lean4:stable`, which is a moving target, until
the first green build on Saturday 7 November 2026 made the exact version knowable. The
build is therefore reproducible and not merely repeatable, and `lean/STATUS.md` records
the run that established it.
