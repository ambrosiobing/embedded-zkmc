#!/usr/bin/env python3
"""Scan the tree and the full git history for attribution words.

The word list is tools/no_trace_words.txt, so this file carries none of the words it
looks for and passes its own scan. Every file git would commit (tracked, plus untracked
and not ignored) is read as text; binary files and the word list itself are skipped.
Then every commit message, author and committer line of `git log --all` is checked.
Exit 1 with one line per hit, 0 when clean.

The summary line says how many commits were read, and a shallow clone is called out
rather than passed over, because there the history is whatever that clone happens to hold
and a clean result says nothing about the commits it does not have.

    python tools/no_trace_scan.py            # the repository this file sits in
    python tools/no_trace_scan.py <root>     # another checkout
"""
import os
import subprocess
import sys

SKIP_DIRS = {".git", "build", "third_party", ".venv", "target", "__pycache__"}


def plural(n, noun):
    return "%d %s%s" % (n, noun, "" if n == 1 else "s")


def load_words(root):
    path = os.path.join(root, "tools", "no_trace_words.txt")
    words = []
    with open(path, encoding="ascii") as fh:
        for line in fh:
            line = line.strip()
            if line and not line.startswith("#"):
                words.append(line.lower())
    return path, words


def git_file_list(root):
    try:
        out = subprocess.run(
            ["git", "-C", root, "ls-files", "--cached", "--others", "--exclude-standard",
             "-z"],
            capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None
    return [p for p in out.stdout.decode("utf-8", "replace").split("\0") if p]


def walk_file_list(root):
    files = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in filenames:
            files.append(os.path.relpath(os.path.join(dirpath, name), root))
    return files


def scan_text(label, text, words, hits):
    for number, line in enumerate(text.splitlines(), 1):
        low = line.lower()
        for word in words:
            if word in low:
                hits.append("%s:%d: contains '%s'" % (label, number, word))


def main():
    root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else
                           os.path.join(os.path.dirname(__file__), ".."))
    list_path, words = load_words(root)
    hits = []

    files = git_file_list(root)
    if files is None:
        files = walk_file_list(root)
    for rel in files:
        path = os.path.join(root, rel)
        if os.path.abspath(path) == os.path.abspath(list_path):
            continue
        if any(part in SKIP_DIRS for part in rel.replace("\\", "/").split("/")):
            continue
        try:
            with open(path, "rb") as fh:
                data = fh.read()
        except OSError:
            continue
        if b"\0" in data:
            continue
        scan_text(rel, data.decode("utf-8", "replace"), words, hits)

    # How much history was read is printed, not assumed. A shallow clone answers
    # `git log --all` with whatever commits it happens to hold and exits 0, so a scan of
    # one commit out of four reports the same clean zero as a scan of all four. That is
    # how this ran in CI from the first push until Friday 6 November 2026:
    # actions/checkout defaults to fetch-depth 1, and the step was named for the history
    # it was not reading. The workflow now asks for the whole history, and the count and
    # the shallow flag below are what would have shown the gap.
    commits = 0
    try:
        log = subprocess.run(
            ["git", "-C", root, "log", "--all", "--format=%H%n%an <%ae>%n%cn <%ce>%n%B"],
            capture_output=True, check=True)
        text = log.stdout.decode("utf-8", "replace")
        scan_text("git log", text, words, hits)
        count = subprocess.run(["git", "-C", root, "rev-list", "--all", "--count"],
                               capture_output=True, check=True)
        commits = int(count.stdout.decode().strip() or 0)
        shallow = subprocess.run(["git", "-C", root, "rev-parse",
                                  "--is-shallow-repository"], capture_output=True)
        if shallow.stdout.decode().strip() == "true":
            print("no_trace_scan: THIS CLONE IS SHALLOW, so the %s it holds is not the"
                  % plural(commits, "commit"))
            print("no_trace_scan: whole history. Fetch it before trusting a clean")
            print("no_trace_scan: result: actions/checkout needs fetch-depth: 0.")
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("no_trace_scan: no history to scan (not a repository or no commit yet)")

    for hit in hits:
        print(hit)
    print("no_trace_scan: %s, %s, %s"
          % (plural(len(files), "file"), plural(commits, "commit"),
             plural(len(hits), "hit")))
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main())
