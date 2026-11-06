# Zero knowledge on the bench

*twenty-four embedded projects that prove without revealing*

Joseph Ambrose Pagaran. Friday 6 November 2026.

> The PDF and the HTML of this volume stay with the author. This Markdown edition is the published form, one chapter at a time, and there is deliberately no assembled volume to download. Start here, or with the [companion](../docs/prerequisites.md), which assumes nothing.

## How to read this document

### The question behind all twenty-four

One question runs through the volume and is instanced at the head of every project:

> [!NOTE]
> **The through-line**
>
> What can a verifier learn from a device without the device revealing itself, and what does it cost on this board?

Two words in that question are borrowed from cryptography rather than from ordinary English, and the volume uses them on every page. The **prover** is the side that holds something private and wants to be believed; here it is almost always a board with a sensor on it. The **verifier** is the side that will not take the prover's word for it and checks a proof instead; here it is almost always a Raspberry Pi on the same desk. Neither word implies trust in either direction. That is the whole point: the verifier ends up knowing that the statement is true, knowing nothing else, and having had to trust nothing.

Every project therefore names a secret, a public statement, and the relation between them as a set; proves the property of the primitive it uses, with every step written; gives the protocol as a sequence; shows the code; and prices it on the board with an instrument that is named. A project where the honest answer is "this does not fit on this board" is a valid result and is written as one, with the arithmetic that says why.

### The paper in one page

In words first, because the notation that follows is the paper's and is not an introduction to it.

Somebody owns a piece of control logic and will not show it to anybody. Somebody else has a rule the logic must obey, and that rule is public. The owner wants to be believed about the rule without showing the logic. The paper's answer splits the job in three. First the owner publishes a **certificate**: a short public object which, if the logic really does obey the rule, can be checked cheaply against the logic without the checker ever seeing the logic. Second the owner publishes a **commitment**: a short value that pins the logic down, so that the owner cannot quietly swap in a different one halfway through, and which reveals nothing about what it pins. Third the owner publishes a proof that the pinned-down logic and the public certificate fit together. Everything hard in the paper is in that third step, and the two schemes named below are two ways of doing it.

The rest of this page is that construction in the paper's own symbols. A reader who has not met them should read the companion's foundations first and come back; the symbols are here so that a reader who knows the field can check the volume against its source in one page, and they are not the volume's way in.

A state transition system $`\mathcal{M} = (S, S_0, T, \langle\!\langle \cdot \rangle\!\rangle)`$ is secret. A temporal specification $`\phi`$ over atomic propositions $`\Pi`$ is public. The owner wants to convince a verifier that $`\mathcal{M} \models \phi`$, that is $`\mathcal{L}_\mathcal{M} \subseteq \mathcal{L}_\phi`$, without revealing $`S_0`$ or $`T`$. The paper's answer has three parts \[[1](#references)\]:

1. A **certificate** that is public and checkable in polynomial time: a nondeterministic Buchi automaton $`\mathcal{A}_{\neg\phi}`$ for the complementary specification and a ranking function $`V : S \times Q \to \mathbb{N} \cup \{+\infty\}`$ for the fair termination of the synchronous composition. Theorem 3.2 of the paper says that if $`V`$ satisfies three conditions (finite on initial states, non-increasing on every transition, strictly decreasing on fair transitions), then $`\mathcal{L}_\mathcal{M} \cap \mathcal{L}_{\mathcal{A}} = \emptyset`$. The three conditions each have a secret premise ($`s \in S_0`$ or $`(s, s') \in T`$) and a public consequent.
2. A **commitment** $`c_\mathcal{M} = \mathsf{Com}(\mathsf{sp}, \mathcal{M}; r)`$ that hides the system and binds the prover to it.
3. A zero-knowledge proof that the committed system satisfies the three conditions against the public certificate. Two schemes realise it. The **explicit-state** scheme embeds states into a field, encodes $`S_0`$ and $`T`$ as polynomials $`p_{S_0}`$ and $`p_T`$ that are indicator functions on the embedded sets, commits to them with KZG, and proves by batch opening that the polynomials vanish on the public batches of violating states $`E_{\mathrm{init}}, E_{\mathrm{step}}, E_{\mathrm{fair}}`$: two group elements of proof regardless of $`|S|`$. The **symbolic** scheme takes systems as linear guarded commands, turns each obligation into the unsatisfiability of a linear system, applies Farkas’ lemma to get a witness $`(\lambda, \mu)`$, commits to the secret matrices with two-tier Pedersen commitments, proves the matrix products with zkMatrix, the equalities with a Chaum-Pedersen sub-protocol and the ranges with Bulletproofs, and folds all $`N`$ obligations into one instance under an exponent schedule that is a Salem-Spencer set.

The paper's Table 1 reports the explicit-state scheme verifying up to about $`2^{12}`$ states and the symbolic scheme up to about $`2^{21}`$ states and $`2^{13.7}`$ obligations within two hours on an AWS `c6g.8xlarge`. This volume asks what each piece costs on a Raspberry Pi and a microcontroller, and what a device can prove about itself with it.

### The three marks

Three words carry a judgement throughout, and the colour never carries it alone:

- **have:** something that is on the bench, built, or measured, with the record named.
- **learn:** something that would have to be learned or verified before the chapter's run, with an estimate of how much.
- **absent:** something that is not on the bench, with what the absence costs.

### What a project chapter contains

Each of the twenty-four chapters follows one skeleton, enforced by the linter: the question instanced; a key-facts box; the pitch; the parts and their interfaces; the secret, the statement and the relation as a set; the mathematics with at least one theorem and its proof; the protocol; the code in the project's language; the model, if any, with its grammar and the theorem that says a wrong proposal cannot cost soundness; the three honesty bullets; four figures (system architecture, wiring, decision tree, benchmark) and two Mermaid diagrams (sequence, states); the steps, each naming the machine it runs on; the acceptance test, written so that it can fail; the variants, which are the alternative realisations worth naming but not worth a chapter of their own; the pitfalls; the languages not chosen; and the sources.

That skeleton is dense on purpose and it assumes the vocabulary throughout. For a measure of how much, the key-facts box of [Project 2](02-a-sensor-reading-committed-on-the-microcontroller.md) names a processor clock rate, a bus address of 0x6b, five named libraries of which four are pinned to a version, two elliptic-curve groups and the reason for choosing between them, and a cycle counter inside the processor's debug unit. The chapter explains none of those; it assumes all of them, as every chapter does. A reader who does not recognise them is not reading the wrong volume; they are reading the right volume in the wrong order. The companion's foundations and worked example are written for precisely that reader, they are the only part of either document that assumes nothing of the kind, and they are an evening's work.

### What changed in the second edition

> [!NOTE]
> **The second edition, Friday 6 November 2026**
>
> The first edition had twenty chapters. This one keeps all twenty, unchanged in their argument, and adds three things. Every chapter gained a **Variants** subsection: the alternative realisation, the other language, the other primitive, each with what it costs and when to choose it. Four chapters were added, [Project 21](21-a-zero-knowledge-virtual-machine-on-the-bench.md) to [Project 24](24-a-one-bit-model.md), because four of the ideas were too large to be variants: a zero-knowledge virtual machine, a bare-metal language this volume had not used, a runtime whose process isolation changes what a proof must cover, and a model whose weights are ternary. A companion document was written as well, carrying the prerequisites, the foundations, a tutorial that works one proof end to end by hand, and a one-page guide to each of the twenty-four; it is a separate PDF and a separate page, built from these same sources by `python build.py supplement`.
>
> The input to this edition was a design brief of twenty project sketches \[[2](#references)\]. Where its hardware claims disagreed with this bench, the bench was followed and the disagreement is stated in the chapter where it bites. Ten such corrections were needed, and the largest is that a model of eight billion parameters does not fit on a board with 512 MB, which [Project 22](22-embedded-swift-on-the-microcontroller.md) works out in full.

## Accessibility and reading level of this document

Two things are meant by accessible and only one of them is a matter of file format.

On reading level. The twenty-four chapters are written for a reader who already holds the vocabulary, and they do not pause to build it. A reader who does not hold it is not expected to start here and is not being turned away: the companion document, *Reading the zero-knowledge volume*, is the way in. Its foundations build the vocabulary once in one narrative, and its worked example works one complete proof by hand on a four-state machine with nothing left as an exercise. A reader with no background in cryptography, formal methods or embedded hardware should read those two parts, in that order, and open nothing else until they are done. That is an evening, and it is enough to follow every argument this volume makes, though not enough to build any of it.

On the document itself. The request was for a dark-background document in a PDF and in an HTML edition. The dark page is straightforward; full conformance in a PDF produced by this toolchain is not, and the position is stated before the content rather than after it.

> [!NOTE]
> **The engine finding, established Monday 5 October 2026**
>
> The tagged route was attempted first, for a sibling volume, and does not work on this machine. The installed MiKTeX carries the LaTeX kernel of Saturday 1 November 2025 and the `latex-lab` tagging bundle will not load on it. This PDF is therefore **not a tagged PDF**, and PDF/UA is not claimed. The finding was re-checked for this volume on Friday 6 November 2026 and stands. The HTML edition written from the same sources is the conformant artefact: it carries the mathematics as MathJax, which exposes it to assistive technology, and the Mermaid diagrams as live SVG with their source under a disclosure.

Computed, not asserted: every colour pair was computed with the WCAG 2.2 relative-luminance formula before the first compile by `contrast_check.py`, which reads `palette.tex` and fails the build if any value falls short. Body text 17.65:1, secondary text 12.12:1, links 10.97:1, headings 15.41:1, all against the page; diagram lines 12.71:1; every coloured block in a figure at least 14.13:1 against the page with black text on it at least 15.27:1. No status is shown by colour alone: the three marks each print a word, a solid, dashed or dotted outline carries the meaning that a colour also carries, and the prover and verifier blocks carry their names. Figures do not float, so the content-stream order is the reading order, and every caption states in words everything the figure shows.

## The bench

| **Part** | **What it is here, and the fact that constrains it** |
| --- | --- |
| Raspberry Pi 4 Model B Rev 1.4 | 8 GB, Cortex-A72; the verifier of most chapters and the only Pi that may carry the WS-28164 CAN HAT or the MCC 118, never both on one `config.txt` |
| Raspberry Pi 3 Model B Plus Rev 1.3 | 905 MB, 1.4 GHz, no fan on the bench. It slows itself down when it gets warm, which every chapter using it has to budget for, so each of those chapters writes "not measured, thermal" rather than a number. The working assumption is a soft limit at 60 C after about four minutes of sustained load; that four minutes is an assumption and not a reading, and the note after this table gives the nearest dated record, why it does not settle the question, and the reading that would replace it |
| Raspberry Pi 3 Model B Rev 1.2 | 1 GB; the second verifier where a chapter needs two Linux boards |
| NanoPi NEO Air | Allwinner H3, 512 MB, armv7, no 40-pin header; the floor for a verifier |
| NUCLEO-H7A3ZI-Q | STM32H7A3ZI, Cortex-M7 at 280 MHz, 1312 kB of SRAM as a sum over four separate regions and not one contiguous arena, sizes to be read from RM0455, hardware HASH unit, FDCAN; the prover on the device side; shared with other volumes, reflash before every capture |
| SBC-NodeMCU-ESP32, SBC-ESP8266-PROG | USB sidecars; the ESP32 proves with mbedTLS's P-256, the ESP8266 is the weaker sibling that only commits |
| X-NUCLEO-IKS4A1, X-NUCLEO-IKS5A1 | the sensor shields whose readings are the secrets; one at a time on the Nucleo's Arduino header or on a Pi I2C bus by flying leads |
| X-NUCLEO-53L8A1, Adafruit VL53L4CD | time-of-flight; the 8 by 8 part's firmware is licence gated and marked learn, the single-zone part is on I2C at 0x29 |
| STEVAL-STWINBX1 | the STWIN.box over USB-C; its vibration matrix is the committed matrix of one chapter |
| SIM7020E, SIM7070G, SIM7600E-H | the cellular HATs; no SIM is on the bench, so every cellular measurement reads "not measured, no SIM" |
| WS-28164 | isolated RS232, RS485, CAN and CAN FD HAT on the Pi 4B; the proof transport of one chapter; its overlays and the MCC 118 cannot share SPI0 |
| MCC 118 | the DAQ HAT, the timing witness for the Nucleo through a GPIO marker |
| nRF PPK2 | the only current meter; it meters the Nucleo, an ESP32 or an NB-IoT module, never a Raspberry Pi under load |
| RB-Explorer700, 3.5 inch LCD, 7 inch touchscreen, keyboard | the human-facing parts: a guarded-command toy, a verdict display, a kiosk verifier |
| Four Joy-it LEDs | the verdict indicator: green accept, red reject, yellow pending, blue committed |
| SEN0032 ADXL345 | retired from every plan since Saturday 24 October 2026; its header is unsoldered |

> [!NOTE]
> **The one bench assumption this volume leans on**
>
> Four acceptance tests depend on a number nobody has measured, so it is set out here rather than left in a table cell. The working limit every chapter on the Raspberry Pi 3 Model B Plus uses is a soft thermal limit at 60 C reached after about four minutes of sustained load, and that four minutes is this volume's assumption rather than its reading. The nearest dated record on this bench is a ramp of Tuesday 27 and Wednesday 28 October 2026 under a different load, one to four threads of a language-model benchmark, which went from 36.5 C to 68.2 C in about seven minutes and engaged the limit by dropping 1400 MHz to 1200 MHz. That load is not a multi-scalar multiplication, so it neither confirms the four minutes nor replaces it, and no run of this volume's own work has been timed to 60 C. Every chapter therefore writes "not measured, thermal" rather than a number, and [Project 11](11-the-provers-cost.md) sets a 200 s budget and prints the last size it reached so that the first real run replaces the assumption. The reading to take is `/sys/class/thermal/thermal_zone0/temp` sampled once a second across a sustained multi-scalar multiplication, three times on separate days, with the ambient temperature written beside each.

## The twenty-four projects, the languages and the primitives

The **Primitive** column names the piece of machinery each chapter builds, in the field's own vocabulary. This paragraph glosses the terms that recur across the column, so that the table can be read before the companion's foundations define them properly; for the values it does not gloss, start from the companion's foundations and then the chapter that carries each one. A **commitment** pins a secret value down without revealing it, and two shapes of it appear: *Pedersen*, which pins down one number, and *KZG* or *polynomial*, which pins down a whole set at once. An **opening** is the later act of revealing enough to show what was pinned down, and a *batch opening* does that for many values with one short proof. A **range proof** shows that a pinned-down number lies inside a stated interval without saying which number it is. An **equality proof**, here *Chaum-Pedersen*, shows that two commitments hide the same secret. A **circuit** scheme, here *Groth16*, *PLONK* or *sumcheck*, turns a computation into arithmetic that can be proved wholesale, and the differences between the three are proof size traded against the prover's work. **Folding** squashes many separate obligations into one so that the prover pays once instead of many times. A **Farkas witness** is a short certificate that a set of linear constraints has no solution at all, which is how the symbolic scheme discharges each of its obligations. A **zero-knowledge virtual machine** proves that a program ran as written, with no circuit to design by hand. **MSM** and **NTT** are the two arithmetic operations that dominate a prover's running time, which is why one chapter does nothing but price them.

| **No.** | **Project** | **Language** | **Primitive** | **Board** |
| --- | --- | --- | --- | --- |
| Z1 | The price list: field, group and pairing arithmetic on every board | Rust | the cost model | all four |
| Z2 | A sensor reading committed on the microcontroller | Rust, no\_std | Pedersen on ristretto255 | Nucleo, IKS4A1 |
| Z3 | The modem's backoff machine, proved live-free in zero knowledge | Python | explicit-state ZKMC, the encoder | Pi 4B, SIM7020E |
| Z4 | Two group elements: the KZG batch verifier in C | C | KZG batch opening | Pi 4B, Pi 3B |
| Z5 | Farkas witnesses for a joystick program | Rust | symbolic ZKMC, Z3, Bulletproofs | Pi 4B, Explorer700 |
| Z6 | Folding and the Salem-Spencer schedule, computed exactly | Julia | folding, Schwartz-Zippel | Pi 4B, STWIN.box |
| Z7 | The ESP32 proves one secret behind two public points: Chaum-Pedersen on P-256 | C# and C | Chaum-Pedersen equality | Pi 4B, ESP32 |
| Z8 | A ranking function as a circuit, verified in a kiosk browser | JavaScript, Circom | Groth16 | Pi 4B, touchscreen |
| Z9 | Nova versus one-shot folding on a Pi | Rust | Nova, relaxed R1CS | Pi 4B |
| Z10 | The hardware hash unit commits to a transition log | C | hash and Merkle commitments | Nucleo, IKS5A1 |
| Z11 | The prover's cost: multi-scalar multiplication and FFT on two Pis | C++ | MSM, NTT | Pi 4B, Pi 3B+ |
| Z12 | A PLONK gate for the inductive step, verified on the NanoPi | Go | PLONK, gnark | NanoPi, Pi 4B |
| Z13 | The obligation in Noir, proved with UltraHonk | Noir | sumcheck-based proving | Pi 4B |
| Z14 | Theorem 3.2 in Lean 4: the ranking-function rule and the descent lemma it rests on | Lean 4 | the certifier's soundness | Pi 4B |
| Z15 | A Zig verifier of Pedersen openings for the Pi 3B+ | Zig | ristretto255 openings | Pi 3B+, Nucleo |
| Z16 | The model proposes a ranking function; the certifier decides | Python and C | Z3 certification, GBNF | Pi 4B, build laptop |
| Z17 | From a sentence to a Buchi automaton with Spot | C++ | LTL to automata | Pi 4B |
| Z18 | A proof over the wire: KZG elements in CAN frames | C | proof transport, ISO-TP | Pi 4B, WS-28164, Nucleo |
| Z19 | A commitment over NB-IoT and the energy per proof byte | C | commitment transport | Pi 4B, SIM7070G, PPK2 |
| Z20 | The occupancy counter that proves its committed count is under the limit | Rust | Bulletproofs range proof | Pi 4B, VL53L4CD, LCD |
| Z21 | A zero-knowledge virtual machine on the bench | Rust | proving a program, not a circuit | Pi 4B, build laptop |
| Z22 | Embedded Swift on the microcontroller | Swift | Pedersen, with the language as the variable | Nucleo, IKS4A1, LCD |
| Z23 | Elixir and Nerves: the CAN node on the Erlang virtual machine | Elixir and Rust | batch zero-check over a bus | Pi 4B, WS-28164, Nucleo |
| Z24 | A one-bit model: ternary weights on the Pi | C and Python | certifying a quantised proposer | Pi 4B, LCD, LEDs |

### The models, where a chapter uses one

A language model appears in four chapters (Z16, Z17, Z20 and Z24) and in each it proposes and never decides. The models are taken from the trending list of Hugging Face as read on Friday 6 November 2026 \[[5](#references)\]: LiquidAI/LFM3-1.7B in its official GGUF \[[6](#references)\] as the default on the Pi 4B with 8 GB; a Qwen3.5-4B derivative where a chapter wants more reasoning and has the memory; and, as the small rung the sibling volume already pinned, Qwen2.5-0.5B and SmolLM2-360M. Every grammar is GBNF with each rule on one line, and every proposal is checked by Z3 or by the verifier before it can matter.

The second edition adds one rung of a different kind. In a **ternary-weight** model every weight takes one of three values, minus one, zero and one, which is about 1.58 bits each \[[3](#references)\]; the product of such a matrix with a vector needs no multiplications at all, only additions and subtractions, and [Project 24](24-a-one-bit-model.md) writes out both that count and the price it pays, which is that a decision margin narrower than the quantisation step does not survive. It runs through its own inference framework \[[4](#references)\] rather than through the engine the other rungs use, so it is a second instrument and not a drop-in replacement.

<a id="references"></a>

## References

1. Pascal Berrang, Mirco Giacobbe, Jacob Swales and Xiao Yang. Zero-Knowledge Model Checking. arXiv:2605.00487v2 \[cs.CR\], version 1 submitted Friday 1 May 2026, version 2 Tuesday 8 September 2026. [arxiv.org/abs/2605.00487](https://arxiv.org/abs/2605.00487) (verified Friday 6 November 2026).
2. Advanced hardware-software architectures for edge artificial intelligence and zero-knowledge model checking. A design brief of twenty project sketches, read on Friday 6 November 2026 and held locally at `a local design brief`. It is the input to this second edition and is not a published source; where its hardware claims disagree with the bench, the bench is followed and the disagreement is stated.
3. Shuming Ma, Hongyu Wang, Lingxiao Ma, Lei Wang, Wenhui Wang, Shaohan Huang, Li Dong, Ruiping Wang, Jilong Xue and Furu Wei. The era of 1-bit LLMs: all large language models are in 1.58 bits. arXiv:2402.17764, submitted Tuesday 27 February 2024; every weight is ternary, in the set with the three values minus one, zero and one. [arxiv.org/abs/2402.17764](https://arxiv.org/abs/2402.17764) (verified Friday 6 November 2026).
4. Microsoft. BitNet: the official inference framework for 1-bit large language models, in C++, MIT licence, 41466 stars when read. [github.com/microsoft/BitNet](https://github.com/microsoft/BitNet) (verified Friday 6 November 2026).
5. Hugging Face, trending text-generation models, read on the day: LiquidAI/LFM3-1.7B and its official GGUF, Qwen3.5-4B derivatives, NVIDIA Nemotron-3.5-Bolt-E4B-4GB, prism-ml Ternary-Bonsai-2-27B GGUF, XHToken Spark-X2.6-4B, and the DeepSeek-V4.1-Flash GGUF quantisations. [huggingface.co/models, trending](https://huggingface.co/models?pipeline_tag=text-generationsort=trending) (verified Friday 6 November 2026).
6. Liquid AI. LFM3-1.7B-GGUF, the official llama.cpp quantisations of LFM3-1.7B. [huggingface.co/LiquidAI/LFM3-1.7B-GGUF](https://huggingface.co/LiquidAI/LFM3-1.7B-GGUF) (to verify).

---

[Contents](../CONTENTS.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Next](01-the-price-list.md)
