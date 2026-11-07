/-
ZKMC/Basic.lean: the four structures of chapter 14, carried over from sections/z14.tex.

NOT COMPILED. Written Friday 6 November 2026 on a machine with no Lean toolchain
installed. Nothing here has been elaborated, built or kernel checked.

The field names are exactly those of the listing in sections/z14.tex, so that the
chapter and this project name the same things: TS.init, TS.trans, TS.obs; NBA.init,
NBA.delta, NBA.fair, NBA.fairSub; FairExec.s, FairExec.q, FairExec.init,
FairExec.step, FairExec.fairInf; Ranking.V, Ranking.c4, Ranking.c5, Ranking.c6.

One notation change from the chapter. The chapter writes the existential quantifier
in ASCII as `exists`. That spelling could not be confirmed without a toolchain, so
the Unicode spelling is used here, which is certain. Everything else keeps the
chapter's ASCII: `forall`, `->`, `<=`, `<`, `/\`, `\/`. Recorded in OPEN.md.
-/

namespace ZKMC

/-- A state transition system over states `S`, observed in the alphabet `Sigma`.
Definition def:z14_ts of the chapter: `init` is the set of initial states as a
predicate, `trans` the transition relation, `obs` the observation function. -/
structure TS (S Sigma : Type) where
  init : S -> Prop
  trans : S -> S -> Prop
  obs : S -> Sigma

/-- A nondeterministic Buechi automaton whose fair transitions are a subset of delta.
Definition def:z14_nba of the chapter. The field `fairSub` is the inclusion `F` is a
subset of `delta`, which the paper states and which the proof of Theorem 3.2 does not
in fact use: see the remark in ZKMC/Theorem32.lean. -/
structure NBA (Q Sigma : Type) where
  init : Q -> Prop
  delta : Q -> Sigma -> Q -> Prop
  fair : Q -> Sigma -> Q -> Prop
  fairSub : forall q a q', fair q a q' -> delta q a q'

/-- A fair execution of the synchronous composition: conditions (i), (ii) and (iii) of
Definition def:z14_fair. Condition (iii), that the set of fair indices is infinite, is
written as the equivalent statement that above every bound there is a fair index. -/
structure FairExec {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma) where
  s : Nat -> S
  q : Nat -> Q
  init : M.init (s 0) /\ A.init (q 0)
  step : forall i, M.trans (s i) (s (i + 1)) /\ A.delta (q i) (M.obs (s i)) (q (i + 1))
  fairInf : forall k, ∃ i, k <= i /\ A.fair (q i) (M.obs (s i)) (q (i + 1))

/-- A ranking function; `none` stands for infinity; the paper's Equations (4), (5) and
(6), which are eq:z14_c4, eq:z14_c5 and eq:z14_c6 of the chapter.

The premise `V s q = some n` is the chapter's `V (s, q) <> infinity` read as naming the
finite value, and the conclusion names a finite value `n'` on the other side, which is
how Definition def:z14_ranking says the comparison is to be read: between two natural
numbers, not between a natural number and a symbol. -/
structure Ranking {S Q Sigma : Type} (M : TS S Sigma) (A : NBA Q Sigma) where
  V : S -> Q -> Option Nat
  c4 : forall s q, M.init s -> A.init q -> ∃ n, V s q = some n
  c5 : forall s s' q q' n, M.trans s s' -> V s q = some n -> A.delta q (M.obs s) q' ->
    ∃ n', V s' q' = some n' /\ n' <= n
  c6 : forall s s' q q' n, M.trans s s' -> V s q = some n -> A.fair q (M.obs s) q' ->
    ∃ n', V s' q' = some n' /\ n' < n

end ZKMC
