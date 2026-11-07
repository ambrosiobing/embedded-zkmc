# Status of this Lean development

Last changed Saturday 7 November 2026.

## The one sentence

**A kernel has read every line of this and accepted it.** `lake build` passes on a clean
checkout in GitHub Actions, pinned to `leanprover/lean4:v4.35.0`, with no Mathlib and no
placeholder proof anywhere. That happened for the first time on Saturday 7 November 2026, in
run 3 of the `lean` workflow, on commit `0ad4af3`:
https://github.com/ambrosiobing/embedded-zkmc/actions/runs/42401534830

## What that does and does not mean

**It means** the proofs elaborate: the statements are well formed, the terms have the types
they claim, and nothing rests on an unproved step. That was not known before, and the two
earlier runs never reached the build at all, both failing on defects in the workflow rather
than in the mathematics.

**It does not mean the theorems say what they should.** Review of this development found one
that compiled and proved nothing, because it assumed its own conclusion. See the known defects
section below. A green build is a check on form, not on meaning, and the second is still done
by reading.

**It does not mean Theorem 3.2 is formalised end to end.** What is proved here is the
ranking-function argument: the three conditions rule out any fair execution of the composition.
The paper's actual conclusion is that the language intersection is empty, and Corollary 3.3
goes from there to the system satisfying its specification. Neither of those steps exists in
this development. See section 4.

## Why the workflow still matters

`.github/workflows/lean.yml` runs `lake build` on every push that touches this directory, and
it refuses a placeholder in any proof position and a Mathlib dependency in the lakefile. Both
patterns are proved against a planted positive before they are trusted, because a check that
cannot fail is not a check.

The run is the claim. Nothing in this directory asks a reader to take the build on trust.

## What is actually claimed

| Claim | Status |
|---|---|
| The proofs are written out in full | Yes, 561 lines across five files |
| There is no `sorry`, `admit`, `sorryAx` or `native_decide` in any proof | Yes. The five occurrences of the word `sorry` are prose, in the header comment of `ZKMC/Theorem32.lean` |
| There is no Mathlib dependency | Yes, by design. Every tactic used is core Lean 4 |
| The toolchain is pinned | Yes, `leanprover/lean4:v4.35.0` |
| A kernel has accepted every line | Yes, run 3 of the `lean` workflow |
| The theorems say what they should | Checked by reading, not by the build. One did not. See below |
| Theorem 3.2 is formalised end to end | **No.** The ranking argument only; two steps remain |

## How this relates to chapter 14

They are two different developments, and a reader who assumes otherwise will think one of them
is lying.

**Chapter 14 of the volume** prints its own listing. That listing carries a `sorry` on
`no_fair_execution`, declares it as an open step, builds against Mathlib, and sets an acceptance
test expecting exactly one `sorry` warning. Every one of those statements is true of the listing
the chapter prints.

**This development** closes that step, by the second of the two routes the chapter's own comment
names: it reformulates the valuation through a total projection, so no choice principle is
needed. That is why there is no `sorry` here and no Mathlib either.

So the chapter is not out of date and this directory is not a correction of it. The chapter
describes a development with a declared gap; this one closes that gap and now compiles. The
chapter's own printed listing has still never been through a kernel, and it carries a separate
defect of its own: it uses a term-level `exists` binder, which Lean 4 does not have, so it
would not parse as printed. Correcting that listing is on the list of work still to do.

## Known defects, found by review and not by a compiler

Review of this development on Saturday 7 November 2026 found one statement that was wrong, and
it has been corrected rather than quietly removed.

**`relE_does_not_imply_disjointness` in `ZKMC/Gaps.lean` proved nothing.** Its earlier form took
the two sets `T` and `B` as parameters, together with a point lying in both, and then discharged
the conclusion that they meet straight from those hypotheses. The conjunct it proved never
mentioned the polynomial, so the statement elaborated and said nothing: assuming two sets meet
and concluding that they meet is not a non-implication. The sets are now existentially
quantified and constructed, which is what a counterexample has to do. The reasoning is recorded
in the docstring beside it.

This is worth stating plainly because it is exactly the class of error that compiling does not
catch. A vacuous theorem builds green. Only reading it finds that.

## What would change this file

1. The workflow goes green on a clean checkout. Then this file names the run and the commit, and
   the volume's "none of this has been checked" wording is rewritten in the past tense the same
   day, naming the toolchain version and the date.
2. The workflow stays red and the errors are understood. Then the development is published with
   each remaining gap marked by a named `sorry`, annotated with the statement, the lemma that
   would discharge it, and the point where the informal proof failed to survive formalisation.

Either is a result. Neither requires anyone to believe anything on the strength of this file.
