# Authoring guide

This file is the contract every chapter of the volume follows. The volume itself is
written in LaTeX in the author's catalogue and is not published; what this repository
carries is the Markdown edition that `publish.py` generates from it. The guide is here
because a reader who wants to judge the chapters should be able to read the rules they
were held to, and because those rules are most of what makes the chapters comparable.

A note on one convention. Figure files take a `z` prefix, as `z07_wiring.svg`, so that a
copied figure cannot silently resolve against another volume's files. That letter is also
used by one sibling volume, which is a collision the author knows about and accepted
rather than renaming ninety-six verified figures: the two trees are separate
repositories and no filename is ambiguous inside either.

---

Written Friday 6 November 2026. The second edition adds a Variants subsection to every
chapter, four chapters, and a companion document; `CHAPTERS_V2.md` carries the brief for
each of those changes and the ten bench corrections that override the design brief it
drew on. Everything below applies to all twenty-four chapters. Read `sections/z01.tex` and its four figures first: they are
the reference for tone, depth, structure, mathematics and figure style. Every chapter must
compile alone with

    python build.py --check sections/zNN.tex

and finish with `== RESULT: CLEAN`. Then `python lint.py sections/zNN.tex figures/zNN_arch.tex
figures/zNN_wiring.tex figures/zNN_tree.tex figures/zNN_data.tex` must report zero problems,
`python datecheck.py sections/zNN.tex` zero problems, and `python check_mermaid_width.py` zero
lines over 74 characters. A label must never sit on top of a symbol or another label: render
every figure and look at it (`build/fig/<name>.svg`, or the PDF `build/check_zNN.pdf` turned
into PNG with pymupdf) before moving on. The linter cannot see this.

The volume is local to the catalogue. Nothing here is pushed anywhere.

---

## What this volume is

Twenty-four embedded hardware and firmware projects, one per chapter, that instantiate the
ideas of one paper on the parts that are on one bench: Berrang, Giacobbe, Swales and Yang, *Zero-Knowledge
Model Checking*, arXiv:2605.00487v2 (cited as `\cite{berrang2026zkmc}`). The paper proves that a
secret state transition system satisfies a public temporal specification without revealing the
system: a certificate (a Büchi automaton for the negated property plus a ranking function) is
public, the system is committed to, and a zero-knowledge proof convinces a verifier that the
commitment and the certificate fit. It gives two schemes: explicit-state (states embedded in a
field, KZG polynomial commitments, batch vanishing proofs) and symbolic (guarded commands,
Farkas witnesses, two-tier Pedersen commitments, zkMatrix, Bulletproofs range proofs, one-shot
folding under a Salem-Spencer exponent schedule).

**The through-line question, instanced at the head of every project:** what can a verifier
learn from a device without the device revealing itself, and what does it cost on this board?
Every project carries a secret, a public statement, the relation between them written in set
notation, the mathematics behind the primitive it uses with at least one theorem or lemma and
its proof, the protocol as a sequence, the code in the project's language, a benchmark whose
every number names its instrument or reads "not measured", and a decision tree that says when
to use this primitive rather than its neighbours.

**The language rule.** Each project is written in one language and says why: C, C++, Rust,
Python, JavaScript, Julia, C#, Go, Zig, Lean 4, Noir, Circom, Swift, Elixir, TinyGo and
WebAssembly appear across the twenty-four and their variants. On a
microcontroller nothing is Python; Python appears only where the paper's own front-end is
Python (the encoder, Z3) or as a host harness. Cite the library version that was read on
Friday 6 November 2026 from `sections/refs.tex` rather than inventing one.

**The model rule** (inherited from the EdgeLLM volume). A language model, where a project uses
one, proposes and never decides: it may propose a ranking function, a guarded-command
translation of a sentence, or write the one-paragraph explanation of a verdict, bounded by a
GBNF grammar whose every rule sits on one line. The certifier or the verifier checks. A wrong
proposal is rejected by the proof and costs completeness, never soundness; say so with the
theorem that makes it true. Models are named from `\cite{hftrending}` and `\cite{lfm3}` (the
trending list read on Friday 6 November 2026) or from the sibling volume's ladder (SmolLM2,
Qwen2.5-0.5B, Qwen2.5-1.5B), with the file size the model card prints or "read it".

**The honesty rule.** In every figure a solid outline is hardware present on the bench, a
dashed outline is a software stand-in (a replayed log, a vcan node, a simulator), a dotted grey
block is absent and explained. Styles: `hw`, `kern`, `user`, `ext`, `fw` (solid, from the
vocabulary); `modelled` (add it for the dashed form); `absentblk` (dotted grey); `prover`
(yellow outline), `verifier` (green outline), `secretblk` (stop-coloured outline: real and
hidden), `publicblk`, `commitblk`, `llm`, `rulebl`. Decision trees use `decision` (a diamond),
`leaf` and `leafno`. Bar charts use `bar` and `barm` with `axis` and `tick`. Never present a
modelled result as a measured one. Every table that carries numbers has a column that says
which instrument produced them, or reads "not measured" with the reason. Nothing in this volume
has been run on the bench yet unless a chapter says which record proves it; a benchmark figure
is the shape the acceptance test expects, drawn dashed, with the paper's own Table 1 figures
as the only measured numbers, each attributed to the paper's AWS c6g.8xlarge and never to a
Pi.

**The mathematics rule.** Definitions, theorems, lemmas and proofs use the amsthm environments
`definition`, `theorem`, `lemma`, `proposition`, `corollary`, `example`, `remark`, `proof`,
each with an optional title and a label of the form `thm:zNN_name`, `def:zNN_name`,
`lem:zNN_name`. Sets are written as sets: `$\{\, s \in S \mid \exists q \in Q_0 .\; V(s,q) =
\infty \,\}$`. Display mathematics goes in `equation`, `align` or `gather` (starred or not);
every step of a derivation is written, nothing is "clearly". Macros available: `\N \Z \F \G
\Zp \Com \Cert \PoK \sysM \autA \Lang \sat \nsat \Prover \Verifier \negl \prob`. Keep every
line of a display under 99 characters. The HTML edition hands the TeX to MathJax, so write
standard amsmath and nothing exotic (no `\intertext`, no `tikzcd` inside math, no `\mathscr`).

**The citation rule.** `\cite{key}` with keys from `sections/refs.tex` only; the linter
refuses any other key and requires at least three citations per chapter. Add a reference to
that file before citing it, with its URL marked `(verified <full date>)` only if the page was
fetched that day, else `(to verify)`. The Sources subsection at the end of each chapter is an
itemize of the chapter's own `\href` links, each with the same mark.

**The date rule.** Every date is weekday, day, month, year, in full, every time: "Friday 6
November 2026". Four forms are refused: a weekday on its own, a month and year with no day, a
day and month and year with no weekday, and an abbreviated month. `datecheck.py` enforces all
four.

**The URL rule.** Every `\href` and `\url` is followed, within the same sentence or table cell,
by `(verified Friday 6 November 2026)` if the page was actually fetched that day, or
`(to verify)` if it was not. Never invent a URL.

**Writing.** No em or en dashes, no `--` in prose, no violent idioms (nothing is killed,
attacked, destroyed, nailed, bulletproof as an adjective in prose; the library name
Bulletproofs is a proper noun and is written in code or as a citation, never as the idiom).
Professional register. Name the kind, not the category. No employer names. No AI or tooling
attribution anywhere. Numbers come from a named record; a round number is a claim.

---

## The bench, settled facts (do not contradict; cite by part)

**Boards.** Raspberry Pi 4 Model B Rev 1.4, 8 GB, Raspberry Pi OS trixie, kernel
6.18.50+rpt-rpi-v8. Raspberry Pi 3 Model B Plus Rev 1.3, 905 MB, 1.4 GHz, soft thermal
limit at 60 C, no fan on the bench. Raspberry Pi 3 Model B Rev 1.2, 1 GB. NanoPi NEO Air (Allwinner
H3, four Cortex-A7, 512 MB, armv7, 8 GB eMMC, no 40-pin header). NUCLEO-H7A3ZI-Q (STM32H7A3ZI,
Cortex-M7 at 280 MHz, 1312 kB SRAM, 2 MB flash, hardware HASH and CRC units, FDCAN on PD0/PD1
through the loose SN65HVD230 board, USB CDC to a host, ST-LINK drive `NOD_H7A3ZIQ`; shared
between volumes, reflash immediately before every capture). SBC-NodeMCU-ESP32 and
SBC-ESP8266-PROG over USB. One laptop runs a Linux subsystem with 8 cores and 24 GB and is
the only machine that compiles; the other authors and never compiles. The hostnames and
addresses of both stay in the author's own notes: a published repository carries the work
and not the shape of the desk it was done on.

**40-pin HATs, one per Pi header at a time.** SIM7600E-H 4G (not seated by any project here;
LTE TX peaks exceed 1 A). SIM7070G Cat-M/NB-IoT/GPRS. SIM7020E NB-IoT. MCC 118 DAQ (8
single-ended, 12-bit, 100 kS/s aggregate, SPI0 CE0, 10 microsecond sample period, spread floor
3.4 microseconds; cannot share SPI0 with the CAN HAT's overlays). JOY-iT RB-Explorer700
(SSD1306 OLED on SPI0, DS3231 at 0x68, BMP280 at 0x76 or 0x77, PCF8591 at 0x48, PCF8574 at
0x20, joystick, IR receiver, buzzer). Waveshare 3.5 inch RPi LCD (A) (480 by 320, ili9486 on
SPI0 CE0, ads7846 touch on CE1; its carrier covers header pins 27 to 40; no stacking header
on the bench). Waveshare WS-28164 isolated RS232, RS485, CAN, CAN FD HAT (Pi 4B only here;
MCP2518FD on SPI0 CE1 interrupt GPIO24 with a 40 MHz crystal; MCP2515 plus SN65HVD230 on
SPI0 CE0 interrupt GPIO23 at 16 MHz; both 120 ohm terminations fitted; proven as a two-node
classic CAN bus on Tuesday 7 October 2026; `can0` and `can1` swap between boots). The
official 7 inch DSI touchscreen and the Raspberry Pi keyboard coexist with any HAT. No SIM
card is on the bench: every cellular measurement reads "not measured, no SIM" until one
arrives.

**Sensors.** X-NUCLEO-IKS4A1 (measured on a Pi I2C bus Wednesday 30 September 2026: 0x1E
LIS2MDL, 0x38 STTS22H, 0x44 SHT40, 0x5d LPS22DF, 0x6a LSM6DSO16IS, 0x6b LSM6DSV16X).
X-NUCLEO-IKS5A1 (measured Tuesday 27 October 2026: 0x19 LIS2DUXS12, 0x1e LIS2MDL, 0x5c
LPS22DF family, 0x6a an IMU with WHO_AM_I 0x73 that no kernel here supports, 0x6b
LSM6DSO16IS). X-NUCLEO-53L8A1 (VL53L8CX 8 by 8; its ULD is licence gated, so it is marked
`learn`). STEVAL-STWINBX1 STWIN.box over USB-C (IIS3DWB 6 kHz vibration, ISM330DHCX, two
microphones). Adafruit VL53L4CD single-zone ToF, I2C at 0x29, 1 to 1300 mm. DFRobot SEN0032
ADXL345: its header is unsoldered and the part is retired from every plan since Saturday 24
October 2026; do not plan around it. The three X-NUCLEO shields fit the Nucleo's Arduino
header one at a time or go to a Pi on flying leads. Four Joy-it LEDs (blue, green, yellow,
red; anode on the signal pin, drive high; measured on BCM 17, 27, 22 on Saturday 3 October
2026). Renkforce USB/TTL cable. SBC-POW-BB breadboard supply, jumpers, breadboard. Verbatim
32 GB microSD cards.

**Instruments.** nRF PPK2 (source meter 0.8 to 5.0 V up to about 1 A, or ampere meter; it
cannot power or meter a Raspberry Pi under load; it can meter the Nucleo, an ESP32, or an
NB-IoT module). MCC 118 as a timing witness through a GPIO marker. NO multimeter, NO
oscilloscope, NO logic analyser, NO soldering iron, NO stacking header, NO Pi 5, NO fan, NO SIM.

**Pi throttling.** Before and after any timing run `vcgencmd get_throttled` must read `0x0`;
the Pi 3B+ trips its soft limit in about four minutes of sustained load, so any benchmark on it
that runs longer is "not measured, thermal" until a heatsink is bought.

---

## What a project chapter contains, in order (the linter enforces the order)

1. `\project{NN}{Title}{Board and parts}{Language}` then `\begin{question}` instanced.
2. `\begin{keyfacts}` with items Board, Parts, Interface, Language and library (with version),
   Primitive (which part of the paper), Secret, Public, Model (or none), Acceptance, Difficulty
   (n of 5), Effort.
3. `\subsection*{Pitch}`: one paragraph, what is proved to whom and why it matters here.
4. `\subsection*{Parts and interface}`: a longtable Part, Role, Interface, Address or pin.
5. `\subsection*{The secret, the statement and the relation}`: the witness $w$, the statement
   $u$, the relation $\mathcal{R}$ written as a set, with the specific sets of this project.
6. `\subsection*{The mathematics}`: at least one definition, at least one theorem or lemma, at
   least one proof, every step shown. Where the paper's own equations are used, number them in
   this volume and say which equation of the paper they are.
7. `\subsection*{The protocol}`: the prover and verifier algorithms as numbered steps or as a
   two-column longtable in the style of the paper's Figure 3.
8. `\subsection*{The code}`: 30 to 90 lines in the project's language, in the matching
   listing environment (`ccode`, `cppcode`, `rustcode`, `pycode`, `jscode`, `juliacode`,
   `cscode`, `gocode`, `zigcode`, `leancode`, `noircode`, `circomcode`), ASCII only, under 99
   columns, with a build or run line in `shellcode`.
9. `\subsection*{The model, if any}`: the model, its rung, the grammar verbatim in `gbnfcode`
   (every rule on one line), the control rule it is checked against, and the theorem that
   says a wrong proposal cannot cost soundness. "None" is an allowed answer with one sentence.
10. `\subsection*{Real, modelled, absent}`: three itemize bullets with `\have`, `\learn`,
    `\absent`.
11. `\subsection*{System architecture}`: `\figblock{zNN_arch}{...}` with the full caption.
12. `\subsection*{Wiring}`: `\figblock{zNN_wiring}{...}` naming every pin, plus a pin table.
13. `\subsection*{Sequence and states}`: two `mermaid` blocks, a `sequenceDiagram` and a
    `stateDiagram-v2`, every line under 74 characters.
14. `\subsection*{Decision tree}`: `\figblock{zNN_tree}{...}` with diamonds and leaves.
15. `\subsection*{Benchmark}`: `\figblock{zNN_data}{...}` a bar or line figure of the expected
    shape (dashed, modelled) or of the paper's Table 1 numbers (solid, attributed), plus a
    longtable with an Instrument column.
16. `\subsection*{Steps}`: a `steps` environment, each step saying which machine it runs on
    (the authoring laptop, which never compiles; the build laptop's Linux subsystem; the
    board over ssh; the microcontroller over its debug drive and its serial console).
17. `\subsection*{Acceptance test}`: written so that it can fail, with numbers.
18. `\subsection*{Variants}`: one or two named alternative realisations, three to eight
    sentences each. What is swapped, what it costs or buys with an arithmetic figure marked
    computed where one exists, the one sentence saying when to choose it, and where it comes
    from. A variant gets no figure, no theorem and no listing longer than ten lines; if it
    needs more, it is a chapter. A variant is never reported as having been run.
19. `\subsection*{Pitfalls}`.
20. `\subsection*{Languages and libraries not chosen}`: one line each with the delta.
21. `\subsection*{Sources}`: itemize of the chapter's `\href` links with marks.

Figures: `figures/zNN_arch.tex`, `figures/zNN_wiring.tex`, `figures/zNN_tree.tex`,
`figures/zNN_data.tex`, each one `tikzpicture`, no `tikzpicture` inline in a section, no
`figure` or `table` floats, no `\footnote`, no `\includegraphics`, no patterns, shadings,
opacity or drop shadows (dvisvgm cannot render them), no bare `fill=white` or `fill=black`.
A node with a pale fill must carry black text through a `blk`-derived style. Never use `out`,
`step`, `in`, `at`, `to`, `node`, `draw`, `fill`, `label`, `pin` as a style name.
