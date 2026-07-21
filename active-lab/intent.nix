# The canonical Hetz consumer still reads active-lab/intent.nix directly.
# Route that compatibility entrypoint through the host-specific selector so
# SMT/SIT stay no-runtime on Hetz while HAT/SAT still resolve to real intent.
import ../current-lab/intent-s-router-hetz.nix
