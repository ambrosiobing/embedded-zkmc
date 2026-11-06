# Zero Knowledge on the Bench

*twenty-four embedded projects that prove without revealing*

Twenty-four projects that take one paper apart into the primitives it is built from and put
each one on hardware that is already on one bench: three Raspberry Pis, a NanoPi, a
NUCLEO-H7A3ZI-Q, an ESP32, an ESP8266, three cellular HATs, a CAN and RS485 HAT, a DAQ HAT,
two ST sensor shields, an STWIN.box, a time-of-flight sensor, a display and four LEDs. The
paper is Berrang, Giacobbe, Swales and Yang, *Zero-Knowledge Model Checking*,
arXiv:2605.00487v2. Nothing here needs to be bought.

**24 chapters, 99 figures, 156 numbered statements, 67 proofs.** The statements are the theorems, lemmas, corollaries, propositions, definitions, examples and remarks, counted across the chapter sources on Friday 6 November 2026; the figures are four per chapter plus three in the companion. Each chapter stands on its
own: it names a secret, a public statement and the relation between them as a set, proves
the property of the primitive it uses with every step written, gives the protocol, shows the
code, and prices it on the board with an instrument that is named.

**Read it.** The whole volume is in [`chapters/`](chapters/) as Markdown with its figures
beside it. Start with
[About this volume](chapters/00-about-this-volume.md), or take a chapter from the table
below.

**Or start further back.** [`docs/`](docs/) is the companion, which assumes nothing: the
[prerequisites](docs/prerequisites.md), the [foundations](docs/foundations.md) from a state
machine to a proof, a [tutorial](docs/tutorial.md) that runs one proof end to end by hand,
and a [guide](docs/guide.md) to all twenty-four projects.

There is deliberately no assembled volume to download. The PDF and the single-file HTML are
the author's proofreading editions and stay on the authoring machine; what this repository
offers is one chapter at a time.

**Contents**
[Read it](chapters/) &nbsp;·&nbsp;
[The through-line](#the-through-line) &nbsp;·&nbsp;
[The twenty-four chapters](#the-twenty-four-chapters) &nbsp;·&nbsp;
[The companion](#the-companion) &nbsp;·&nbsp;
[What is not claimed](#what-is-not-claimed) &nbsp;·&nbsp;
[Checks](#checks) &nbsp;·&nbsp;
[Layout](#repository-layout) &nbsp;·&nbsp;
[Requirements](#requirements) &nbsp;·&nbsp;
[Licence](#licence)

## The through-line

One question runs through the volume and is instanced at the head of every chapter:

> What can a verifier learn from a device without the device revealing itself, and what does
> it cost on this board?

A state transition system is secret. A temporal specification is public. The owner wants to
convince a verifier that the system satisfies the specification without revealing the
system. The paper's answer has three parts: a public certificate that is checkable in
polynomial time, a commitment that hides the system and binds the prover to it, and a
zero-knowledge proof that the committed system satisfies the certificate's conditions. Two
schemes realise it, an explicit-state one built on polynomial commitments and a symbolic one
built on Farkas witnesses and folding, and the chapters take them apart one primitive at a
time.

## The twenty-four chapters

| # | Chapter | Language | Board |
|---|---|---|---|
| 1 | [The price list: field, group and pairing arithmetic on every board](chapters/01-the-price-list.md) | Rust | all four |
| 2 | [A sensor reading committed on the microcontroller](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) | Rust | Nucleo, IKS4A1 |
| 3 | [The modem's backoff machine, proved live-free in zero knowledge](chapters/03-the-modems-backoff-machine.md) | Python | Pi 4B, SIM7020E |
| 4 | [Two group elements: the KZG batch verifier in C](chapters/04-two-group-elements.md) | C | Pi 4B, Pi 3B |
| 5 | [Farkas witnesses for a joystick program](chapters/05-farkas-witnesses-for-a-joystick-program.md) | Rust | Pi 4B, Explorer700 |
| 6 | [Folding and the Salem-Spencer schedule, computed exactly](chapters/06-folding-and-the-salem-spencer-schedule.md) | Julia | Pi 4B, STWIN.box |
| 7 | [The ESP32 proves one secret behind two public points: Chaum-Pedersen on P-256](chapters/07-the-esp32-proves-one-secret-behind-two-public.md) | C# and C | Pi 4B, ESP32 |
| 8 | [A ranking function as a circuit, verified in a kiosk browser](chapters/08-a-ranking-function-as-a-circuit.md) | JavaScript, Circom | Pi 4B, touchscreen |
| 9 | [Nova versus one-shot folding on a Pi](chapters/09-nova-versus-one-shot-folding-on-a-pi.md) | Rust | Pi 4B |
| 10 | [The hardware hash unit commits to a transition log](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) | C | Nucleo, IKS5A1 |
| 11 | [The prover's cost: multi-scalar multiplication and FFT on two Pis](chapters/11-the-provers-cost.md) | C++ | Pi 4B, Pi 3B+ |
| 12 | [A PLONK gate for the inductive step, verified on the NanoPi](chapters/12-a-plonk-gate-for-the-inductive-step.md) | Go | NanoPi, Pi 4B |
| 13 | [The obligation in Noir, proved with UltraHonk](chapters/13-the-obligation-in-noir.md) | Noir | Pi 4B |
| 14 | [Theorem 3.2 in Lean 4: the ranking-function rule and the descent lemma it rests on](chapters/14-theorem-3-2-in-lean-4.md) | Lean 4 | Pi 4B |
| 15 | [A Zig verifier of Pedersen openings for the Pi 3B+](chapters/15-a-zig-verifier-of-pedersen-openings.md) | Zig | Pi 3B+, Nucleo |
| 16 | [The model proposes a ranking function; the certifier decides](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) | Python and C | Pi 4B |
| 17 | [From a sentence to a Büchi automaton with Spot](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) | C++ | Pi 4B |
| 18 | [A proof over the wire: KZG elements in CAN frames](chapters/18-a-proof-over-the-wire.md) | C | Pi 4B, WS-28164, Nucleo |
| 19 | [A commitment over NB-IoT and the energy per proof byte](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) | C | Pi 4B, SIM7070G, PPK2 |
| 20 | [The occupancy counter that proves its committed count is under the limit](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) | Rust | Pi 4B, VL53L4CD, LCD |
| 21 | [A zero-knowledge virtual machine on the bench](chapters/21-a-zero-knowledge-virtual-machine-on-the-bench.md) | Rust | Pi 4B |
| 22 | [Embedded Swift on the microcontroller](chapters/22-embedded-swift-on-the-microcontroller.md) | Embedded Swift | Nucleo, IKS4A1, LCD |
| 23 | [Elixir and Nerves: the CAN node on the Erlang virtual machine](chapters/23-elixir-and-nerves.md) | Elixir and Rust | Pi 4B, WS-28164 |
| 24 | [A one-bit model: ternary weights on the Pi](chapters/24-a-one-bit-model.md) | C and Python | Pi 4B, LCD, LEDs |

[`CONTENTS.md`](CONTENTS.md) is the generated version of this table, and
[`PITFALLS.md`](PITFALLS.md) indexes all 152 pitfalls across the chapters.

Four chapters are worth reading as a set. Chapter 1 is the price list and every later cost
claim is a count of operations multiplied by one of its numbers. Chapters 3, 4 and 18 are
the explicit-state pipeline, from encoding through verification to carrying a 192-byte proof
over a CAN bus. Chapters 5, 6, 9 and 16 are the symbolic one. Chapters 4, 13 and 21 prove
one statement three ways, as a tailored protocol, as a domain-specific circuit and as a
program inside a zero-knowledge virtual machine, which is the one comparison here worth
having.

## The companion

[`docs/prerequisites.md`](docs/prerequisites.md) says what a reader must know and must have,
with a self-check. [`docs/foundations.md`](docs/foundations.md) runs once from a state
machine to a proof. [`docs/tutorial.md`](docs/tutorial.md) works one proof end to end on a
four-state machine, computes its three violation sets by hand, and then introduces a
deliberate error so that the verifier can be seen refusing it.
[`docs/guide.md`](docs/guide.md) gives one page per chapter: what it assumes, the one idea,
what to read first, the trap, and its acceptance test.

## What is not claimed

**Nothing here has been run on this bench.** Every timing and every agreement rate reads
"not measured" and names the instrument that would fill it and the reason it is empty. The
only measured timings in the volume are the source paper's own, and they are attributed to
the paper's machine, a 32-core AWS instance, never to a board here. A number this volume
derives says "computed" and shows its arithmetic.

No chapter claims a scheme is secure beyond what its cited paper proves. Where a theorem is
stated it is either the paper's with its number, a textbook result with its citation, or a
short lemma proved in full on the page. No chapter claims that a language model contributes
soundness: a model appears in four chapters, it proposes and never decides, and each of
those chapters carries the theorem saying a wrong proposal cannot cost soundness. Where a
chapter uses a trusted setup it says so and marks the ceremony as something this bench
cannot run.

## Where a proof assistant is used

Lean 4 appears wherever the volume states something a machine could check rather than
something a board could measure. **None of it has been checked.** Lean is not installed on
either machine on this bench, so what follows is a proof written in a language a machine
can check, and not a proof a machine has checked. The chapter says so in its own key facts,
and this section says so because a reader scanning a contents list will not read them.

| Where | What Lean carries there |
| --- | --- |
| [Project 14](chapters/14-theorem-3-2-in-lean-4.md) | The whole chapter. The paper's Theorem 3.2, the fair-termination rule, written as four structures, a descent lemma and the rule itself. This is the only chapter whose language is Lean. |
| [Project 13](chapters/13-the-obligation-in-noir.md) | Named among the languages not chosen, as the route that would prove the program implies the obligation rather than proving one instance of it. |
| [Project 16](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) | Cites Project 14 for the rule the certifier relies on, and names a checked proof of the certifier's own soundness as the step after this one. |
| [Project 17](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) | Cites Project 14 for the machine-readable statement of the conclusion its automaton feeds. |
| [Foundations](docs/foundations.md) | Explains that the volume carries the fair-termination proof twice, once as prose and once for a proof assistant, and why the second form has to name its induction. |
| [Prerequisites](docs/prerequisites.md) | Lists Lean 4 among the tools, with what a reader needs to know before Project 14. |
| [Tutorial](docs/tutorial.md) | Names the kernel verdict as the thing Project 14 is to reproduce. |
| [Guide](docs/guide.md) | The one-page summary of Project 14. |

**What would change this section.** A Lean development for the volume exists outside this
repository, in the author's working tree. It closes the step Project 14 leaves open and
formalises two counterexamples found in review, so that a relation failing to imply its
conclusion becomes a fact a kernel confirms rather than a claim a reader is asked to
accept. It is published here only if and when it compiles, and this section is rewritten
in the past tense on the same day and not before.

## Checks

The workflow reads the published tree, which is all a clone contains: the authoring sources
are not here, so the checks that compare this Markdown against the LaTeX it came from run on
the authoring machine instead.

    python tools/check_links.py          every relative link resolves
    python tools/check_tree.py           the file types, and nothing over four megabytes
    python tools/no_authoring_files.py   no .tex, .pdf, .html, tracked or not

The workflow adds three guards that have each been needed in a sibling repository: no
authoring source, no assembled volume or PDF, no journal or correspondence. It also asserts
the shape of the edition, one chapter file and four figures for each of the twenty-four,
because a chapter that fails to render leaves no error behind in a Markdown build. It simply
is not there, and the index that lists it still links to it.

Install the hooks once per clone, which is the same check before the commit rather than
after the push:

    sh tools/install-hooks.sh

## Repository layout

| Path | What it is |
|---|---|
| `chapters/NN-title.md` | the volume, one file per chapter, 00 to 25. Written only by the catalogue's `publish.py` |
| `docs/*.md` | the companion: prerequisites, foundations, tutorial, guide |
| `figures/NAME.svg` | every figure rendered, committed because the Markdown draws nothing without them. The TikZ source is not published |
| `CONTENTS.md` | the chapter table, generated, which the table above follows |
| `PITFALLS.md` | every pitfall in the volume, generated, alphabetical across chapters |
| `tools/` | the three guards and the hook installer |
| `.githooks/` | the pre-commit and commit-message hooks, installed per clone |

Figure files carry a `z` prefix, as `z07_wiring.svg`, so that a copied figure cannot
silently resolve against another volume's files.

## Requirements

Nothing, to read it. GitHub renders the Markdown, the figures are SVG, and the mathematics
is written so that the host typesets it. To run the three checks, Python 3.10 or newer and
no package outside the standard library.

## Licence

MIT, see [`LICENSE`](LICENSE). The volume leans on a great deal of other people's work:
every chapter ends with its own numbered reference list, and the appendix carries all 145
entries. Of those, 38 carry a date on which the page was fetched and the figure read from
it, 106 read "to verify" and are recorded from a citation rather than from the source, and
one carries neither and should. Fourteen entries record the licence of the implementation
they name; the rest say that the licence has not been read, because a reader who builds on
a chapter needs to know what that commits them to, and a guessed identifier is worse than
an admitted gap.
