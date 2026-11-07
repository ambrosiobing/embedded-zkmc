/-
ZKMC.lean: the library root.

Builds. `lake build` passes on a clean checkout in GitHub Actions, pinned to
leanprover/lean4:v4.35.0, with no Mathlib, so a kernel has accepted this file and
every module it imports. That is a verdict about elaboration, not about meaning: the
theorems still have to say what they should, and STATUS.md records one that compiled
and proved nothing.
-/

import ZKMC.Basic
import ZKMC.Descent
import ZKMC.Theorem32
import ZKMC.Gaps
