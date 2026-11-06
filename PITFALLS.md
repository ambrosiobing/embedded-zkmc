# Every pitfall in the volume

Generated from the Pitfalls section of each project, so it is an index and
never a second copy: the sentence that explains a pitfall stays in the project
that owns it. Alphabetical, because by project is what the chapters already give.

**152 pitfalls across 24 projects.**

| Pitfall | Project |
|---|---|
| $\|K\| \ge N - 1$ for every schedule, not only this one (Lemma ), so no choice of $C$ brings the certificate below... | [Project 6](chapters/06-folding-and-the-salem-spencer-schedule.md) |
| $n$ must be a power of two for the heap layout; a shorter log is padded with a fixed sentinel leaf, never by... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| `!FG Wait` and `!F G Wait` parse the same; `!FGWait` parses as the negation of `F` of `GWait`, a proposition the... | [Project 17](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) |
| `api.AssertIsLessOrEqual(v, bound)` with a constant bound decomposes $v$ over the field's full bit length (to... | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| `AT+CASEND` has a maximum length per command that the manual states; a 544-byte proof may need more than one... | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| `bb` downloads the SRS on first use; on the Pi behind the bench LAN that download is done once on the build laptop... | [Project 13](chapters/13-the-obligation-in-noir.md) |
| `blst_p1_uncompress` does not check subgroup membership; a point on the curve but outside $\mathbb{G}_1$... | [Project 4](chapters/04-two-group-elements.md) |
| `can0` and `can1` swap between boots on this HAT; the interface name is read from `dmesg` every time and handed to... | [Project 23](chapters/23-elixir-and-nerves.md) |
| `can0` and `can1` swap between boots on this HAT; the interface name is read from `dmesg` every time, never... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| `candump` timestamps are taken when the driver hands the frame to the kernel, after the MCP2515's interrupt and an... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| `get_throttled` clears nothing: a sticky bit set in an earlier session is still set, so a non-zero reading before... | [Project 1](chapters/01-the-price-list.md) |
| `get_throttled` is sticky: a bit set in an earlier session stays set until a reboot, so a non-zero read before the... | [Project 11](chapters/11-the-provers-cost.md) |
| `gpiochip0` is the SoC's GPIO chip on the Pi 4B and the Pi 3B; on a Pi 5 it would not be, and there is no Pi 5 on... | [Project 4](chapters/04-two-group-elements.md) |
| `i32` would overflow: a row's dot product reaches $2^{32}$ in magnitude, and Noir's overflow check would then refuse... | [Project 13](chapters/13-the-obligation-in-noir.md) |
| `induction b` must generalise `hab`, which depends on `b`; Lean 4 does this on its own, but if the hypothesis is... | [Project 14](chapters/14-theorem-3-2-in-lean-4.md) |
| `llama-server` applies the grammar at sampling time but still stops at `n_predict`; a budget shorter than the... | [Project 16](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) |
| `mbedtls_ecp_mul` without the random callback runs without coordinate randomisation; the PPK2 trace of that build is... | [Project 7](chapters/07-the-esp32-proves-one-secret-behind-two-public.md) |
| `omega` reads hypotheses, not conjunctions: `hi'.2` must be named as `hdec` before the call, which is why the... | [Project 14](chapters/14-theorem-3-2-in-lean-4.md) |
| `parse(Int, s, base = 3)` on a binary string is the schedule only because the string holds no digit 2; a schedule... | [Project 6](chapters/06-folding-and-the-salem-spencer-schedule.md) |
| `pinctrl` per LED event forks a process; at 10 Hz this is fine, in the timed loop the LEDs are off, because a fork... | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
| `pow(w, -j, r)` with a negative exponent needs Python 3.8 or later; an older interpreter raises `ValueError` at the... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| `prove_single` runs one proof per value; the crate's `prove_multiple` aggregates $k$ values, $k$ a power of two,... | [Project 5](chapters/05-farkas-witnesses-for-a-joystick-program.md) |
| `struct can_frame` on this kernel exposes `len`; code written against `can_dlc` compiles and reads the same byte,... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| `unsafekzg.NewSRS` draws its secret from a fixed seed or a fresh one depending on the version (to verify); either... | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| `verify` returns the final $z$; a test that checks only `is_ok()` and not $z_N = 77$ would accept a run of the right... | [Project 9](chapters/09-nova-versus-one-shot-folding-on-a-pi.md) |
| A 16-bit sample in a commitment with no randomness is found in $2^{16}$ group operations; $r$ is 32 random bytes... | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| A 255-bit scalar that is not reduced modulo $r$ is a valid input to the bucket method but not to a commitment; the... | [Project 11](chapters/11-the-provers-cost.md) |
| A 64-bit range proof establishes $v \in [0, 2^{64})$, not $v \in [0, 2^{33}]$; the integer lift still holds because... | [Project 5](chapters/05-farkas-witnesses-for-a-joystick-program.md) |
| A `BitVector` of length $2 c_{\max} + 1$ is $1.6$ million bits at $N = 8192$ (computed); a `Set{Int}` of the same... | [Project 6](chapters/06-folding-and-the-salem-spencer-schedule.md) |
| A `sorry` is a warning, not an error; a log scan that only counts errors would pass a file whose lemma is also... | [Project 14](chapters/14-theorem-3-2-in-lean-4.md) |
| A bucket vector of $2^{10}$ Jacobian points is 144 kB per window and is reallocated $26$ times per multiplication: a... | [Project 11](chapters/11-the-provers-cost.md) |
| A commit longer than 100 ms skips a tick silently; the sequence numbers still count by one, so the host timestamps,... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| A comparison on `Field` in Noir is not an integer comparison; the program uses `i64` throughout so that every `<=`... | [Project 13](chapters/13-the-obligation-in-noir.md) |
| A cycle count of exactly zero on every line is `DEMCR.TRCENA` and not a dead counter: on this core the DWT unit is... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| A dot product written as one expression is refused by circom as non-quadratic; each product gets its own signal,... | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| A durable write is the hypothesis of the theorem, not a detail of the listing | [Project 23](chapters/23-elixir-and-nerves.md) |
| A folded witness is uniform in the field; the ranges are enforced inside each step and never on the running... | [Project 9](chapters/09-nova-versus-one-shot-folding-on-a-pi.md) |
| A GBNF rule body ends at the end of its line; a long alternation written over two lines without a trailing `\|`... | [Project 16](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) |
| A grammar that pins only a character class admits the instruction and a constant; this one pins the operator set and... | [Project 17](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) |
| A grammar that pins only a length and a character class admits the prompt's own sentence and a fixed constant, and... | [Project 24](chapters/24-a-one-bit-model.md) |
| A guest that allocates grows the trace invisibly | [Project 21](chapters/21-a-zero-knowledge-virtual-machine-on-the-bench.md) |
| A leaf preimage and a node preimage must not be confusable; the domain byte and the different lengths make them... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| A median over 64 repeats of a 300 ms multi-scalar multiplication is a 20 s run per operation and fits the Pi 3B+'s... | [Project 1](chapters/01-the-price-list.md) |
| A module keyed on without its antenna can damage its output stage; the antenna goes on first, every time | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| A native function holds the scheduler thread of its caller | [Project 23](chapters/23-elixir-and-nerves.md) |
| A negative integer written as `-1` in the input JSON reaches the witness calculator as a JavaScript number; `fe`... | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| A negative literal assigned to a `frontend.Variable` is reduced into the field; a negative literal that reaches... | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| A Nerves firmware update replaces the root filesystem | [Project 23](chapters/23-elixir-and-nerves.md) |
| A page that fetches the public signals from the same directory as the proof checks only that some statement was proved | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| A point sent uncompressed by the prover and decoded as compressed by the verifier is not a bad proof, it is a... | [Project 7](chapters/07-the-esp32-proves-one-secret-behind-two-public.md) |
| A rate without the rule's rate beside it is the width of the bands | [Project 24](chapters/24-a-one-bit-model.md) |
| A rate without the rule's rate on the same rows is the class balance: if 7 of 125 grid points are certified, a model... | [Project 16](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) |
| A row's salt is drawn per row; one salt for all rows turns Proposition (ii) back on, since a row with the index... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| A single-zone sensor counts crossings, not people; the count is an upper bound on entries, and the chapter says so... | [Project 20](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) |
| A test marked `should_fail` that passes because of a typo in the witness is a test that cannot fail; both negative... | [Project 13](chapters/13-the-obligation-in-noir.md) |
| A transcript label that differs between prover and verifier by one byte makes every proof fail; both labels are... | [Project 20](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) |
| A transition-based automaton and a state-based one of the same language differ in size; the `states` cell names the... | [Project 17](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) |
| A version drift in Zig between the build on the build laptop and the chapter's text is caught by printing `zig... | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
| An accumulator in `Int32` holds 64 samples of a signed 16-bit range without overflow, because $64 \times 2^{15} =... | [Project 22](chapters/22-embedded-swift-on-the-microcontroller.md) |
| Chromium's `performance.now()` is coarsened on purpose as a timing side channel defence; a single verification is... | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| DMA on the Cortex-M7 crosses the data cache: a buffer handed to `HAL_HASHEx_SHA256_Start_DMA` must be cleaned from... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| Everything not in $z$ is private, including the public rows $G_p, h_p$; a verifier that must know which obligations... | [Project 9](chapters/09-nova-versus-one-shot-folding-on-a-pi.md) |
| Integrity is not authenticity here either | [Project 23](chapters/23-elixir-and-nerves.md) |
| Omitting $y_1, y_2$ from the hash lets a transcript made for one statement be accepted for another with the same... | [Project 7](chapters/07-the-esp32-proves-one-secret-behind-two-public.md) |
| On armv7 `gnark-crypto`'s field arithmetic takes its pure Go path, not the assembly it has for amd64 and arm64 (to... | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| On the Pi 4B `/dev/serial0` points at the mini UART unless Bluetooth is moved off the PL011; the mini UART's baud... | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| On the Pi 4B the PL011 belongs to Bluetooth unless `disable-bt` is set; the mini UART that remains changes baud with... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| Proposition has two hypotheses and they live outside the compiler | [Project 22](chapters/22-embedded-swift-on-the-microcontroller.md) |
| Proposition is about one layer and one linear score | [Project 24](chapters/24-a-one-bit-model.md) |
| Reducing the 256-bit hash modulo $p$ makes $e$ very slightly non-uniform; for P-256 the bias is below $2^{-128}$ and... | [Project 7](chapters/07-the-esp32-proves-one-secret-behind-two-public.md) |
| Reusing $r$ is the one error the mathematics does not forgive: two commitments with the same $r$ give $c_1 / c_2 =... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| Scalars enter `blst_p2_mult` as little-endian bytes; $\omega$ written big-endian by Python is a different field... | [Project 4](chapters/04-two-group-elements.md) |
| Spot's equivalence check is exact for LTL and exponential in the worst case; the five templates are small, and a... | [Project 17](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) |
| The `bb` command line changed between its 0.x releases (scheme flags, output directories, the separate public-inputs... | [Project 13](chapters/13-the-obligation-in-noir.md) |
| The agreement rate is read beside the constant baseline row, as the sibling volume learned: a rate without its... | [Project 17](chapters/17-from-a-sentence-to-a-b-uchi-automaton.md) |
| The authoring laptop does not compile, and a proving toolchain is large enough that the mistake is expensive | [Project 21](chapters/21-a-zero-knowledge-virtual-machine-on-the-bench.md) |
| The backend flag: without `curve25519_dalek_bits="32"` the crate builds on `u128`, which compiles and runs on the... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| The blinding changes the degree from $65535$ to $65537$; a setup with only $65536$ powers makes `zip` in `commit`... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| The commitment is one multi-scalar multiplication of 65538 terms in pure Python; names the cost of one... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| The compressed encoding of `py_ecc` and the one `blst_p1_uncompress` reads must be the same 48-byte convention with... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| The compressed encoding's top three bits are flags; a prover that writes big-endian integers without them produces... | [Project 4](chapters/04-two-group-elements.md) |
| The counter must not live in the state of the bus process | [Project 23](chapters/23-elixir-and-nerves.md) |
| The crate takes bit sizes 8, 16, 32 and 64 only; asking for 4 returns an error, which is why the limit 16 is proved... | [Project 20](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) |
| The crate's `Scalar` comes from the `curve25519-dalek` version it depends on; mixing it with the 5.0.0 pinned in... | [Project 5](chapters/05-farkas-witnesses-for-a-joystick-program.md) |
| The cross terms are committed before $r$ is known, and the acceptance test's false result depends on it: a script... | [Project 6](chapters/06-folding-and-the-salem-spencer-schedule.md) |
| The data type setting decides how the unit swaps bytes within a word; a wrong setting produces a 32-byte digest that... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| The display and the LEDs exclude each other on this bench | [Project 24](chapters/24-a-one-bit-model.md) |
| The display carrier covers header pins 27 to 40, so an LED assigned inside that range is unreachable while the panel... | [Project 22](chapters/22-embedded-swift-on-the-microcontroller.md) |
| The execute pass and the proving pass fail in different ways | [Project 21](chapters/21-a-zero-knowledge-virtual-machine-on-the-bench.md) |
| The FDCAN kernel clock must be configured; with the default clock tree the nominal bit timing computed for 500... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| The fold argues over $\mathbb{Z}_p$ and a folded witness is uniform in $\mathbb{Z}_p$; the ranges of Equation 25 are... | [Project 6](chapters/06-folding-and-the-salem-spencer-schedule.md) |
| The four-minute window: a 60 s run per size with a pause between sizes keeps the board under its soft limit; the... | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
| The freshness rule is a receiver-side rule and the receiver's high-water mark must be durable too | [Project 23](chapters/23-elixir-and-nerves.md) |
| The global state space must be the full product of 256 triples, not the 33 reachable states: enumerating only... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| The HAL's hash API changed across versions: older drivers expose `HAL_HASHEx_SHA256_Start`, newer ones a single... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| The hardware CRC unit computes over 32-bit words in its default configuration, and without input and output reversal... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| The HAT's overlays claim SPI0 CE0 and CE1; the MCC 118 shares CE0 and must be unseated, not merely unused, and `ls... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| The HAT's overlays claim SPI0 CE0 and CE1; the MCC 118 shares CE0 and must be unseated, not merely unused, and `ls... | [Project 23](chapters/23-elixir-and-nerves.md) |
| The identity refusal: the library's `mul` returns an error when the product is the identity, and a sample of $v = 0$... | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
| The IKS4A1 and the IKS5A1 both answer at 0x6b, with WHO_AM_I 0x70 and 0x22; the firmware refuses the wrong one... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| The IKS4A1 and the IKS5A1 both answer at 0x6b; only the pair of WHO_AM_I bytes tells them apart, and the firmware... | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| The information bound of 1.58 bits per weight is not a file size | [Project 24](chapters/24-a-one-bit-model.md) |
| The LCD's overlay claims SPI0 and its own control lines; the LEDs on BCM 17, 27, 22 are chosen because they stay... | [Project 20](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) |
| The MCC 118 cannot see a marker pulse shorter than its 10 microsecond sample period; the marker must toggle, not... | [Project 1](chapters/01-the-price-list.md) |
| The MCC 118 needs SPI0 CE0 free of the CAN overlays; `ls /dev/spidev0.0` is the check | [Project 10](chapters/10-the-hardware-hash-unit-commits-to-a-transition.md) |
| The MCC 118 needs SPI0 CE0, and the CAN HAT's overlays take it whenever they are live in `config.txt`; `ls... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| The NanoPi's Wi-Fi drops under sustained transfer on some access points; the three files are small, but `scp` is... | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| The NanoPi's Wi-Fi power saving can add hundreds of milliseconds to the first packet of an ssh session; it changes... | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| The NodeMCU draws its 5 V from the Pi's USB port; putting the PPK2 in series means interrupting that line, and until... | [Project 7](chapters/07-the-esp32-proves-one-secret-behind-two-public.md) |
| The Nucleo is shared between volumes and carries whatever image was flashed last | [Project 22](chapters/22-embedded-swift-on-the-microcontroller.md) |
| The Nucleo is shared between volumes: whatever the ST-LINK drive held before this capture is unknown, and the image... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| The official display's touch needs the KMS overlay on trixie; if the panel lights but touch is dead, the... | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| The one-party ceremony is a stand-in; a proof system whose toxic waste is held by the prover proves nothing to... | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| The operation count is a check on the lemma and not decoration | [Project 24](chapters/24-a-one-bit-model.md) |
| The over-approximation $\mathsf{delay}' \le 255$ on the retry makes the set of accepted $V$ smaller than the paper's... | [Project 16](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) |
| The parser matches the awaited answer by prefix; a reply that begins with the same prefix as an unsolicited code... | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| The Pi 3B has no fan; a run that approaches four minutes is reported as not measured, thermal, and the binary prints... | [Project 4](chapters/04-two-group-elements.md) |
| The Pi 3B+'s serial console is dead; a run that drops its ssh session there loses its lines, which is why the... | [Project 11](chapters/11-the-provers-cost.md) |
| The Pi 4B's throttle register is read before and after the 64 repeats, like every chapter; a Honk verify is short,... | [Project 13](chapters/13-the-obligation-in-noir.md) |
| The PPK2 cannot meter a Raspberry Pi; it meters the module's supply only, and a trace taken on the Pi's 5 V input is... | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| The PPK2 in ampere-meter mode is a shunt in the supply path and drops its own voltage | [Project 19](chapters/19-a-commitment-over-nb-iot-and-the-energy.md) |
| The printed time includes reading 8089 $\mathbb{G}_2$ elements from the card; a second run that times the pairings... | [Project 4](chapters/04-two-group-elements.md) |
| The program digest is the whole of the assurance, by Remark | [Project 21](chapters/21-a-zero-knowledge-virtual-machine-on-the-bench.md) |
| The public certificate leaks what it states: $V$ names $0 \le c \le 5$ and the automaton names $m = 2$ as the... | [Project 5](chapters/05-farkas-witnesses-for-a-joystick-program.md) |
| The range checks are the soundness of the comparison: without the $k = 16$ checks on the entries, a witness could... | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| The recursion overhead is paid per step however small the obligation; for Z5's four columns it is more than ninety... | [Project 9](chapters/09-nova-versus-one-shot-folding-on-a-pi.md) |
| The replay on the Pi maps every imported olean; the first run after the copy is slower by the page cache than the... | [Project 14](chapters/14-theorem-3-2-in-lean-4.md) |
| The replayed log is a file | [Project 24](chapters/24-a-one-bit-model.md) |
| The sample must be the raw unsigned word so that $v \in [0, 2^{16})$ exactly; a signed reading shifted by $2^{15}$... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| The sensor's data-ready bit polarity follows a register the ULD sets at init; a loop that waits for the wrong level... | [Project 20](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) |
| The setup must hold at least $8089$ powers in $\mathbb{G}_2$; one too few is an exit with code 2, by the check in... | [Project 4](chapters/04-two-group-elements.md) |
| The shift `<< (64 - k)` in `root_of_unity` is undefined for $k = 0$; the harness only calls it for $k$ from 8 to 14 | [Project 11](chapters/11-the-provers-cost.md) |
| The sign of the delay term is not a detail: with the paper's machine the delay counts down on the fair step, so a... | [Project 16](chapters/16-the-model-proposes-a-ranking-function-the-certifier.md) |
| The SN65HVD230's Rs pin selects slew rate; left floating on some boards it limits the slope and 500 kbit/s shows as... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| The SPI0 chip selects are taken by the CAN HAT's overlays whenever those lines are live in `config.txt`; `ls... | [Project 1](chapters/01-the-price-list.md) |
| The step circuit must have the same shape at every step: the public parameters are built from one instance, so every... | [Project 9](chapters/09-nova-versus-one-shot-folding-on-a-pi.md) |
| The three circuits are presented as one relation written three times | [Project 8](chapters/08-a-ranking-function-as-a-circuit.md) |
| The three circuits are presented as one relation written three times | [Project 12](chapters/12-a-plonk-gate-for-the-inductive-step.md) |
| The three circuits are presented as one relation written three times | [Project 13](chapters/13-the-obligation-in-noir.md) |
| The toolchain in `lean-toolchain` and the Mathlib revision must match; a cache fetched for another toolchain... | [Project 14](chapters/14-theorem-3-2-in-lean-4.md) |
| The toy setup prints $\tau$; anyone who reads the setup log can open any commitment to any polynomial, which is the... | [Project 3](chapters/03-the-modems-backoff-machine.md) |
| The two-tier matrix commitment is what ties the per-entry range proofs to the matrix the equality proof uses;... | [Project 5](chapters/05-farkas-witnesses-for-a-joystick-program.md) |
| The wrap is a claim until it is read | [Project 21](chapters/21-a-zero-knowledge-virtual-machine-on-the-bench.md) |
| The WS-28164 is isolated: the SN65HVD230 board's ground must be tied to the HAT's CAN-side ground terminal, or the... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| Three X-NUCLEO shields exist on this bench and the Arduino header takes one | [Project 22](chapters/22-embedded-swift-on-the-microcontroller.md) |
| Two 120 ohm terminations on a two-node bus are correct; a third, from a transceiver board that also carries one,... | [Project 18](chapters/18-a-proof-over-the-wire.md) |
| Two `ttyACM` devices appear if CN1 is also plugged into the Pi; keep CN1 on the build laptop | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
| Two bit patterns, 0 and 3, encode the zero weight in the packing above | [Project 24](chapters/24-a-one-bit-model.md) |
| Two CDC ports: the ST-LINK on CN1 presents a virtual COM port too, so a Pi with both cables plugged sees two... | [Project 2](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md) |
| Two different `curve25519-dalek` versions in one build give two `Scalar` types that do not unify; the error is at... | [Project 20](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) |
| Two one-way maps: `fromUniform` here and `hash_from_bytes` on the Nucleo must agree, which is a property of two... | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
| Weights drawn early: Proposition is the reason the batch code draws $\rho$ inside the loop over a slice that is... | [Project 15](chapters/15-a-zig-verifier-of-pedersen-openings.md) |
