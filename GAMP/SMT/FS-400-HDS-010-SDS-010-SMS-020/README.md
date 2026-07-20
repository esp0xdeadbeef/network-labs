# FS-400-HDS-010-SDS-010-SMS-020

SMT template row for the `ula-nat66-selection` mini-SMT input.

Construction test: `network-control-plane-model/tests/FS-400-HDS-010-SDS-010-SMS-020.sh`
Validation Evidence Boundary: construction-only — all predicates proven via CPM nix eval.

This row-local intent fixture models a minimal tenant-topology exercising ULA NAT66 mode selection
with dedicated NAT66 egress prefix. Intended for focused deterministic SMT construction evidence.

The authoritative SMT row lives in `network-codex-agent/GAMP/SMT/README.md` row 234.
