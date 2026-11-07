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

## Where this volume came from

This volume did not start from a blank page. It is the fourth bench volume in a family,
and it is built on what the earlier ones settled.

**The bench is the author's, and every part in it was already there.** Three Raspberry Pis,
a NanoPi NEO Air, a NUCLEO-H7A3ZI-Q, an ESP32 and an ESP8266, three cellular HATs, a CAN
and RS485 HAT, an MCC 118 DAQ HAT, two ST sensor shields, an STWIN.box, a time-of-flight
sensor, a display and four LEDs. Nothing was bought for this volume, and the front matter
says so. The inventory is kept as a dated bench record, and a part that is not in it is
drawn dotted and grey wherever a chapter would want it.

**The measurement method descends from the firmware volume.** Project 6 of
[`firmware-nucleo-h7`](https://github.com/ambrosiobing/firmware-nucleo-h7), sampling on a
timer at exactly 1 kHz, established the method this volume uses in nine chapters: the
Nucleo's cycle counter is never trusted alone, and an MCC 118 on a Raspberry Pi watches a
marker pin as an external witness. That HAT has been stacked on the Pi 4B since Friday 9
October 2026, and the powering order, the wiring and the library versions are that
project's. Chapter 10 builds against the firmware volume's toolchain and HAL tree.

**The sensor and the model descend from the Edge LLM volume.** The VL53L4CD time-of-flight
sensor, its I2C address and its known behaviour at close range come from
[`edge-llm-pi`](https://github.com/ambrosiobing/edge-llm-pi), as does the ternary model that
chapter 24 is built on and the thermal record of the Pi 3B+ that the front matter cites.
Six chapters here lean on that work.

**The mathematics is written for a proof assistant, and one of the two developments is now
checked.** Chapter 14 carries the paper's Theorem 3.2 as a Lean 4 development, and the
repository carries a second one at [`lean/`](lean/) that closes the step the chapter leaves
open. The second builds: `lake build` passes on a clean checkout under continuous integration,
so a kernel has accepted every declaration in it. The listing printed inside the chapter is the
other development, declares one gap with a `sorry`, and no kernel has read it.

Lean is installed on neither machine on this bench, so the only kernel that has run is the one
in the runner, and a passing build says the proofs elaborate rather than that they state what
they should. [`lean/STATUS.md`](lean/STATUS.md) says which development is which and records one
theorem that compiled and proved nothing.

**The hardware testing is the author's, and it is still to come.** Every chapter ends with
an acceptance test written so that it can fail, naming the board, the instrument, the
repeat count and the conditions a measurement must carry. Those tests are run on the bench
described above, by its owner, and until one has been, its cells read "not measured" with
the reason.

