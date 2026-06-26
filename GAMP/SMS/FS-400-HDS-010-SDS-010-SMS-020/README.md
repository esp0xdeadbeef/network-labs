# FS-400-HDS-010-SDS-010-SMS-020

SMS template row for the `ula-nat66-selection` mini-SMT input.

The authoritative SMS lives in `network-codex-agent/GAMP/SMS/FS-400-HDS-010-SDS-010-SMS-020-ula-nat66-selection.md`.
This template row provides the network-labs source anchor for row-local mini-SMT evidence.

The intent fixture models a minimal topology exercising ULA NAT66 mode selection:
ULA tenant with `internetMode: nat66` and dedicated NAT66 egress prefix.

The CPM construction test at `network-control-plane-model/tests/FS-400-HDS-010-SDS-010-SMS-020-ula-nat66-explicit-contract.sh`
proves all SMS predicates via nix eval (construction-provable per VEB: construction-only).

Intended for focused deterministic SMT construction evidence, not HAT/SAT.
