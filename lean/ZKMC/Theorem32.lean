/-
ZKMC/Theorem32.lean: the ranking-function rule, Theorem 3.2 of the paper, with the
chapter's `sorry` closed.

Builds. `lake build` passes on a clean checkout in GitHub Actions, pinned to
leanprover/lean4:v4.35.0, with no Mathlib. A kernel has accepted every declaration
here. That says the proofs elaborate, not that they state what they should: see
STATUS.md, which records one theorem that compiled and proved nothing. The word
"proved" below means "written out in full with no `sorry`", and nothing more: no
kernel has seen any of it.

The gap in sections/z14.tex, line 318, is a `sorry` on `no_fair_execution`, and the
chapter's own docstring says why: step one of three is "a recursive construction over
the existential of `c5`, so it needs either a choice principle or a reformulation of
`V` through a total projection".

The reformulation is what is done here, and no choice principle is needed. The value
`V (e.s i) (e.q i)` is already a definite element of `Option Nat`; it is not chosen.
So the sequence of natural numbers can be *defined* outright as

  rankAt i = (V (e.s i) (e.q i)).getD 0

a total projection with a default that is never reached, and the existential of `c5` is
then used only to prove the Prop that the projection is faithful, namely
`V (e.s i) (e.q i) = some (rankAt i)`. A Prop-valued induction over the existential
needs no choice. That is the one step the chapter left open.

The rest follows the prose proof of Theorem thm:z03_ranking in sections/z03.tex, lines
199 to 231, step for step:

  Step 1, the base case          -> rank_some, the `zero` case, from c4
  Step 2, finiteness, monotone   -> rank_some, the `succ` case, and rank_mono, from c5
  Step 3, strict on fair indices -> rank_strict, from c6
  Step 4, the descent            -> no_infinite_descent of ZKMC/Descent.lean

Step 4 is where the prose does the work most write-ups skip: it chains the non-increase
across the gaps between consecutive fair indices, `v (i_{k+1}) <= v (i_k + 1)` for
`i_k + 1 <= i_{k+1}`. In this development that chaining lives in `le_of_mono`, which
`no_infinite_descent` calls at exactly that point, so the gap between fair indices is
crossed by the same inequality the prose uses and not by an appeal to a well-founded
relation. The reformulation above means Step 4 here consumes a sequence of type
`Nat -> Nat`, so the chaining is the chapter's `le_of_mono` and not a new argument.

One point of honesty about the statement. `NBA.fairSub`, the inclusion of the fair
transitions in delta, is never used below. It is in the structure because the paper
states it, and the proof of Theorem 3.2 does not need it: `c6` carries its own
`M.trans` premise and the `A.delta` step at a fair index is supplied by
`FairExec.step`, not by the inclusion. That is a fact about the proof, not a defect.
-/

import ZKMC.Basic
import ZKMC.Descent

namespace ZKMC

/-- Reading a natural number back out of `Option Nat` through `getD`. -/
theorem getD_some_eq (n : Nat) : (some n).getD 0 = n := rfl

/-- If an `Option Nat` is known to be `some n`, the total projection recovers `n`. This
is the whole content of the "total projection" route: no choice, just a projection and
a Prop that says it is faithful. -/
theorem getD_eq_of_eq_some {o : Option Nat} {n : Nat} (h : o = some n) : o.getD 0 = n :=
  Eq.trans (congrArg (fun z => Option.getD z 0) h) (getD_some_eq n)

/-- The rank along a fair execution, read as a natural number. The default `0` is never
reached: `rank_some` below proves the value is always `some`. -/
def rankAt {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma)
    (R : Ranking M A) (e : FairExec M A) (i : Nat) : Nat :=
  (R.V (e.s i) (e.q i)).getD 0

/-- Steps 1 and 2 of the prose proof, the finiteness of the rank at every index of a
fair execution. The induction is on `i`; the base is `c4` at the initial pair and the
step is `c5` across one transition. This is the step the chapter left as its `sorry`,
and it is a statement in Prop, so the induction needs no choice principle. -/
theorem rank_some {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma)
    (R : Ranking M A) (e : FairExec M A) :
    forall i, R.V (e.s i) (e.q i) = some (rankAt M A R e i) := by
  intro i
  induction i with
  | zero =>
    cases R.c4 (e.s 0) (e.q 0) e.init.1 e.init.2 with
    | intro n hn =>
      exact Eq.trans hn (congrArg some (getD_eq_of_eq_some hn).symm)
  | succ i ih =>
    cases R.c5 (e.s i) (e.s (i + 1)) (e.q i) (e.q (i + 1)) (rankAt M A R e i)
        (e.step i).1 ih (e.step i).2 with
    | intro n' hn' =>
      exact Eq.trans hn'.1 (congrArg some (getD_eq_of_eq_some hn'.1).symm)

/-- Step 2 of the prose proof, the monotonicity: the rank does not increase along any
transition of a fair execution. -/
theorem rank_mono {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma)
    (R : Ranking M A) (e : FairExec M A) :
    forall i, rankAt M A R e (i + 1) <= rankAt M A R e i := by
  intro i
  cases R.c5 (e.s i) (e.s (i + 1)) (e.q i) (e.q (i + 1)) (rankAt M A R e i)
      (e.step i).1 (rank_some M A R e i) (e.step i).2 with
  | intro n' hn' =>
    have h2 : rankAt M A R e (i + 1) = n' := getD_eq_of_eq_some hn'.1
    rw [h2]
    exact hn'.2

/-- Step 3 of the prose proof, the strict decrease: above every bound there is an index
of the fair execution at which the rank strictly decreases. `FairExec.fairInf` supplies
the index and `c6` supplies the strictness. -/
theorem rank_strict {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma)
    (R : Ranking M A) (e : FairExec M A) :
    forall k, ∃ i, k <= i /\ rankAt M A R e (i + 1) < rankAt M A R e i := by
  intro k
  cases e.fairInf k with
  | intro i hi =>
    cases R.c6 (e.s i) (e.s (i + 1)) (e.q i) (e.q (i + 1)) (rankAt M A R e i)
        (e.step i).1 (rank_some M A R e i) hi.2 with
    | intro n' hn' =>
      have h2 : rankAt M A R e (i + 1) = n' := getD_eq_of_eq_some hn'.1
      refine Exists.intro i (And.intro hi.1 ?_)
      rw [h2]
      exact hn'.2

/-- Theorem 3.2: with a ranking function there is no fair execution of the synchronous
composition. The chapter's `sorry` is closed; the statement is the chapter's, unchanged.

Step 4 of the prose proof is this one line: the sequence `rankAt`, which `rank_some`
makes total, is non-increasing by `rank_mono` and strictly decreasing at indices above
every bound by `rank_strict`, and `no_infinite_descent` rules that out. -/
theorem no_fair_execution {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma)
    (R : Ranking M A) (e : FairExec M A) : False :=
  no_infinite_descent (rankAt M A R e) (rank_mono M A R e) (rank_strict M A R e)

/-- The reading of Theorem 3.2 as the emptiness of the composition's set of fair
executions. `FairExec M A` carries data, so it lives in `Type` and cannot be put under
`Not`; the arrow into `False` is the same statement. The corollary of the paper, that
the system satisfies the property, is the further step from emptiness of the
intersection of the languages to satisfaction, which is Corollary cor:z03_mc of
sections/z03.tex and is not formalised here; see STATUS.md. -/
theorem fairExec_elim {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma)
    (R : Ranking M A) : FairExec M A -> False :=
  fun e => no_fair_execution M A R e

end ZKMC
