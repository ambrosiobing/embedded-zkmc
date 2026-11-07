# A temporary page, to settle what this host renders

Delete this file once it has been read. It exists because five rendering defects in this
volume have been found by looking at a rendered page and none by any local check, and
because two different repairs have now been made on guesses about what the host accepts.
One look at this page settles the question for every one of them.

**How to read it.** Every row below is numbered. A row is **good** if it shows typeset
mathematics with no red text and no error box. A row is **bad** if it shows an error box, red
text, or raw backslashes. Report the numbers of the bad rows and nothing else is needed.

---

## Part A, display mathematics in a fenced block

**A1.** A set brace written as a backslash escape, which is what the volume writes today.

```math
\mathcal{R} = \big\{\, x \in S \;:\; x \ne 0 \,\big\}
```

**A2.** The same set, with the braces spelled as words and the spacing left out.

```math
\mathcal{R} = \big\lbrace x \in S : x \ne 0 \big\rbrace
```

**A3.** The same again, with the spacing spelled as words.

```math
\mathcal{R} = \big\lbrace \thinspace x \in S \thickspace : \thickspace x \ne 0 \thinspace \big\rbrace
```

**A4.** Spacing spelled with the two oldest commands instead.

```math
\mathcal{R} = \big\lbrace \quad x \in S \quad : \quad x \ne 0 \quad \big\rbrace
```

**A5.** A row separator written as a double backslash, inside an aligned block.

```math
\begin{aligned} a &= b \\ c &= d \end{aligned}
```

**A6.** The same rows separated by the word form.

```math
\begin{aligned} a &= b \cr c &= d \end{aligned}
```

**A7.** A norm written as a backslash escape, and a cardinality written with bare bars.

```math
\| v \| \le |S|
```

**A8.** The same spelled as words.

```math
\Vert v \Vert \le \vert S \vert
```

**A9.** The probability operator, three ways, on one line.

```math
\Pr[E] \qquad \mathrm{Pr}[E] \qquad \max_{x} f(x)
```

**A10.** A negative thin space as an escape, then as a word.

```math
\langle\!\langle s \rangle\!\rangle \qquad \langle\negthinspace\langle s \rangle\negthinspace\rangle
```

---

## Part B, inline mathematics in a code span

**B1.** A set brace as an escape: $`\lbrace x : x \ne 0 \rbrace`$ then $`\{x : x \ne 0\}`$

**B2.** Spacing as escapes: $`a \, b \; c`$ and as words: $`a \thinspace b \thickspace c`$

**B3.** A norm: $`\|v\|`$ and $`\Vert v \Vert`$

**B4.** An underscore pair that emphasis could swallow: $`\mathbb{Z}_p`$ and $`\prod_{i=1}^{n} x_i`$

**B5.** The probability operator: $`\Pr[E] \le d / |\mathbb{F}|`$

---

## Part C, display mathematics in a dollar block

**C1.** The same set as A1, between dollar pairs rather than in a fence.

$$
\mathcal{R} = \big\{\, x \in S \;:\; x \ne 0 \,\big\}
$$

**C2.** The same as A2, between dollar pairs.

$$
\mathcal{R} = \big\lbrace x \in S : x \ne 0 \big\rbrace
$$

---

## What each answer would mean

- **A1 bad and A2 good** means a fenced block is not protected from the host's escape
  processing, and the volume must spell its braces as words.
- **A1 good** means fences are protected and the defect seen in chapter 10 has another cause.
- **A3 bad and A4 good** means the host's renderer does not know the newer spacing commands,
  and the volume should drop its thin and thick spaces rather than translate them.
- **A5 bad and A6 good** means a row separator must be spelled as a word.
- **A7 bad and A8 good** means a norm must be spelled as a word.
- **C1 and C2 against A1 and A2** say whether a fence and a dollar block behave the same.
- Any bad row in Part B says the inline form needs the same treatment as the display form.
