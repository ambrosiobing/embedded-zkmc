## A guide to the twenty-four projects

The volume can be read in order, and it was written to be. It can also be entered from whatever is on the desk, which is what this guide is for. The table gives the number, the title, the language, the board and the primitive of all twenty-four projects; the entries after it give, for each one, what it assumes of the reader and of the earlier chapters, the one idea it exists to teach, what to read before the code, the trap that is easiest to fall into, and its own acceptance test in one line. Every entry is deliberately short: the chapter is the long form, and this is the index to it.

| **No.** | **Project** | **Language** | **Board and parts** | **Primitive** |
| --- | --- | --- | --- | --- |
| Z1 | The price list: field, group and pairing arithmetic on every board | Rust | all four boards; MCC 118 and PPK2 as witnesses | the cost model |
| Z2 | A sensor reading committed on the microcontroller | Rust, `no_std` | Nucleo with the IKS4A1; Pi 4B as verifier | Pedersen on ristretto255 |
| Z3 | The modem's backoff machine, proved live-free in zero knowledge | Python | Pi 4B with the SIM7020E; no SIM | the explicit-state encoder |
| Z4 | Two group elements: the KZG batch verifier in C | C | Pi 4B and Pi 3B; two LEDs | KZG batch opening |
| Z5 | Farkas witnesses for a joystick program | Rust | Pi 4B with the Explorer700 | the symbolic scheme, Z3 and ranges |
| Z6 | Folding and the Salem-Spencer schedule, computed exactly | Julia | Pi 4B; STWIN.box log replayed | one-shot folding |
| Z7 | The ESP32 proves two commitments open to one calibration constant | C# and C | Pi 4B and the ESP32; PPK2 | Chaum-Pedersen equality |
| Z8 | A ranking function as a circuit, verified in a kiosk browser | JavaScript and Circom | Pi 4B with the 7 inch touchscreen | Groth16 |
| Z9 | Nova versus one-shot folding on a Pi | Rust | Pi 4B alone | Nova over relaxed R1CS |
| Z10 | The hardware hash unit commits to a transition log | C | Nucleo with the IKS5A1; Pi 4B as verifier | hash and Merkle commitments |
| Z11 | The prover's cost: multi-scalar multiplication and FFT on two Pis | C++ | Pi 4B and Pi 3B+ | multi-scalar multiplication and the transform |
| Z12 | A PLONK gate for the inductive step, verified on the NanoPi | Go | NanoPi NEO Air and Pi 4B | PLONK through gnark |
| Z13 | The obligation in Noir, proved with UltraHonk | Noir | Pi 4B alone | sumcheck-based proving |
| Z14 | Theorem 3.2 in Lean 4: the ranking-function rule, machine checked | Lean 4 | Pi 4B; the build laptop elaborates | the certifier's soundness |
| Z15 | A Zig verifier of Pedersen openings for the Pi 3B+ | Zig | Pi 3B+ and the Nucleo; three LEDs | ristretto255 openings, singly and batched |
| Z16 | The model proposes a ranking function; the certifier decides | Python and C | Pi 4B; the build laptop may serve the model | certification and a GBNF grammar |
| Z17 | From a sentence to a Buchi automaton with Spot | C++ | Pi 4B with libspot | LTL to automata |
| Z18 | A proof over the wire: KZG elements in CAN frames | C | Pi 4B with the WS-28164; Nucleo FDCAN | proof transport and segmentation |
| Z19 | A commitment over NB-IoT and the energy per proof byte | C | Pi 4B with the SIM7070G; PPK2; no SIM | commitment transport |
| Z20 | The occupancy counter that proves it stayed under the limit | Rust | Pi 4B with the VL53L4CD and the 3.5 inch LCD | a range proof on the inner-product argument |
| Z21 | A zero-knowledge virtual machine on the bench | Rust | Pi 4B as verifier; the build laptop builds and may prove | proving a program's execution |
| Z22 | Embedded Swift on the microcontroller | Embedded Swift | Nucleo with one shield; Pi 4B with the 3.5 inch LCD | Pedersen on a sensor window |
| Z23 | Elixir and Nerves: the CAN node on the Erlang virtual machine | Elixir with a Rust native function | Pi 4B with the WS-28164; Nucleo as the second node | the batch zero-check in CAN frames |
| Z24 | A one-bit model: ternary weights on the Pi | C, with Python as the harness | Pi 4B with the 3.5 inch LCD and the LEDs | a ternary linear layer |

Four groupings cut across the table and are worth knowing before choosing. Z1 and Z11 are cost instruments and carry no secret. Z3, Z4 and Z18 are one pipeline: one certificate, one commitment, three chapters. Z8, Z12, Z13 and Z21 prove the same single inequality four ways, so reading them together prices a domain-specific circuit against a general machine. Z16, Z17, Z20 and Z24 are the four chapters where a language model appears, and in every one of them it proposes and the certifier or the verifier decides.

### Z1. The price list: field, group and pairing arithmetic on every board

- **Assumes** nothing of the volume; [Project 1](../chapters/01-the-price-list.md) is the chapter every other one quotes, and it needs only the four boards and a pinned toolchain.
- **The idea** is that a cost claim is a count of operations multiplied by a price, and a price without a named instrument is not a price.
- **Read first** its lemma on the operation counts of the two schemes, then the remark that turns the paper's Table 1 into a prediction for this bench.
- **The trap** is the throttle register: `get_throttled` is sticky, so a non-zero reading before a run means reboot the board, not retry the run.
- **Acceptance** six harness lines per board whose repeat spread is under 5 percent, with the throttle word `0x0` at both ends and the Nucleo's cycle count agreeing with the MCC 118 within 2 percent.

### Z2. A sensor reading committed on the microcontroller

- **Assumes** the price of a ristretto multiplication from [Project 1](../chapters/01-the-price-list.md) and the definition of a Pedersen commitment given there; it is the first chapter with a secret.
- **The idea** is that a microcontroller can bind itself to a reading it does not disclose, in 32 bytes, and that the binding is additive so a window can be summed without opening a single sample.
- **Read first** the hiding and binding theorems of [Project 1](../chapters/01-the-price-list.md), because the whole chapter is those two statements running at 10 Hz.
- **The trap** is reusing the randomness: two commitments under one $`r`$ give the difference of the samples to anyone who divides them, recoverable in at most 131071 trial exponentiations.
- **Acceptance** 100 consecutive commitments decode as ristretto points on the Pi 4B with no gap over 150 ms, ten requested openings verify and ten altered openings are refused.

### Z3. The modem's backoff machine, proved live-free in zero knowledge

- **Assumes** the price list of [Project 1](../chapters/01-the-price-list.md) for its arithmetic, and it is the chapter the tutorial above is the small version of.
- **The idea** is the paper's central move: the certifier never touches the secret, it enumerates from public data every state and pair that would violate the ranking conditions, and the prover shows only that its secret misses them.
- **Read first** Theorem 3.2 with its descent argument, then the Lagrange basis lemma, because the rest of the chapter is bookkeeping over those two.
- **The trap** is enumerating only the reachable states: the batch sizes are public, so a batch over 33 reachable states instead of all 256 would disclose the transition relation through its own cardinality.
- **Acceptance** the batch sizes 16, 7976, 5016 and 8088 agree between the authoring laptop and the board, the proof file is exactly 192 bytes, and the machine with one extra fair self-loop is refused at the division.

### Z4. Two group elements: the KZG batch verifier in C

- **Assumes** the proof file of [Project 3](../chapters/03-the-modems-backoff-machine.md) and the pairing price of [Project 1](../chapters/01-the-price-list.md); it holds no secret of its own.
- **The idea** is that the verifier's work does not grow with the system: two pairings and one multi-scalar multiplication in the second group, whatever the number of states behind the commitment.
- **Read first** the vanishing-is-disjointness lemma of [Project 3](../chapters/03-the-modems-backoff-machine.md), since the two pairing equations are that lemma in group form.
- **The trap** is that decompression is not validation: a point on the curve but outside the prime-order subgroup decompresses without error and makes the pairing equation say nothing, so the subgroup check is mandatory and costs one more multiplication per element.
- **Acceptance** the generator round-trips through both compression conventions, the honest file lights the green LED, and the same file with one flipped byte lights the red one.

### Z5. Farkas witnesses for a joystick program

- **Assumes** the certificate idea of [Project 3](../chapters/03-the-modems-backoff-machine.md) and the commitment of [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md), and it is the entry point to the paper's second scheme.
- **The idea** is that a ranking obligation over a secret linear program becomes the unsatisfiability of a linear system, and unsatisfiability has a short certificate by Farkas’ lemma: a witness the prover can commit to and prove in range.
- **Read first** the uniform form of the three obligations and the dual, then the integer-lift lemma, because the range proofs are about the lifted witness and not the rational one.
- **The trap** is the certificate's own disclosure: the public ranking function and the public automaton name the counter's limit and the beeping mode, so the secret here is the update matrices and never the specification.
- **Acceptance** an integer witness is found for every one of the 77 obligations, every entry lies in the stated bound, every range proof verifies, and a witness with one entry raised by one fails the equality check.

### Z6. Folding and the Salem-Spencer schedule, computed exactly

- **Assumes** the obligations of [Project 5](../chapters/05-farkas-witnesses-for-a-joystick-program.md) as its input and the field arithmetic of [Project 1](../chapters/01-the-price-list.md); no proof system is built here, only the combinatorics under one.
- **The idea** is that many obligations can be checked as one if the exponent schedule keeps the cross terms apart, and that a progression-free set is exactly what keeps them apart.
- **Read first** the identity that expands the folded product into diagonal and cross terms, then the bound on the size of the cross-term set, which is the chapter's one exact quantity.
- **The trap** is testing the wrong thing: the folding identity holds for any matrices and any witnesses, so a script that alters a matrix and recomputes the cross terms proves nothing; only the committed coefficients may be altered.
- **Acceptance** the computed cross-term sizes for the thirteen instance sizes match the chapter's table on both machines, admissibility holds for every size, and the identity is false after one committed coefficient is altered.

### Z7. The ESP32 proves two commitments open to one calibration constant

- **Assumes** the commitment of [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) and the scalar price of [Project 1](../chapters/01-the-price-list.md); the statement is the paper's equality of committed values.
- **The idea** is the smallest useful zero-knowledge proof in the volume: a sigma protocol of three objects that discloses one bit, namely that two public group elements were formed from the same secret scalar.
- **Read first** the special-soundness argument, because it is the one place where extraction from two transcripts is written out in full and it explains why the challenge must be a hash of the commitment.
- **The trap** is the encoding boundary: a point sent uncompressed and read as compressed is a framing error and not a bad proof, and a verifier that reports the two the same way will send a reader looking for a cryptographic defect.
- **Acceptance** a transcript from the module is accepted and lights green, one with a single byte of the response changed is rejected and lights red, and a transcript built for a different scalar is rejected.

### Z8. A ranking function as a circuit, verified in a kiosk browser

- **Assumes** the obligation of [Project 5](../chapters/05-farkas-witnesses-for-a-joystick-program.md) as its statement and nothing of the two earlier commitment chapters; it is the first of the four chapters that prove one inequality four ways.
- **The idea** is that a general-purpose circuit buys a constant proof of three group elements and a verifier small enough to run in a browser, at the cost of a circuit-specific setup.
- **Read first** the comparison lemma that turns an inequality over the integers into one over a prime field, because every range check in the circuit exists to satisfy its hypothesis.
- **The trap** is omitting those range checks: without them a witness can use entries near the modulus so that every row holds in the field while the inequality fails over the integers.
- **Acceptance** the honest proof shows accept on the touchscreen, the same proof with one public signal changed shows reject, and a transition that does not decrease the ranking function fails at witness generation.

### Z9. Nova versus one-shot folding on a Pi

- **Assumes** the obligations of [Project 5](../chapters/05-farkas-witnesses-for-a-joystick-program.md) and the one-shot fold of [Project 6](../chapters/06-folding-and-the-salem-spencer-schedule.md), which it exists to be compared against.
- **The idea** is that two folds with the same guarantee have different bills: one challenge over all instances, or one cross term per step with the verifier's own circuit folded in each time.
- **Read first** the cost proposition, since the whole chapter is its two counts and the conditions under which each wins.
- **The trap** is the recursion overhead paid per step whatever the obligation's size: for a four-column obligation it is most of the constraint count, which is why the conclusion here would reverse for an obligation of a few thousand rows.
- **Acceptance** a recursive proof over the 77 obligations verifies with the step count recorded and the constraint count printed, and the same run with one witness entry raised by one fails to verify.

### Z10. The hardware hash unit commits to a transition log

- **Assumes** the microcontroller lane of [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) and nothing about pairings; it is the hash-based alternative to a group commitment.
- **The idea** is that a device can fix a whole history with 32 bytes and then disclose a handful of rows from it, and that a hardware digest unit makes the cost of doing so per transition small.
- **Read first** the Merkle membership argument, then the collision-resistance hypothesis it rests on, because the binding here is computational in a different way from the discrete-logarithm binding elsewhere.
- **The trap** is the digest unit's byte-swap setting: a wrong data-type field produces a 32-byte digest that is wrong and looks right, which is why the published test vector is hashed before anything is committed.
- **Acceptance** the unit's digest of the three-byte test input matches the published vector and the Pi's own library byte for byte, the root over 1024 rows is recomputed and matches, and eight openings verify while two altered ones are refused.

### Z11. The prover's cost: multi-scalar multiplication and FFT on two Pis

- **Assumes** the price list of [Project 1](../chapters/01-the-price-list.md), whose single-operation numbers it extends to the two operations that dominate at scale; it carries no secret.
- **The idea** is that every prover in the volume is paid for in two currencies, a multi-scalar multiplication and a transform, and that both have published asymptotics and a constant that only measurement supplies.
- **Read first** the bucket-method count and the transform's operation count, so that the measured curve can be compared against a shape rather than against a hope.
- **The trap** is the thermally limited board: the Pi 3B+ reaches its soft limit in about four minutes of sustained load with no fan on the bench, so a size whose run exceeds that window reads not measured with the reason, never a throttled number.
- **Acceptance** one line per size on the Pi 4B across the seven sizes with the throttle word `0x0` at both ends, the same on the Pi 3B+ up to its window, and the transform of a known vector inverting back to the input.

### Z12. A PLONK gate for the inductive step, verified on the NanoPi

- **Assumes** the statement of [Project 8](../chapters/08-a-ranking-function-as-a-circuit.md) unchanged, so the two chapters differ only in the proof system and the board.
- **The idea** is that a universal setup removes the per-circuit ceremony, and that the question for an embedded verifier is then whether a pairing-based check fits in 512 MB on an armv7 part.
- **Read first** the gate and permutation constraints, then the memory arithmetic for the verifier, because the board's limit is the chapter's real subject.
- **The trap** is the unsafe setup helper: whichever way it draws its secret, the prover holds it, so the bench proof convinces only the bench and a product form needs a ceremony string read from a file.
- **Acceptance** the honest proof verifies on the NanoPi with peak resident memory under 200 MB and a repeat spread under 5 percent, the proof with one public value changed is rejected, and the out-of-range witness is refused by the prover.

### Z13. The obligation in Noir, proved with UltraHonk

- **Assumes** the statement of [Project 8](../chapters/08-a-ranking-function-as-a-circuit.md) and [Project 12](../chapters/12-a-plonk-gate-for-the-inductive-step.md) for the third time, and the price list of [Project 1](../chapters/01-the-price-list.md) for the field work.
- **The idea** is that a typed circuit language inserts the range checks the two earlier chapters wrote by hand, and that a sumcheck prover replaces a large polynomial division.
- **Read first** the comparison lemma of [Project 8](../chapters/08-a-ranking-function-as-a-circuit.md) once more, this time to see the compiler performing it, and then the chapter's note on which integer width the rows need.
- **The trap** is the arithmetic type: a comparison on the native field type is not an integer comparison, and the narrower integer type overflows on an honest row, so the program uses the wider one throughout.
- **Acceptance** the test suite passes on the instance, the honest proof verifies on the Pi, the proof with one public value changed is rejected, and the out-of-range witness is refused at execution with a failed assertion.

### Z14. Theorem 3.2 in Lean 4: the ranking-function rule, machine checked

- **Assumes** the proof of Theorem 3.2 as written in [Project 3](../chapters/03-the-modems-backoff-machine.md); it formalises that argument and adds no new bench hardware.
- **The idea** is that the one sentence every chapter rests on can be handed to a kernel, and that having a checked object is the precondition for later hiding the check itself.
- **Read first** the Lean statement beside the paper's three conditions, so that each hypothesis in the formal text is matched to the equation it comes from.
- **The trap** is the toolchain pin: a cache fetched for a different toolchain revision rebuilds the mathematics library from source, which is hours on the build laptop and is not attempted on the board at all.
- **Acceptance** the build ends with no error and exactly one outstanding placeholder, on the theorem and never on the lemma, the board reproduces the same verdict, and a deliberately broken hypothesis makes the lemma fail.

### Z15. A Zig verifier of Pedersen openings for the Pi 3B+

- **Assumes** the commitments produced by [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) and the group price of [Project 1](../chapters/01-the-price-list.md); it is the verifying half of that pair.
- **The idea** is that a batch of openings can be checked under random weights for about half the group arithmetic, at a soundness error of one in the group order.
- **Read first** the proposition on when the weights may be drawn, because drawing them before the batch is complete is what turns a sound batch check into an unsound one.
- **The trap** is two independent implementations of one derivation: the generator the board derives and the generator the microcontroller derives must agree byte for byte, and that agreement is checked on the first line of every run rather than assumed.
- **Acceptance** the derived generator equals the microcontroller's byte for byte, 64 correct openings accept and 64 altered ones are refused both singly and in a batch, and every timed run stays inside the board's thermal window.

### Z16. The model proposes a ranking function; the certifier decides

- **Assumes** the machine and the obligations of [Project 3](../chapters/03-the-modems-backoff-machine.md), and the solver front-end of [Project 5](../chapters/05-farkas-witnesses-for-a-joystick-program.md); the proof itself is not the subject here.
- **The idea** is the volume's model rule stated as a theorem: a proposer may be anything at all, because a wrong proposal is rejected by the certifier and costs completeness and never soundness.
- **Read first** that theorem, then the grammar, in that order, because the grammar is only an efficiency measure once the theorem is understood.
- **The trap** is reading an agreement rate without the control rule's rate on the same rows: if a small fraction of the candidate grid certifies, a proposer drawing at random scores that fraction and has learned nothing.
- **Acceptance** at least 100 proposals per model, every one parsed by the grammar and every one certified or rejected with the independent check agreeing in every case, and the paper's own certificate accepted.

### Z17. From a sentence to a Buchi automaton with Spot

- **Assumes** the automaton half of the certificate as used in [Project 3](../chapters/03-the-modems-backoff-machine.md), and the model rule as proved in [Project 16](../chapters/16-the-model-proposes-a-ranking-function-the-certifier.md).
- **The idea** is that the first half of the certificate has to be written by somebody, and that an equivalence check against a template turns a proposed formula into a decided one.
- **Read first** the five templates with their negations, since the automaton the scheme needs is for the complement and a reader who builds it for the formula will get the wrong one.
- **The trap** is operator binding in the concrete syntax: a negated eventually always with no space binds differently and names a proposition the machine does not have, which the grammar's atom list is there to prevent.
- **Acceptance** each of the five templates yields an automaton for the negated formula, the solver reports each template equivalent to a hand-written variant and not equivalent to a deliberately wrong one, and the paper's own automaton is reported equivalent to its formula.

### Z18. A proof over the wire: KZG elements in CAN frames

- **Assumes** the proof file of [Project 3](../chapters/03-the-modems-backoff-machine.md) and the verifier of [Project 4](../chapters/04-two-group-elements.md); it changes nothing about either and only moves the bytes.
- **The idea** is that a constant-size proof is a transport problem with an exact answer: a fixed number of frames, a computable bus time, and an integrity check that tells a damaged payload from an intact one.
- **Read first** the frame accounting and the bus-time arithmetic, then the sentence that says what the integrity check cannot do, namely tell a stranger's payload from the prover's.
- **The trap** is the interface name: the two controllers on this HAT exchange their names between boots, so the name is read from the kernel log every time and never remembered from the last session.
- **Acceptance** one capture records exactly 25 frames, the reassembled file is byte-identical to the prover's under comparison, a sender that skips one frame yields no file, and the reassembled file is accepted by [Project 4](../chapters/04-two-group-elements.md).

### Z19. A commitment over NB-IoT and the energy per proof byte

- **Assumes** the commitment of [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) and the transport discipline of [Project 18](../chapters/18-a-proof-over-the-wire.md); the proof it later carries is the one of [Project 4](../chapters/04-two-group-elements.md) or [Project 20](../chapters/20-the-occupancy-counter-that-proves-it-stayed-under.md).
- **The idea** is that privacy has a price in joules on a battery-class radio, and that the price is per payload byte, so a constant-size proof is an energy argument and not only a bandwidth one.
- **Read first** the four radio windows the energy figure is split into, because an aggregate figure over a whole send hides which window a design change would move.
- **The trap** is the meter's own limit: the current meter on the bench cannot meter a Raspberry Pi under load, so a trace taken on the board's own supply is a different and wrong quantity, and only the module's supply may be metered.
- **Acceptance** with a SIM every step of the attach and send sequence answers successfully and the four windows each have a repeat spread under 10 percent; without one the driver stops at the card check with the reason no SIM and replays the whole sequence through the same parser byte for byte.

### Z20. The occupancy counter that proves it stayed under the limit

- **Assumes** the commitment of [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md), the range proofs of [Project 5](../chapters/05-farkas-witnesses-for-a-joystick-program.md) and the model rule of [Project 16](../chapters/16-the-model-proposes-a-ranking-function-the-certifier.md); it is the chapter meant to be shown to a visitor.
- **The idea** is a complete demonstration in one sentence: the device proves that a secret count is below a public limit without saying whether it was three or fifteen.
- **Read first** the range-proof statement and the bound's decomposition, so that it is clear which inequality is proved and which is merely displayed.
- **The trap** is the proof system's permitted bit widths: the library takes 8, 16, 32 and 64 only, so a limit that is not one of those is proved as two statements and the verifier must recompute the derived commitment itself rather than accept one.
- **Acceptance** the sensor's identity register reads its documented value, staged crossings of zero, five, fifteen and sixteen produce accept, accept, accept and reject with the matching LED, and the proof length equals the computed count.

### Z21. A zero-knowledge virtual machine on the bench

- **Assumes** the anonymising filter of [Project 19](../chapters/19-a-commitment-over-nb-iot-and-the-energy.md) as its guest program and the tailored protocols of [Project 4](../chapters/04-two-group-elements.md) as the baseline it is priced against.
- **The idea** is that a general machine proves the execution of a program rather than the satisfaction of a circuit, which buys the ability to prove any program at the cost of a factor the chapter counts.
- **Read first** the trace-validity theorem with its soundness hypothesis, then the cost lemma, whose named constant is the quantity the accelerator literature is aimed at.
- **The trap** is the prover's memory: if it does not fit the board the prover runs on the build laptop and only the verification happens on the Pi, and the figure is then drawn dashed rather than quietly attributed to the board.
- **Acceptance** cycles per instruction and bytes per proof recorded as not measured, with the brief's 192-byte wrapped proof carried as a claim to verify and never as a measurement.

### Z22. Embedded Swift on the microcontroller

- **Assumes** the commitment of [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) unchanged, which is the point: the language is the variable and the cryptography is the control.
- **The idea** is that a typed register discipline is a guarantee about the firmware, not about the proof, and the chapter is explicit that the two are different kinds of assurance.
- **Read first** the proposition that a well-typed access cannot reach a reserved field, and then the sentence that bounds what it claims.
- **The trap** is the brief's own hardware claim, corrected here with arithmetic: a 4-bit quantisation of an eight-billion-parameter model needs about 5 GB and the smallest Linux board on the bench has 512 MB, so it does not fit by an order of magnitude.
- **Acceptance** the committed window matches the one [Project 2](../chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) produces for the same samples, and the register-access claim is checked against the reference manual rather than asserted from the type signature.

### Z23. Elixir and Nerves: the CAN node on the Erlang virtual machine

- **Assumes** the wiring and the frame layout of [Project 18](../chapters/18-a-proof-over-the-wire.md) exactly, and the batch zero-check of [Project 4](../chapters/04-two-group-elements.md) as the statement carried in the frames.
- **The idea** is that a process-isolation runtime changes what the proof must cover rather than changing the cryptography: a supervisor that restarts a node is a new source of replayed frames.
- **Read first** the theorem that a restart cannot replay a committed frame, which rests on a monotone sequence number and is the chapter's one new piece of mathematics.
- **The trap** is the board correction the brief needs: this CAN HAT is for the Pi 4B and the Pi 5, so the Pi 3B+ the brief names is not used, and the isolated HAT still needs its CAN-side ground tied to the loose transceiver's.
- **Acceptance** the frames a supervised node sends after a restart are refused as replays by sequence number, and the reassembled proof is accepted by [Project 4](../chapters/04-two-group-elements.md) exactly as the C sender's is.

### Z24. A one-bit model: ternary weights on the Pi

- **Assumes** the certifier of [Project 16](../chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) to decide and the model rule proved there; the chapter states plainly that nothing in it diagnoses anything, and its domain is equipment triage from a replayed log.
- **The idea** is that a proposer can be reduced to additions and subtractions without touching soundness, because soundness never depended on the proposer in the first place.
- **Read first** the lemma that a ternary matrix-vector product needs no multiplications, then the proposition on the decision boundary, which is the honest limit of the whole idea.
- **The trap** is that limit: a margin smaller than the quantisation step is not preserved, so a proposal near the boundary is not merely less accurate but arbitrary, which is tolerable only because the certifier decides.
- **Acceptance** the addition count against the floating-point product matches the computed figure, every proposal is parsed and then certified or rejected, and a constructed instance with a margin below the step is shown to change its label.

---

[Prerequisites](prerequisites.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Foundations](foundations.md) &nbsp;&nbsp;|&nbsp;&nbsp; [A tutorial: one proof, end to end](tutorial.md) &nbsp;&nbsp;|&nbsp;&nbsp; A guide to the twenty-four projects &nbsp;&nbsp;|&nbsp;&nbsp; [The chapters](../chapters/00-about-this-volume.md)
