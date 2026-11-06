#!/bin/sh
# Points this clone at the repository's own hooks. Run once after cloning:
#
#     sh tools/install-hooks.sh
#
# The commit-msg hook refuses attribution words (tools/no_trace_words.txt) and the
# pre-commit hook refuses the authoring files (tools/no_authoring_files.py).
#
# It sets core.hooksPath rather than copying into .git/hooks, which is what the sibling
# repositories do. The difference matters after an edit: a copied hook is a snapshot and
# goes stale the moment .githooks changes, with nothing to say so, while a configured path
# always runs the committed version.
#
# Both hooks are pure shell and depend on nothing but git and grep. An earlier pre-commit
# hook in a sibling repository preferred python3 and found the Windows Store alias stub
# instead of an interpreter, which aborted the first commit with a message about an app
# store and nothing about the repository. A hook that cannot run is a hook that gets
# switched off.
set -e

root=$(git rev-parse --show-toplevel)

for hook in pre-commit commit-msg; do
    if [ ! -f "$root/.githooks/$hook" ]; then
        echo "install-hooks: .githooks/$hook is missing" >&2
        exit 1
    fi
done

git -C "$root" config core.hooksPath .githooks
chmod +x "$root/.githooks/commit-msg" "$root/.githooks/pre-commit" 2>/dev/null || true
echo "hooks installed: $(git -C "$root" config --get core.hooksPath)"

echo
echo "Prove each one refuses before trusting it. A hook nobody has seen fail is not"
echo "known to be a hook. Build the known-positive message out of the word list,"
echo "so that this script never has to spell what it is testing for:"
echo
echo "    { echo subject; echo; grep -v '^#' tools/no_trace_words.txt | sed -n 5p; } > msg.tmp"
echo "    git hook run commit-msg -- msg.tmp     # must refuse and name the line"
echo "    rm msg.tmp"
