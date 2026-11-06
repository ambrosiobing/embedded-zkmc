# Zero knowledge on the bench

**Proving something about a machine without opening it up**

Twenty-four embedded projects, one paper taken apart, and one question asked of every piece:
what does it cost on hardware this small, and what can a device of this size honestly prove
about itself?

This page is for a reader with no background in cryptography, formal methods or embedded
hardware. It says what the work is, why it matters, what it does not claim, what it costs to
follow, and where to start. Written Friday 6 November 2026.

---

## The problem, in one situation

A lift maker's control software decides when the car moves and when the doors open. The firm
will not publish it, because competitors would read it. A building inspector does not want to
read it either. The inspector wants one assurance, that the doors never open while the car is
between floors, and wants it to hold on every journey the lift will ever make rather than on
the journeys somebody happened to test.

Today that assurance comes from trust and paperwork. Somebody audits the firm, somebody signs
something, and the assurance is only as good as the auditor's time. There is now a way to do
it with mathematics instead. This volume is about what that way costs on hardware small enough
and cheap enough to put inside the lift.

## The two ideas

**Model checking** settles whether a piece of control logic always obeys a stated rule. Not
usually, not in testing, but on every run the logic could ever have. It treats the logic as a
set of situations with moves between them, treats the rule as a statement about what may be
observed as time passes, and then establishes that no sequence of moves can ever break the
rule. It has been used in industry for decades, most visibly on processors and on safety
systems; the standard textbook treatment is Baier and Katoen, which this volume cites.

**A zero-knowledge proof** lets one computer convince another that a statement about its own
private data is true, while handing over nothing except the statement and a short proof. The
checking side ends up knowing the statement is true, knowing nothing else at all, and having
had to trust nothing. That sounds impossible and is not. It rests on arithmetic that is easy
to do in one direction and believed to be impractical in the other.

Two words from that second idea are used on every page of this volume and are borrowed from
cryptography rather than from ordinary English. The **prover** is the side that holds
something private and wants to be believed; here it is almost always a small board with a
sensor on it. The **verifier** is the side that will not take the prover's word for it and
checks a proof instead; here it is almost always a single-board computer on the same desk.
Neither word implies trust in either direction, and that is the whole point.

Put the two ideas together and the lift maker can establish that its software obeys the
inspector's rule without showing the software to anybody. A sensor can establish that a
reading stayed inside a limit without publishing the reading. A meter can establish which band
a household's consumption fell in without publishing the consumption.

## Why a small computer makes it interesting

These proofs are expensive to produce. The research that makes them possible is done on large
rented servers, where the cost is a line on an invoice. The devices that have something worth
proving are not large servers. They are the sensor in the doorway, the board in the pallet,
the controller in the lift, the meter in the hall. Those run on processors a thousand times
slower and on memory a thousand times smaller.

So the useful question is not whether this can be done. It is what each piece costs on a
board of that size, which pieces will not fit at all, and what a device of that size can
honestly prove about itself. This volume works that out, piece by piece, and writes down the
arithmetic behind every answer.

## What the work is

Twenty-four projects. Each takes one piece of the construction out of a research paper
published in 2026, Berrang, Giacobbe, Swales and Yang, *Zero-Knowledge Model Checking*, and
puts it on one specific piece of hardware already sitting on one desk: three single-board
computers, a microcontroller board, two small radio modules, three cellular modems, a set of
sensor shields, a distance sensor, a measurement instrument, a display and a few indicator
lights.

Each project is written to a single pattern. It names what is secret and what is public. It
writes its mathematics out in full, with the sets, the theorems and the proofs on the page
rather than cited. It shows the code, in a language chosen for a stated reason; fourteen
languages appear across the twenty-four. It gives the wiring, pin by pin. It predicts what the
operation will cost and shows the arithmetic behind the prediction. And it writes down, in
advance, the test it would have to pass to count as working, phrased so that it is capable of
failing.

A companion document comes with it, under [`docs/`](docs/). The companion does not assume
the reader has met zero-knowledge proofs, model checking or embedded hardware; it does assume
school algebra and that the reader has seen a computer program. It builds the vocabulary
once, from a state machine to a finished proof, and then works one complete proof by hand on
a machine with four states, including a deliberate error so that the reader can follow exactly
why the checking side would refuse it.

## Six things it is for

Each names what is secret, what is public, and what a reader would learn. None of them has
been built and run; each is written as the condition the project would have to meet.

**1. A doorway counter under a licence limit.** A concert hall is licensed for a fixed number
of people. A distance sensor over each door counts arrivals and departures all evening.
Secret: the count at every moment, which the venue treats as commercial information, and the
arrival pattern, which says who was where and when. Public: a short proof that the count
never went above the limit. The project passes when staged crossings below the limit are
accepted, a crossing above it is refused, and the display shows a verdict and never a number.
A reader learns that privacy and compliance are not opposites, because a landlord or an
inspector sees a verdict and never a count. They also learn where the library pushes back: the
range-proof widths available are 8, 16, 32 and 64 bits, so a limit of fifteen is proved as
two statements rather than one.

**2. A cold chain and the receiving pharmacy.** A pallet of vaccine travels for three days. A
sensor board reads the temperature every minute and a cellular modem sends one short message
per hour. Secret: the temperature series and the route, which a carrier will not publish
because a competitor could read its handling and its timings out of them. Public: a proof that
every reading fell inside the stated band. The project passes when a series inside the band
is accepted, a series with one excursion is refused, and an hour's readings cannot be
substituted afterwards because each hour was pinned down as it happened. Note the honest
limit: no SIM card is on this bench, so every cellular timing in the volume reads "not
measured, no SIM" and the modem's command sequence is replayed from a log.

**3. A lift controller and the building inspector.** The situation above, as a project.
Secret: the control logic, which situations it can be in and which moves it allows. Public:
the rule, that the doors never open while the car is between floors, and a proof that the
logic obeys it. The project passes when the honest logic is accepted, a logic with one extra
move that breaks the rule is refused at the point where the division leaves a remainder, and
the inspector's side never holds a line of the software.

**4. A calibration constant that never leaves the module.** A small radio module holds a
sensor calibration offset in flash. Secret: the offset. Public: two group elements, that
offset applied to two generators, and the claim that one number lies behind both. Three
objects cross the wire: a first message, a challenge computed as a hash of it, and one
response. The project passes when an honest transcript is accepted, one altered response byte
is refused, and a transcript built for a different number is refused. This is the smallest
complete zero-knowledge proof in the volume and the one place where the argument that the
verifier learns nothing is written out in full.

**5. A proposer that suggests and never decides.** A language model runs locally on one of
the boards, under a grammar that admits only well-formed candidates over the machine's own
vocabulary, and proposes the certificate that a solver then certifies or rejects. Secret and
public statement are unchanged from project 3. The project passes when every proposal that
reaches the proof has passed the certifier, when the solver's verdict and an independent
check agree on every round, and when the table reports the model's agreement rate beside what
a constant choice scores on the same rows. A reader learns the rule that keeps this honest: a
wrong proposal costs wasted work and can never make a false statement accepted, and an
agreement rate with no baseline beside it is a report of the class balance.

**6. A verifier that has to fit in 512 MB.** The smallest board on the bench has half a
gigabyte and no expansion header. Secret: the witness entries of one obligation. Public: that
the obligation holds, encoded as a circuit whose rows include the bit decomposition that makes
an inequality meaningful over a field. The project passes when the proof verifies with peak
resident memory under a stated ceiling, when changing one public value produces a refusal,
and when an out-of-range witness is refused by the prover. A reader learns the question an
embedded engineer actually faces, which is not whether a scheme is sound but whether its
verifier fits.

## What the work does not claim

None of the twenty-four projects has been built and run. Not one timing, not one energy
figure, not one agreement rate in this volume is a reading from a board.

That is stated on the first page and on every page where it matters, and it is worth being
precise about what it leaves. What exists is twenty-four designs worked out to the end: the
mathematics written out in full, the costs predicted with their arithmetic shown, the wiring
given pin by pin, and the success conditions fixed in advance. What does not exist is a single
reading from a single board. So every number in the volume is a prediction and says so. Where
a figure would show measured data it is drawn as a dashed outline of the shape the test
expects, hardware that is not on the bench is drawn as a dotted grey block with what the
absence costs, and the only measured timings anywhere are the original paper's own, taken on
the paper's own rented server and attributed to it.

One further absence is worth naming because it is easy to assume otherwise. One chapter
writes the volume's central theorem in a language a proof assistant can check. **No proof
assistant has checked it.** The toolchain is not installed on either machine on this bench, so
what that chapter carries is a proof written in a checkable language and not a proof a machine
has checked, and the chapter, the contents list and the repository all say so.

The nearest familiar comparison is a pre-registered experiment: the whole method is published
before any result is collected, so that a result cannot later be shaped to fit. A prediction
here that turns out wrong makes the chapter that made it more useful, not less, because the
chapter already says which reading would have refuted it.

No chapter claims a method is more secure than its source paper establishes. Where a language
model appears, in four of the twenty-four, it only ever proposes; something else always
decides.

## What it costs to follow

Three levels. Every figure below is an estimate at approximate European retail on Friday 6
November 2026, not a quotation and not the volume's own number, and each is to be checked
against a distributor before ordering. The volume itself carries no price anywhere.

**Nothing at all.** A laptop you already have and a recent Python. This lets you read all
twenty-four chapters, every figure and every proof, work any mathematical statement in the
volume with a pencil, and run the companion's one complete script, which computes the worked
example's four set sizes and checks them against the hand computation two pages earlier. That
script needs no package at all and is the one piece of this volume that runs today with
nothing. Every chapter's own success condition names a board, so no chapter passes without
one.

**One single-board computer and a few parts, in the region of a hundred euro.** A Raspberry
Pi 4 Model B with 8 GB, its official supply, a card, two LED modules with their own series
resistors so that nothing is soldered, and a network cable. This adds the ability to run the
same work on a board and see a verdict on a physical pin, and brings a good share of the chapters within reach. Which ones, and which need one more
part, is answered chapter by chapter in the companion's one-page guide rather than counted
here, because the answer depends on judgements the guide spells out and a number on this
page would not.

**The full bench, in the region of a thousand to twelve hundred euro.** Everything above plus
a microcontroller board, a second and third single-board computer, two sensor shields, a
vibration sensing board, a distance sensor, a CAN and RS485 interface, three cellular modems,
a touchscreen, a display, and two instruments. All twenty-four chapters as written, with four
standing limits no purchase removes: there is no SIM card, so every cellular measurement
reads "not measured, no SIM"; there is no oscilloscope or logic analyser, so a marker pin is
witnessed at the data acquisition board's ten microsecond resolution and no faster; the CAN
interface and the data acquisition board both want the same chip select and cannot be fitted
together, so two pairs of chapters are separate configurations of the same board; and one
board has no fan, so any run longer than a few minutes on it reads "not measured, thermal".

Two notes on the third level. The two most expensive items, about a third of that total, buy
no proof at all: they are instruments, and they exist so that a timing figure and an energy
figure can name what read them. Somebody who wants to learn the cryptography should buy them
last or not at all. And whether this bench holds a third single-board computer distinct from
the second is an open question in the volume's own record, which the volume says rather than
papers over.

## Who this is for, and where to start

Three readers, and one of them should not open a chapter at all.

**Somebody deciding whether this line of work is worth supporting,** who needs to know what
is genuinely hard, what it would cost to finish and what finishing would establish. Read this
page, then the companion's [foundations](docs/foundations.md), then the companion's
[tutorial](docs/tutorial.md). That is an evening's reading, it needs no hardware and no
mathematics beyond school algebra, and at the end of it you can say what a commitment is,
what a certificate is, why a device proving something about itself is a different thing from
a device reporting something about itself, and what makes any of it expensive. A reader who
stops there has understood the point of the volume and built nothing, which is a legitimate
place to stop.

**Somebody who builds embedded systems and has not met this cryptography.** Read the
[prerequisites](docs/prerequisites.md), the foundations and the tutorial, then take four
chapters in this order: [the price list](chapters/01-the-price-list.md), which every later
cost claim multiplies; [the sensor reading committed on the
microcontroller](chapters/02-a-sensor-reading-committed-on-the-microcontroller.md), which is
the shortest path from a reading to a committed value; [the module that proves one secret
behind two public points](chapters/07-the-esp32-proves-one-secret-behind-two-public.md),
which is where the argument that the verifier learns nothing is written out; and then [the
encoder chapter](chapters/03-the-modems-backoff-machine.md) followed immediately by [the
verifier chapter](chapters/04-two-group-elements.md), which are one pipeline and must be read
in that order, because the second verifies the file the first produces and verifies nothing
without it.

**Somebody who knows the cryptography and not the hardware.** Read the prerequisites, then
the [one-page guide](docs/guide.md) to each project, which says what each one assumes of the
bench and which chapter it is downstream of.

**Where to start, in three lines.** The companion's foundations, which run once from a state
machine to a proof. The companion's tutorial, which does one whole proof on four states by
hand. Then the price list if you want the cost, the verifier chapter if you want to see a
complete verifier, and [the doorway
counter](chapters/20-the-occupancy-counter-that-proves-its-committed-count.md) if you want
the clearest everyday case.

## What it would take to finish

Bench time, and a short list of named absences: no SIM card for the cellular work, no
oscilloscope, no cooling for one board, a licence gate on one sensor's firmware, and a proof
assistant that is not installed. Every chapter names what it is missing and what the absence
costs. Finishing would turn twenty-four predictions into twenty-four measurements, and would
answer, with readings rather than arithmetic, which of these proofs a device of this size can
actually afford to make.

---

The full contents are in [`CONTENTS.md`](CONTENTS.md), the volume's own front page is
[`README.md`](README.md), and what every part of it descends from is in
[`SOURCE.md`](SOURCE.md).
