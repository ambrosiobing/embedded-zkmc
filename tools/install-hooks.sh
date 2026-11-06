#!/bin/sh
# Install this repository's hooks into the clone you are standing in.
#
#     sh tools/install-hooks.sh
#
# Hooks are not cloned, so every clone needs this once. Both hooks are pure shell and
# depend on nothing but git and grep: an earlier version of the pre-commit hook in a
# sibling repository preferred python3 and found the Windows Store alias stub instead of
# an interpreter, which aborted the first commit with a message about an app store and
# nothing about the repository. A hook that cannot run is a hook that gets switched off.
set -e

root=$(git rev-parse --show-toplevel)
cd "$root"

for hook in pre-commit commit-msg; do
    if [ ! -f ".githooks/$hook" ]; then
        echo "install-hooks: .githooks/$hook is missing" >&2
        exit 1
    fi
    cp ".githooks/$hook" ".git/hooks/$hook"
    chmod +x ".git/hooks/$hook" 2>/dev/null || true
    echo "installed .git/hooks/$hook"
done

echo
echo "Prove each one refuses before trusting it. A hook nobody has seen fail is not"
echo "known to be a hook. Build the known-positive message out of the word list,"
echo "so that this script never has to spell what it is testing for:"
echo
echo "    { echo subject; echo; grep -v '^#' tools/no_trace_words.txt | sed -n 5p; } > msg.tmp"
echo "    git hook run commit-msg -- msg.tmp     # must refuse and name the line"
echo "    rm msg.tmp"
