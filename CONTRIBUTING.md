# House rules

One page. Every rule here is checked by a tool in `tools/` or by a hook in `.githooks/`,
and the tool is named beside the rule.

## What this repository is

The Markdown edition of a volume, and nothing else. The LaTeX sources, the PDF and the
single-file HTML live in the author's catalogue and are never published, because a reader
of a repository wants a chapter, and a chapter here is a Markdown file with its figures
beside it. There is no assembled volume to download, by choice.

`chapters/`, `docs/`, `figures/`, `CONTENTS.md` and `PITFALLS.md` are **generated**. Do not
hand edit them: the next publish from the catalogue overwrites the file and the correction
is lost without a word. Fix the source and publish again.

## Files

- Markdown and SVG only, plus the scripts that check them. `tools/check_tree.py` holds the
  allowlist and a four-megabyte ceiling, because admitting a type without a ceiling is how
  a documentation repository becomes a download.
- No `.tex`, `.pdf`, `.html`, `.aux`, `.log` or `.toc`, tracked or untracked.
  `tools/no_authoring_files.py` and the pre-commit hook both refuse them; the hook catches
  it before the commit rather than after the push.
- No journal, no correspondence, nothing written in the third person about the author. The
  working record of this volume is kept minute by minute in the catalogue, which is local
  only and is never pushed.
- ASCII in prose and in code. Dates in full every time: weekday, day, month, year, as in
  "Friday 6 November 2026".
- No violent idioms. A process is stopped, a claim is withdrawn, a test refuses.

## No attribution of tools, assistants or models, anywhere

Not in a file, not in a commit message, not in a trailer. The commit-message hook refuses
one and names the line. The word list the hook matches lives in one place on purpose, so
that a search of this tree for any of those words finds nothing at all.

## Every claim carries its evidence

A number is measured, computed or absent, and the text says which. A measured number names
the instrument that produced it. A computed number shows its arithmetic. An absent number
reads "not measured" and gives the reason. A figure drawn dashed is a software stand-in and
a figure drawn dotted and grey is a part that is not on the bench; neither is ever presented
as a measurement.

## Before a commit

    sh tools/install-hooks.sh     once per clone; hooks are not cloned
    python tools/check_links.py
    python tools/check_tree.py
    python tools/no_authoring_files.py

Every commit is `ambrosio <ambrosiobing@gmail.com>`. Nothing is pushed by anyone but the
author.
