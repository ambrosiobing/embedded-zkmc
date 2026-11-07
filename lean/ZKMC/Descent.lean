/-
ZKMC/Descent.lean: le_of_mono and no_infinite_descent, Lemma lem:z14_descent of
sections/z14.tex.

NOT COMPILED. Written Friday 6 November 2026 on a machine with no Lean toolchain
installed. Nothing here has been elaborated, built or kernel checked.

The statements are the chapter's, unchanged. One proof script differs from the
chapter's listing, and the reason is recorded here and in OPEN.md.

  The chapter proves `le_of_mono` by `induction b` with `rcases Nat.lt_or_eq_of_le hab
  with h | h`. `rcases` is a Mathlib tactic, not a core Lean 4 tactic, and this project
  carries no Mathlib dependency. The script below proves the same statement from a
  helper that inducts on the difference `d` in `b = a + d`, which needs only core
  `induction`, `rw` and `omega`. It is the same argument: non-increase at every step
  composes along an interval.

`no_infinite_descent` keeps the chapter's script line for line, with `cases ... with |
intro ... =>` where the chapter writes the same thing, and with `omega` at exactly the
two places the prose says "chaining the three inequalities" and "no natural number
satisfies this".
-/

namespace ZKMC

/-- Non-increasing at every step gives non-increasing along an interval of any length.
This is the auxiliary fact of the chapter's proof, stated with the interval written as
`a + d` so that the induction is on the length of the interval. -/
theorem le_of_add (n : Nat -> Nat) (mono : forall i, n (i + 1) <= n i) :
    forall a d, n (a + d) <= n a := by
  intro a d
  induction d with
  | zero => exact Nat.le_refl (n a)
  | succ d ih => exact Nat.le_trans (mono (a + d)) ih

/-- Non-increasing at every step gives non-increasing over every interval. The
auxiliary fact of the chapter's proof of Lemma lem:z14_descent, in the form the lemma
uses it. -/
theorem le_of_mono (n : Nat -> Nat) (mono : forall i, n (i + 1) <= n i) :
    forall a b, a <= b -> n b <= n a := by
  intro a b hab
  have h := le_of_add n mono a (b - a)
  have heq : a + (b - a) = b := by omega
  rw [heq] at h
  exact h

/-- Lemma lem:z14_descent: no sequence in Nat is non-increasing and strictly decreasing
infinitely often. The infinitely-often hypothesis is written as the equivalent statement
that above every bound `k` there is an index `i` at which the sequence strictly
decreases.

The proof is the chapter's counting argument, not well-founded recursion. `key` says
that after `j` strict decreases there is an index whose value plus `j` is still at most
`n 0`; taking `j = n 0 + 1` is the contradiction, and it is the well-foundedness of Nat
in the only form the argument needs, namely that no natural number is below zero. -/
theorem no_infinite_descent (n : Nat -> Nat)
    (mono : forall i, n (i + 1) <= n i)
    (inf : forall k, ∃ i, k <= i /\ n (i + 1) < n i) : False := by
  have key : forall j, ∃ i, n i + j <= n 0 := by
    intro j
    induction j with
    | zero => exact Exists.intro 0 (by omega)
    | succ j ih =>
      cases ih with
      | intro i hi =>
        cases inf i with
        | intro i' hi' =>
          have hle : n i' <= n i := le_of_mono n mono i i' hi'.1
          have hdec : n (i' + 1) < n i' := hi'.2
          -- the chaining of the prose: n (i' + 1) + 1 <= n i' <= n i <= n 0 - j
          exact Exists.intro (i' + 1) (by omega)
  cases key (n 0 + 1) with
  | intro i hi =>
    -- hi reads n i + n 0 + 1 <= n 0, that is n i + 1 <= 0
    omega

end ZKMC
