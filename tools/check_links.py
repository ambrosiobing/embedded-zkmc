#!/usr/bin/env python3
"""Every relative link in the published Markdown resolves, and every anchor has
a heading.

    python scripts/check_links.py

Why this exists. The figures in this repository are not where the converter puts
them: `publish.py` moves each chapter's five into the project they belong to and
rewrites 101 image links to match. A rewrite that is wrong produces a page of
broken images, and nothing else here would notice. The linter reads prose and the
name scan reads words; neither looks at a link.

External links are counted and left alone: whether a vendor's page still exists
is not something a repository check can answer, and a network call would make
this fail for reasons that have nothing to do with the commit.

Exit status is non-zero if anything is unresolved, so CI can use it directly.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

INLINE = re.compile(r"\[[^\]]*\]\(\s*<?([^)\s>]+)>?(?:\s+\"[^\"]*\")?\s*\)")
REFERENCE = re.compile(r"^\s*\[[^\]]+\]:\s*<?(\S+)>?\s*$", re.MULTILINE)
FENCE = re.compile(r"^```.*?^```", re.S | re.M)
HEADING = re.compile(r"^#{1,6}\s+(.+?)\s*$", re.M)

PROBLEMS: list[str] = []


def slugify(heading: str) -> str:
    """GitHub's anchor rule, near enough: lower case, punctuation dropped,
    spaces to hyphens. Inline markup is stripped first."""
    h = re.sub(r"`([^`]*)`", r"\1", heading)
    h = re.sub(r"\*\*?([^*]*)\*\*?", r"\1", h)
    h = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", h)
    h = h.lower()
    h = re.sub(r"[^\w\s-]", "", h)
    return re.sub(r"\s+", "-", h.strip())


def anchors(path: Path) -> set[str]:
    text = FENCE.sub("\n", path.read_text(encoding="utf-8"))
    return {slugify(m.group(1)) for m in HEADING.finditer(text)}


# Pages a reader reaches without any link from the volume, so an absent link is not a defect.
# Each needs its reason, because an exemption with no reason becomes a place to hide a page.
REACHED_ELSEWHERE = {
    "README.md": "the front page itself, where the walk starts",
    "CONTRIBUTING.md": "GitHub links it from its own issue and pull request forms",
}


def page_links(path: Path, known: set[Path]) -> set[Path]:
    """Every published page this one points at, following a directory link to its README.

    A link to `lean/` is a link to `lean/README.md`, because that is what the host renders
    when a reader opens the directory.
    """
    out: set[Path] = set()
    for m in re.finditer(r"\]\(([^)\s]+)", path.read_text(encoding="utf-8", errors="replace")):
        target = m.group(1).split("#")[0]
        if not target or target.startswith(("http", "mailto")):
            continue
        hit = (path.parent / target).resolve()
        if hit.is_dir():
            hit = hit / "README.md"
        if hit in known:
            out.add(hit)
    return out


def reachable_from(start: Path, known_list) -> set[Path]:
    known = set(known_list)
    seen, queue = {start}, [start]
    while queue:
        for nxt in page_links(queue.pop(), known):
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    return seen


def _self_test() -> None:
    """A check that cannot fail is not a check, so prove this one finds a planted orphan."""
    walked = reachable_from(ROOT / "README.md", sorted(ROOT.rglob("*.md")))
    assert (ROOT / "README.md") in walked, "self-test: the walk lost its own start"
    assert len(walked) > 1, "self-test: the walk followed no link at all"
    planted = ROOT / "chapters" / "99-no-page-links-to-this.md"
    assert planted not in walked, "self-test: a page that does not exist was called reachable"


def main() -> int:
    _self_test()
    files = sorted(ROOT.rglob("*.md"))
    files = [f for f in files
             if not any(part in (".git", "build", ".venv", "__pycache__")
                        for part in f.relative_to(ROOT).parts)]
    if not files:
        print("no Markdown found, which cannot be right")
        return 1

    anchor_cache: dict[Path, set[str]] = {}
    checked = external = 0

    for path in files:
        rel = path.relative_to(ROOT).as_posix()
        text = FENCE.sub("\n", path.read_text(encoding="utf-8"))
        targets = [m.group(1) for m in INLINE.finditer(text)]
        targets += [m.group(1) for m in REFERENCE.finditer(text)]

        for target in targets:
            if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", target) or target.startswith("//"):
                external += 1
                continue
            checked += 1

            frag = ""
            if "#" in target:
                target, frag = target.split("#", 1)

            if target:
                dest = (path.parent / target).resolve()
                if not dest.exists():
                    PROBLEMS.append("%s: names %s, which does not exist"
                                    % (rel, target))
                    continue
            else:
                dest = path          # a bare #fragment, in this file

            if frag:
                if dest.is_dir():
                    PROBLEMS.append("%s: %s#%s points a fragment at a directory"
                                    % (rel, target, frag))
                    continue
                if dest.suffix == ".md":
                    if dest not in anchor_cache:
                        anchor_cache[dest] = anchors(dest)
                    if frag.lower() not in anchor_cache[dest]:
                        PROBLEMS.append("%s: no heading for #%s in %s"
                                        % (rel, frag, target or dest.name))

    # A link that resolves is only half of it. On Sunday 8 November 2026
    # chapters/25-appendix.md was published and named by neither README.md nor
    # CONTENTS.md, which is the table of the twenty-four numbered chapters, so
    # it was reachable from no page at all. Every check here passed while that
    # was true, because an orphan has no link to be broken. A dead link still
    # reads as a link and somebody eventually clicks it; an orphan reads as
    # nothing. The same defect was found in four sibling volumes the same day,
    # all from one cause: the generated table carries the numbered chapters and
    # every volume also publishes front matter and an appendix outside that
    # range.
    # Reachability is walked from the front page rather than read off two files. The first
    # version of this check named README.md and CONTENTS.md and looked only at chapters/,
    # which is where the appendix had gone missing. On Thursday 12 November 2026 that version
    # passed while AUTHORING.md, the contract every chapter follows and the file that carries
    # the bench inventory, was linked from nothing at all: not a chapter, so not looked at.
    # A page one hop further out is just as unreachable as a page in chapters/.
    reachable = reachable_from(ROOT / "README.md", files)
    for page in files:
        rel = page.relative_to(ROOT).as_posix()
        if page not in reachable and rel not in REACHED_ELSEWHERE:
            PROBLEMS.append(
                "%s is published and no page links to it, directly or through any chain "
                "of links from README.md, so a reader arriving at the front page cannot "
                "find it" % rel)
    chapters = sorted((ROOT / "chapters").glob("*.md"))

    print("%d Markdown files, %d relative links checked, %d external links left alone, "
          "%d chapters all reachable from the front page or the contents table"
          % (len(files), checked, external, len(chapters)))
    if PROBLEMS:
        print("\n%d problem(s):" % len(PROBLEMS))
        for p in PROBLEMS:
            print("  " + p)
        return 1
    print("every relative link resolves and every anchor has a heading")
    return 0


if __name__ == "__main__":
    sys.exit(main())
