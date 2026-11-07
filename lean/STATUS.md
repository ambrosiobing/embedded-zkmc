# Status of this Lean development

Last changed Saturday 7 November 2026.

## The one sentence

**Nothing here has been compiled.** The mathematics is written out in full, there is no `sorry`
anywhere in it, and no kernel has ever read a line of it. Those three statements are all true at
once, and the third is the one that matters.

## Why there is a workflow that fails

`.github/workflows/lean.yml` runs `lake build` on this directory on every push that touches it.
**It is expected to fail today, and its failures are the point.** Lean 4 is installed on neither
machine this volume is written on, which is recorded in the volume itself, so the first kernel to
read this development is the one in that workflow.

A red run here is not neglect. It is the only honest way to publish a development in this state:
the error count is a measurement, anyone can read it, and it falls as the work is done. The
alternative, holding the development back until it is green, would mean asking a reader to take
on trust both that it exists and that it is nearly right.

When the run goes green, this file says so and names the run.

## What is actually claimed

| Claim | Status |
|---|---|
| The proofs are written out in full | Yes, 561 lines across five files |
| There is no `sorry`, `admit`, `sorryAx` or `native_decide` in any proof | Yes. The five occurrences of the word `sorry` are prose, in the header comment of `ZKMC/Theorem32.lean` |
| There is no Mathlib dependency | Yes, by design. Every tactic used is core Lean 4 |
| The toolchain is pinned | Yes, `leanprover/lean4:v4.35.0` |
| A kernel has checked any of it | **No** |
| It builds | **Unknown, and that is what the workflow is for** |

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
describes a development with a declared gap; this is a development that closes the gap and has
never been compiled. Neither is checked. Until the workflow goes green, the honest description
of both is "written out, not checked".

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
