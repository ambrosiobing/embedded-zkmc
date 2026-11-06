# Sources

## The paper this volume is built on

Pascal Berrang, Mirco Giacobbe, Jacob Swales and Xiao Yang, *Zero-Knowledge Model
Checking*, arXiv:2605.00487v2, version 1 submitted Friday 1 May 2026 and version 2 on
Tuesday 8 September 2026, read on Friday 6 November 2026. Its code is at
`github.com/aiverification/zkmc`, MIT licensed, a Python encoder with Rust explicit-state
and symbolic back-ends, described by its own authors as an academic implementation and not
production ready.

The volume takes that paper apart. It is not a reimplementation of it and does not claim to
be one: where a chapter states one of the paper's theorems it gives the paper's own number
beside it, and where a chapter proves something itself the proof is written out in full on
the page.

## Where the rest of the reference list is

All 145 entries are in [`chapters/25-appendix.md`](chapters/25-appendix.md), numbered, and
each chapter repeats the subset it cites at its own foot so that a chapter read on its own
is complete. Every entry carries one of two marks:

- **(verified Friday 6 November 2026)** means the page was fetched that day and the version
  number, release date or figure quoted was read from it.
- **(to verify)** means the entry is recorded from a citation rather than from the source,
  and nothing in the volume depends on a number taken from it.

The distinction is kept because a reference list that does not say which of its rows were
opened is a list of things somebody else cited.

## The second edition's input

A design brief of twenty further project sketches, held locally and not published, was the
input to the second edition. Where a sketch resembled an existing chapter it became a
Variants subsection of that chapter; where it did not, it became one of chapters 21 to 24.

Ten of the brief's hardware claims do not hold on the bench this volume describes. Each is
corrected in the chapter where it matters, and the correction is stated rather than made
silently. The two that changed a design rather than a sentence: an accelerometer the brief
builds three projects on is retired here, its header unsoldered and six bus scans empty with
the supply verified at the module's own rows; and a model of eight billion parameters does
not fit on a board with 512 MB, which chapter 22 works out as a lemma.

## Licences of the work this volume leans on

A reader who builds on a chapter and publishes the result needs to know what that commits
them to before writing code around a dependency, so the reference list records a licence
wherever one has been read. Fourteen of the 145 entries do. Three of those record a
licence read from the project itself, MIT for two and GNU GPL version 3 for one; the rest
name the file in which the licence is stated and say plainly that it has not yet been
read. No identifier is guessed, because a guessed licence is worse than an admitted gap
for exactly the reader this paragraph is written for.

This paragraph previously claimed that every entry recorded a licence and named the Llama
community licence and the Gemma terms. Neither appears anywhere in this volume's
reference list; the sentence had travelled from a sibling volume that does carry model
weights. It was corrected on Friday 6 November 2026.

## What is absent, and why that is written down

The bench has no oscilloscope, no logic analyser, no multimeter, no SIM card, no camera, no
fingerprint reader, no fan and no motor. Each chapter that would want one says so, draws it
as an absent block, and states what the absence costs its acceptance test. A figure drawn
dashed is a software stand-in; a figure drawn dotted and grey is a part that is not here.
Neither is ever presented as a measurement.
