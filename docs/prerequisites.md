## Prerequisites

The volume asks a reader to hold three vocabularies at once: a little algebra, a little cryptography, and ordinary embedded practice. None of the three is deep, and none of them is optional. This part names exactly what is assumed, says where each idea is used, and ends with eight questions whose answers are on the same page.

### What a reader must know: mathematics

- **A group.** A set with an associative operation, an identity and inverses. The volume works almost entirely in finite cyclic groups of prime order, written multiplicatively, where every element other than the identity is a generator. Two concrete groups appear: the pairing-friendly group $`\mathbb{G}_1`$ of the curve BLS12-381, used by every polynomial commitment \[[16](#references)\], and the prime-order group ristretto255, used by every Pedersen commitment \[[37](#references), [18](#references)\]. What matters is not the curve arithmetic but the consequence: in a group of prime order $`p`$, raising a fixed generator to a uniformly random exponent gives a uniformly random group element. That single fact is what makes a commitment hide.
- **A finite field.** The integers modulo a prime $`p`$, written $`\mathbb{Z}_p`$ or $`\mathbb{F}_p`$, with addition, multiplication, and an inverse for every non-zero element. The volume embeds a secret state space into such a field so that sets of states become sets of field elements and set membership becomes a polynomial equation.
- **A polynomial and its roots.** A polynomial of degree $`d`$ over a field has at most $`d`$ roots. Therefore a non-zero polynomial of degree $`d`$ agrees with zero on at most $`d`$ points, and two distinct polynomials of degree at most $`d`$ agree on at most $`d`$ points. This is the whole of the Schwartz-Zippel argument \[[10](#references), [11](#references)\], and the whole reason a commitment to a polynomial can stand in for a commitment to the set the polynomial indicates.
- **A system of linear inequalities.** A finite collection of constraints $`A y \le b`$ over the rationals, and what it means for such a system to be infeasible. The symbolic scheme turns every proof obligation into an infeasibility claim and then into its dual certificate by Farkas’ lemma \[[9](#references)\]. A reader who has solved a linear program by hand once has enough.
- **Proof by induction and proof by contradiction.** The fair-termination rule is an induction over the steps of a run, and most of the volume's soundness arguments are contradictions: assume a cheating prover succeeds, derive a discrete logarithm or a root of a non-zero polynomial, conclude that the assumption was false. Project 14 writes one of these inductions in Lean 4 \[[15](#references)\], where every step has to be named.

### What a reader must know: cryptography

- **A hash.** A function from arbitrary input to a fixed-width digest that is assumed hard to invert and hard to collide. SHA-256 is the one used \[[33](#references)\], and on the microcontroller it is the hardware HASH unit rather than a software routine, which is the subject of Project 10. A reader needs to know what a digest is and why a Merkle tree lets one digest stand for many leaves \[[6](#references)\].
- **A commitment.** A short value that fixes a message without revealing it, opened later by producing the message and the randomness. The Pedersen form $`g^v h^r`$ is the one to have in mind \[[3](#references)\]; the polynomial form is the same idea applied to the coefficient vector of a polynomial \[[2](#references)\].
- **The difference between hiding and binding.** Hiding is a property of the commitment as seen by the verifier: it must reveal nothing about the message. Binding is a property as seen by the prover: it must not be possible to open the same commitment to two different messages. A Pedersen commitment is perfectly hiding and computationally binding; a commitment cannot be perfectly both, and the foundations say why.
- **A proof of knowledge.** More than a proof that a statement is true: a proof that the prover holds a witness, formalised by an extractor that recovers the witness from a prover that succeeds twice on different challenges \[[5](#references), [4](#references)\]. Every relation in the volume is written as a proof of knowledge for this reason, because the interesting claim is always "this device holds a system with this property", not merely "such a system exists".

### What a reader must know: embedded practice

- **I2C.** A two-wire bus with a clock and a data line, pull-ups to the supply, and seven-bit addresses. A reader should be able to run a bus scan, read a WHO\_AM\_I register, and say what an empty scan means. The sensor shields of the volume are found this way, and their measured addresses are printed in the volume's bench section.
- **SPI.** A four-wire bus with a clock, two data lines and one chip select per device, so that two peripherals wanting the same chip select cannot share a header. On this bench that collision is a settled fact rather than a theory: the CAN HAT's overlays and the DAQ HAT both want SPI0, and no chapter may plan on having both.
- **UART.** An asynchronous serial link with an agreed rate on both ends, carrying the console of a board that has no display. A reader should know that a loopback test cannot detect a wrong rate, because both ends are wrong together.
- **CAN.** A differential two-wire bus with arbitration by identifier, terminations at both ends, and a frame carrying at most eight bytes in its classic form \[[47](#references)\]. A proof does not fit in one frame, so the volume carries it in a transport protocol \[[48](#references)\]; that is the content of Project 18.
- **Flashing a board.** For the Nucleo, copying a binary to the mass-storage drive the debugger presents, and knowing that the board is shared between volumes, so it is reflashed immediately before any capture and the build stamp in the banner is what proves which image is running. For a Linux board, writing an image to a card and bringing it up over the network.
- **Opening a serial console.** Attaching to the board's console at the right rate and catching the first lines, which are the ones that say what is running.
- **Reading a pin map.** Going from a signal name in a chapter to a physical pin on a header, with the vendor's own numbering, and knowing that a vendor's pin name belongs to that vendor's board and not to the chip.

### What a reader must have: the boards and the parts

Every row is a part already on this bench. The last column names the projects that need it; a project is named by its number in the volume.

| **Part** | **What it is here** | **Projects that need it** |
| --- | --- | --- |
| Raspberry Pi 4 Model B | 8 GB, Cortex-A72; the verifier of most chapters and the only Pi that may carry the CAN HAT or the DAQ HAT, never both in one configuration | 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24 |
| Raspberry Pi 3 Model B Plus | 905 MB, 1.4 GHz, soft thermal limit at 60 C in about four minutes of sustained load, no fan; any longer run reads "not measured, thermal" | 1, 11, 15 |
| Raspberry Pi 3 Model B | 1 GB; the second Linux board where a chapter needs two | 1, 4 |
| NanoPi NEO Air | Allwinner H3, 512 MB, armv7, no 40-pin header; the floor for a verifier, and the board whose memory rules a large model out by arithmetic | 1, 12, 22 |
| NUCLEO-H7A3ZI-Q | STM32H7A3ZI, Cortex-M7 at 280 MHz, hardware HASH unit, FDCAN; 1312 kB of SRAM in four separate regions (DTCM, the AXI SRAM, the AHB SRAM of domain D2 and the SRD SRAM, with the sizes and addresses to be read from RM0455 \[[49](#references)\]) and not one contiguous arena, so no working set may be sized against the total; the prover on the device side, shared between volumes, reflashed before every capture | 1, 2, 10, 15, 18, 22, 23 |
| SBC-NodeMCU-ESP32, SBC-ESP8266-PROG | USB sidecars; the ESP32 proves an equality of two commitments, the ESP8266 is the weaker sibling that only commits | 3, 7 |
| X-NUCLEO-IKS4A1, X-NUCLEO-IKS5A1 | the sensor shields whose readings are the secrets; one at a time on the Nucleo's Arduino header, or on a Pi I2C bus by flying leads | 2, 10, 22 |
| X-NUCLEO-53L8A1, Adafruit VL53L4CD | time-of-flight; the 8 by 8 part's driver is licence gated and a large firmware upload, so it is marked learn and no frame rate is stated as achieved; the single-zone part is on I2C at 0x29 | 7, 17, 20 |
| STEVAL-STWINBX1 | the STWIN.box over USB-C, a device with no Arduino header; its vibration matrix is the committed matrix of one chapter | 6 |
| SIM7020E, SIM7070G, SIM7600E-H | the cellular HATs; no SIM is on the bench, so every cellular measurement reads "not measured, no SIM" and the command sequence is replayed | 3, 19 |
| Waveshare WS-28164 | the isolated RS232, RS485, CAN and CAN FD HAT; on the Pi 4B only, never the Pi 3B+; proven as a two-node classic bus on Tuesday 7 October 2026 | 18, 23 |
| MCC 118 DAQ HAT | 8 single-ended channels, 12 bit, 100 kS/s aggregate across the channels in use rather than per channel, plus or minus 10 V, 10 microsecond sample period; the timing witness for the Nucleo through a marker pin | 1, 5 |
| nRF PPK2 | the only current meter; it meters the Nucleo, an ESP32 or an NB-IoT module, and it cannot source or meter a Raspberry Pi under load | 1, 12, 19 |
| JOY-iT RB-Explorer700 | the guarded-command toy: joystick, OLED, real-time clock, analog converter and expander on one board | 5 |
| Waveshare 3.5 inch LCD, 7 inch touchscreen, keyboard | the human-facing parts: a verdict display whose carrier covers header pins 27 to 40, and a kiosk verifier | 8, 15, 20, 22, 24 |
| Four Joy-it LEDs | the verdict indicator: green accept, red reject, yellow pending, blue committed; anode on the signal pin, driven high | 22, 24 |
| the build laptop | Windows 11 with WSL, 8 cores, 24 GB; the only machine that compiles anything. The authoring laptop never compiles | every project |

One part the design brief uses repeatedly is not on this list. The DFRobot SEN0032 accelerometer has been retired from every plan since Saturday 24 October 2026: its header is not soldered, every contact is friction, and six bus scans were empty with the supply and the return verified at the module's own rows. Where the brief puts that part at the centre of a sketch, the volume substitutes an inertial unit on one of the X-NUCLEO shields and says so in the chapter.

### What a reader must have: the toolchain, at the versions this bench runs

Every version below was read from the source named in the bibliography entry on Friday 6 November 2026. Where no version is given, the entry has none to give and the version is read on the machine before the first build rather than assumed.

| **Tool or library** | **Version this bench runs** | **Where it is needed** |
| --- | --- | --- |
| `ark-bls12-381` | 0.6.0 \[[16](#references)\] | every pairing and every KZG commitment: projects 1, 4, 6, 9 |
| `curve25519-dalek` | 5.0.0 \[[18](#references)\], the group of RFC 9496 \[[37](#references)\] | every Pedersen commitment, and the only group the microcontroller build carries: projects 1, 2, 15 |
| `bulletproofs`, `merlin` | 5.0.0 \[[17](#references)\] and 3.0.0 \[[43](#references)\] | the range proofs and their transcript: projects 5, 20 |
| `nova-snark` | 0.76.0 \[[19](#references)\] | recursive folding against the one-shot schedule: project 9 |
| `blst` | v0.3.17 \[[21](#references)\] | the C verifier and its assembly pairings: project 4 |
| `gnark` | v0.16.4 \[[20](#references)\], carrying a soundness fix in emulated scalar multiplication | the Go circuit: project 12 |
| `circom`, `snarkjs` | circom \[[45](#references)\], snarkjs v0.7.6 \[[22](#references)\] | the browser-side circuit and its verifier: project 8 |
| Noir | v1.0.0 \[[23](#references)\] | the sumcheck-based route: project 13 |
| Spot | 2.16.2 \[[44](#references), [14](#references)\] | translating a formula to an automaton and deciding equivalence: project 17 |
| Z3 and its Rust bindings | Z3 \[[13](#references)\], the `z3` crate 0.22.0 \[[36](#references)\] | certifying a ranking function: projects 5, 16 |
| Lean 4 | \[[15](#references)\] | the machine-checked fair-termination rule: project 14 |
| Zig | 0.17.1 \[[35](#references)\] | the opening verifier for the thermally limited board: project 15 |
| TinyGo | v0.44.0 \[[30](#references)\] | the variant that targets the Cortex-M directly: project 12 |
| SP1, RISC Zero | v6.10.0 \[[24](#references)\] and v3.0.6 \[[25](#references)\] | proving the execution of a program rather than a circuit: project 21 |
| BitNet, the ternary inference framework | \[[27](#references)\], the architecture of \[[26](#references)\] | the one-bit proposer: project 24 |
| `llama.cpp` | v0.6.0 at commit d8123504, the pin inherited from the sibling volume \[[46](#references)\] | every chapter where a model proposes: projects 16, 17, 20 |
| ExecuTorch | v1.5.1 \[[28](#references)\] | the on-device runtime whose frame sequence is committed: project 10 |
| Nerves on Elixir | v1.15.1 \[[29](#references)\] | the supervised CAN node: project 23 |
| Embedded Swift with SVD2Swift | \[[31](#references)\] | typed register access on the microcontroller: project 22 |
| .NET nanoFramework | \[[32](#references)\] | the certificate checked where the firmware runs: project 3 |
| `py-ecc` | 8.0.0 \[[38](#references)\] | the Python front-end and nothing timed: projects 3, 16 |
| `rppal`, `libgpiod` | 0.22.1 \[[42](#references)\], v2.3.2 \[[34](#references)\] | every Raspberry Pi peripheral touched from user space |
| `stm32h7xx-hal`, `cortex-m-rt`, `usb-device` | 0.16.0 \[[39](#references)\], 0.7.7 \[[40](#references)\], 0.3.2 \[[41](#references)\] | the `no_std` build for the Nucleo, which does not link without the runtime and a panic handler: projects 1, 2, 15 |
| The document toolchain | MiKTeX carrying the LaTeX kernel of Saturday 1 November 2025; the tagging bundle does not load on it, which is why neither PDF claims PDF/UA and the HTML edition is the conformant artefact | building either document on the authoring laptop |
| The board image | Raspberry Pi OS trixie, kernel 6.18.50+rpt-rpi-v8 on the Pi 4B card; the reference is this bench's own record and not a published source | every project that runs on a Pi |

Two tools have no pinned version anywhere in the bibliography and must be read on the machine before the first build: the Rust toolchain on the build laptop, and the C or C++ compiler used for each board. Both are read with their own version flag, because a cost claim attached to an unnamed compiler is not attached to anything. That reading belongs in the chapter's own steps rather than in the reader's habits: the first step of every chapter that builds a timed binary reads `rustc --version`, `cargo --version` or `aarch64-linux-gnu-g++ --version` and writes the output into the chapter's own record, so that a figure and the compiler that produced it cannot become separated. Where a chapter does not yet carry that step, and on Friday 6 November 2026 most do not, that is a gap in this volume and not a rule it keeps, and no timing figure from such a chapter may be compared against a timing figure from another machine.

### A self-check, with the answers

Eight questions, one for each idea the volume assumes without restating it. The answers are one or two sentences and name where the idea is used.

| **Question** | **Answer** |
| --- | --- |
| 1. In a group of prime order $`p`$ with generator $`g`$, what is the distribution of $`g^r`$ when $`r`$ is uniform on $`\mathbb{Z}_p`$? | Uniform on the whole group, because $`r \mapsto g^r`$ is a bijection from $`\mathbb{Z}_p`$ onto the group. This is exactly why a Pedersen commitment hides perfectly, and it is proved in Project 1. |
| 2. A non-zero polynomial of degree $`d`$ over a field is evaluated at a point chosen uniformly from a set of size $`N`$. What is the chance it reads zero? | At most $`d/N`$, because it has at most $`d`$ roots. The explicit-state scheme turns set disjointness into exactly this question, and the field is large enough that $`d/N`$ is negligible \[[10](#references)\]. |
| 3. What does Farkas’ lemma give you when a system of linear inequalities has no solution? | A non-negative combination of the rows that sums to a contradiction, that is, a short certificate of infeasibility that can be checked without solving anything \[[9](#references)\]. The symbolic scheme commits to that certificate rather than to the system. |
| 4. Which of hiding and binding can a commitment have perfectly, and why not both? | Either one, never both. If a commitment is perfectly hiding then every commitment value is consistent with every message, so some opening to a second message exists and binding can only be computational; if it is perfectly binding the commitment determines the message, so hiding can only be computational. Pedersen takes the first option. |
| 5. What does a proof of knowledge add to a proof that a statement is true? | An extractor: from a prover that answers two different challenges on the same commitment, the witness itself can be recovered \[[5](#references)\]. The volume's relations are written as proofs of knowledge because the claim is always about what a particular device holds. |
| 6. A device answers at address 0x6b on a two-wire bus and its identity register reads a value no driver recognises. What has been established and what has not? | That something answers at that address, and nothing else. Address and identity together name a part only against the vendor's own document; this is why one shield on this bench has a unit at 0x6a that is measured, named by its register, and left unsupported. |
| 7. Two peripherals both want chip select 0 on the same four-wire bus. What happens, and how is it checked? | They cannot be used together, whatever the configuration file claims. The check is whether the device node for that chip select exists, not whether the overlay is listed, and on this bench it is the reason the CAN HAT and the DAQ HAT never appear in one chapter. |
| 8. Why is a ranking-function argument an induction, and what does the base case say? | The rule proves that no fair run goes on forever by showing that a natural number attached to the state strictly decreases on every fair step and never increases on any other. The base case is that the number is finite on every initial state; the step is the non-increase, and the fair step is the strict decrease. The rule is Theorem 3.2 of the source paper \[[1](#references)\] and is machine checked in Project 14. |

A reader who answered six or more of the eight is ready for the foundations. A reader who did not should read the entry beside each answer first: the two cryptography books in the bibliography \[[7](#references), [8](#references)\] cover questions 1, 4 and 5 between them, and the model checking textbook \[[12](#references)\] covers question 8 and everything in the next part.

<a id="references"></a>

## References

1. Pascal Berrang, Mirco Giacobbe, Jacob Swales and Xiao Yang. Zero-Knowledge Model Checking. arXiv:2605.00487v2 \[cs.CR\], version 1 submitted Friday 1 May 2026, version 2 Tuesday 8 September 2026. [arxiv.org/abs/2605.00487](https://arxiv.org/abs/2605.00487) (verified Friday 6 November 2026).
2. Aniket Kate, Gregory M. Zaverucha and Ian Goldberg. Constant-size commitments to polynomials and their applications. In ASIACRYPT 2010, LNCS 6477, pages 177 to 194. Springer, 2010. [doi:10.1007/978-3-642-17373-8\_11](https://doi.org/10.1007/978-3-642-17373-8_11) (to verify).
3. Torben P. Pedersen. Non-interactive and information-theoretic secure verifiable secret sharing. In CRYPTO 1991, LNCS 576, pages 129 to 140. Springer, 1991. [doi:10.1007/3-540-46766-1\_9](https://doi.org/10.1007/3-540-46766-1_9) (to verify).
4. Shafi Goldwasser, Silvio Micali and Charles Rackoff. The knowledge complexity of interactive proof systems. SIAM Journal on Computing, 18(1), pages 186 to 208, 1989. [doi:10.1137/0218012](https://doi.org/10.1137/0218012) (to verify).
5. Mihir Bellare and Oded Goldreich. On defining proofs of knowledge. In CRYPTO 1992, LNCS 740, pages 390 to 420. Springer, 1992. [doi:10.1007/3-540-48071-4\_28](https://doi.org/10.1007/3-540-48071-4_28) (to verify).
6. Ralph C. Merkle. A digital signature based on a conventional encryption function. In CRYPTO 1987, LNCS 293, pages 369 to 378. Springer, 1988. [doi:10.1007/3-540-48184-2\_32](https://doi.org/10.1007/3-540-48184-2_32) (to verify).
7. Jonathan Katz and Yehuda Lindell. Introduction to Modern Cryptography, second edition. CRC Press, 2014. (to verify)
8. Dan Boneh and Victor Shoup. A graduate course in applied cryptography. Draft, version 0.6, 2023. [toc.cryptobook.us](https://toc.cryptobook.us/) (to verify).
9. Julius Farkas. Theorie der einfachen Ungleichungen. Journal fur die reine und angewandte Mathematik, 124, pages 1 to 27, 1902. [doi:10.1515/crll.1902.124.1](https://doi.org/10.1515/crll.1902.124.1) (to verify).
10. Jacob T. Schwartz. Fast probabilistic algorithms for verification of polynomial identities. Journal of the ACM, 27(4), pages 701 to 717, 1980. [doi:10.1145/322217.322225](https://doi.org/10.1145/322217.322225) (to verify).
11. Richard Zippel. Probabilistic algorithms for sparse polynomials. In EUROSAM 1979, LNCS 72, pages 216 to 226. Springer, 1979. [doi:10.1007/3-540-09519-5\_73](https://doi.org/10.1007/3-540-09519-5_73) (to verify).
12. Christel Baier and Joost-Pieter Katoen. Principles of Model Checking. MIT Press, 2008. (to verify)
13. Leonardo de Moura and Nikolaj Bjørner. Z3: an efficient SMT solver. In TACAS 2008, LNCS 4963, pages 337 to 340. Springer, 2008. [doi:10.1007/978-3-540-78800-3\_24](https://doi.org/10.1007/978-3-540-78800-3_24) (to verify).
14. Alexandre Duret-Lutz, Etienne Renault, Maximilien Colange, Florian Renkin, Alexandre Gbaguidi Aisse, Philipp Schlehuber-Caissier, Thomas Medioni, Antoine Martin, Jerome Dubois, Clement Gillard and Henrich Lauko. From Spot 2.0 to Spot 2.10: what's new? In CAV 2022, LNCS 13372, pages 174 to 187. Springer, 2022. [doi:10.1007/978-3-031-13188-2\_9](https://doi.org/10.1007/978-3-031-13188-2_9) (to verify).
15. Leonardo de Moura and Sebastian Ullrich. The Lean 4 theorem prover and programming language. In CADE 2021, LNCS 12699, pages 625 to 635. Springer, 2021. [doi:10.1007/978-3-030-79876-5\_37](https://doi.org/10.1007/978-3-030-79876-5_37) (to verify).
16. arkworks contributors. arkworks: a Rust ecosystem for zkSNARK programming. The ark-bls12-381 crate is at version 0.6.0, updated Sunday 26 April 2026, 25.3 million downloads. The licence is not recorded here because it has not been read; read it from the crate's own licence field and from the repository's LICENSE file (to verify). [crates.io, ark-bls12-381](https://crates.io/api/v1/crates/ark-bls12-381) (verified Friday 6 November 2026).
17. dalek cryptography and zkcrypto contributors. bulletproofs: a pure-Rust implementation of Bulletproofs using Ristretto. Version 5.0.0, updated Tuesday 4 June 2024, 3.1 million downloads. [crates.io, bulletproofs](https://crates.io/api/v1/crates/bulletproofs) (verified Friday 6 November 2026).
18. dalek cryptography contributors. curve25519-dalek: group operations on ristretto255 and Curve25519. Version 5.0.0, updated Monday 6 July 2026, 318.9 million downloads. [crates.io, curve25519-dalek](https://crates.io/api/v1/crates/curve25519-dalek) (verified Friday 6 November 2026).
19. Microsoft Research. nova-snark: high-speed recursive arguments from folding schemes. Version 0.76.0, updated Thursday 3 September 2026. The licence is not recorded here because it has not been read; read it from the crate's own licence field and from the repository's LICENSE file (to verify). [crates.io, nova-snark](https://crates.io/api/v1/crates/nova-snark) (verified Friday 6 November 2026).
20. Consensys. gnark: a fast zk-SNARK library in Go. Release v0.16.4, Wednesday 7 October 2026, carrying a high-severity soundness fix in emulated elliptic-curve scalar multiplication and a BW6-761 pairing fix. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/Consensys/gnark, latest release](https://api.github.com/repos/Consensys/gnark/releases/latest) (verified Friday 6 November 2026).
21. Supranational. blst: a BLS12-381 signature and pairing library in C and assembly. Release v0.3.17, Friday 24 July 2026. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/supranational/blst, latest release](https://api.github.com/repos/supranational/blst/releases/latest) (verified Friday 6 November 2026).
22. iden3. snarkjs: zkSNARK implementation in JavaScript and WebAssembly. Release v0.7.6, Monday 26 January 2026. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/iden3/snarkjs, latest release](https://api.github.com/repos/iden3/snarkjs/releases/latest) (verified Friday 6 November 2026).
23. Aztec. Noir: a domain-specific language for zero-knowledge circuits. Release v1.0.0, Thursday 29 October 2026; 1431 stars when read. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/noir-lang/noir, latest release](https://api.github.com/repos/noir-lang/noir/releases/latest) (verified Friday 6 November 2026).
24. Succinct Labs. SP1: a zero-knowledge virtual machine that proves the execution of a RISC-V binary. Release v6.10.0, Friday 23 October 2026. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/succinctlabs/sp1](https://github.com/succinctlabs/sp1) (verified Friday 6 November 2026).
25. RISC Zero. risc0: a RISC-V zero-knowledge virtual machine and proof system. Release v3.0.6, Friday 17 July 2026. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/risc0/risc0](https://github.com/risc0/risc0) (verified Friday 6 November 2026).
26. Shuming Ma, Hongyu Wang, Lingxiao Ma, Lei Wang, Wenhui Wang, Shaohan Huang, Li Dong, Ruiping Wang, Jilong Xue and Furu Wei. The era of 1-bit LLMs: all large language models are in 1.58 bits. arXiv:2402.17764, submitted Tuesday 27 February 2024; every weight is ternary, in the set with the three values minus one, zero and one. [arxiv.org/abs/2402.17764](https://arxiv.org/abs/2402.17764) (verified Friday 6 November 2026).
27. Microsoft. BitNet: the official inference framework for 1-bit large language models, in C++, MIT licence, 41466 stars when read. [github.com/microsoft/BitNet](https://github.com/microsoft/BitNet) (verified Friday 6 November 2026).
28. PyTorch. ExecuTorch: an on-device inference runtime for PyTorch models. Release v1.5.1, Wednesday 23 September 2026. [github.com/pytorch/executorch](https://github.com/pytorch/executorch) (verified Friday 6 November 2026).
29. Nerves Project. Nerves: an embedded Elixir platform on the Erlang virtual machine. Release v1.15.1, Saturday 24 October 2026. [github.com/nerves-project/nerves](https://github.com/nerves-project/nerves) (verified Friday 6 November 2026).
30. TinyGo contributors. TinyGo: a Go compiler for microcontrollers and WebAssembly, on LLVM. Release v0.44.0, Wednesday 28 October 2026. [github.com/tinygo-org/tinygo](https://github.com/tinygo-org/tinygo) (verified Friday 6 November 2026).
31. Swift project. Embedded Swift: a subset of Swift for bare-metal and constrained targets, with the SVD2Swift tool for typed register access. [swift.org/get-started/embedded](https://www.swift.org/get-started/embedded/) (to verify).
32. .NET nanoFramework contributors. nanoFramework: a managed runtime for constrained microcontrollers, including the ESP32 and ESP8266 families. [nanoframework.net](https://www.nanoframework.net/) (to verify).
33. National Institute of Standards and Technology. FIPS 180-4, Secure Hash Standard (SHS), August of 2015. [doi:10.6028/NIST.FIPS.180-4](https://doi.org/10.6028/NIST.FIPS.180-4) (verified Friday 6 November 2026).
34. Bartosz Golaszewski and contributors. libgpiod: a C library and tools for the Linux GPIO character device. Newest tag v2.3.2 when the repository was read. [github.com/brgl/libgpiod, tags](https://api.github.com/repos/brgl/libgpiod/tags) (verified Friday 6 November 2026).
35. Zig Software Foundation. The Zig programming language. Latest stable release 0.17.1, Monday 2 November 2026. [ziglang.org/download](https://ziglang.org/download/) (verified Friday 6 November 2026).
36. prove-rs. z3: high-level Rust bindings for the Z3 SMT solver. Version 0.22.0, updated Wednesday 28 October 2026. [crates.io, z3](https://crates.io/api/v1/crates/z3) (verified Friday 6 November 2026).
37. Henry de Valence, Jack Grigg, Mike Hamburg, Isis Lovecruft, George Tankersley and Filippo Valsorda. The ristretto255 and decaf448 groups. RFC 9496, 2023. [rfc-editor.org/info/rfc9496](https://www.rfc-editor.org/info/rfc9496) (verified Friday 6 November 2026).
38. Ethereum Foundation. py-ecc: elliptic curve cryptography in Python, including secp256k1, alt\_bn128 and bls12\_381. Version 8.0.0, released Monday 14 April 2025. [pypi.org/project/py-ecc](https://pypi.org/project/py-ecc/) (verified Friday 6 November 2026).
39. stm32h7xx-hal contributors. stm32h7xx-hal: a hardware abstraction layer for the STM32H7 series. Version 0.16.0, updated Tuesday 12 March 2024. [crates.io, stm32h7xx-hal](https://crates.io/api/v1/crates/stm32h7xx-hal) (verified Friday 6 November 2026).
40. rust-embedded. cortex-m-rt: the minimal runtime for Cortex-M microcontrollers. Version 0.7.7, updated Thursday 24 September 2026. [crates.io, cortex-m-rt](https://crates.io/api/v1/crates/cortex-m-rt) (verified Friday 6 November 2026).
41. rust-embedded-community. usb-device: a USB stack for embedded devices. Version 0.3.2, updated Wednesday 6 March 2024. [crates.io, usb-device](https://crates.io/api/v1/crates/usb-device) (verified Friday 6 November 2026).
42. golemparts. rppal: an interface for the Raspberry Pi's GPIO, I2C, PWM, SPI and UART peripherals. Version 0.22.1, updated Wednesday 11 December 2024. [crates.io, rppal](https://crates.io/api/v1/crates/rppal) (verified Friday 6 November 2026).
43. zkcrypto. merlin: composable proof transcripts for public-coin arguments of knowledge, the transcript the Bulletproofs crate takes. Version 3.0.0, updated Thursday 28 January 2021. [crates.io, merlin](https://crates.io/api/v1/crates/merlin) (verified Friday 6 November 2026).
44. Spot contributors. Spot: a C++20 library for LTL, omega-automata manipulation and model checking. Version 2.16.2, released Tuesday 3 November 2026, GNU GPL version 3. [spot.lre.epita.fr](https://spot.lre.epita.fr/) (verified Friday 6 November 2026).
45. iden3. circom: a circuit compiler for zero-knowledge proofs. The licence is not recorded here because it has not been read; read it from the repository's LICENSE file (to verify). [github.com/iden3/circom](https://github.com/iden3/circom) (to verify).
46. ggml-org. llama.cpp, release v0.6.0 at commit d8123504, the pin of the sibling EdgeLLM volume. [github.com/ggml-org/llama.cpp/releases](https://github.com/ggml-org/llama.cpp/releases) (to verify).
47. ISO 11898-1:2015. Road vehicles, controller area network (CAN), part 1: data link layer and physical signalling. International Organization for Standardization, 2015. (to verify)
48. ISO 15765-2:2016. Road vehicles, diagnostic communication over CAN, part 2: transport protocol and network layer services. International Organization for Standardization, 2016. (to verify)
49. STMicroelectronics. RM0455, STM32H7A3/7B3 and STM32H7B0 advanced Arm-based 32-bit MCUs, reference manual. (to verify)

---

Prerequisites &nbsp;&nbsp;|&nbsp;&nbsp; [Foundations](foundations.md) &nbsp;&nbsp;|&nbsp;&nbsp; [A tutorial: one proof, end to end](tutorial.md) &nbsp;&nbsp;|&nbsp;&nbsp; [A guide to the twenty-four projects](guide.md) &nbsp;&nbsp;|&nbsp;&nbsp; [The chapters](../chapters/00-about-this-volume.md)
