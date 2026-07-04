# SDS Mini Source: FS-030-HDS-010-SDS-020

Software design mirror for FS-030 stage-topology enforcement.

The canonical design is
`network-codex-agent/GAMP/SDS/FS-030-HDS-010-SDS-020-stage-topology-enforcement.md`.
This network-labs row carries the row-local active-lab source that exercises the
compiler stage-topology boundary across the canonical five-stage path:
`access -> downstream-selector -> policy -> upstream-selector -> core`.

**Evidence Boundary:** active-lab mini-SMT runtime plus the compiler
construction test for `FS-030-HDS-010-SDS-020-SMS-010`.

The `FS-030-HDS-010-SDS-020-SMS-010` child is an active row-local mini-SMT/SIT
source. Current validation evidence must come from the locked active-lab full
loop and the row-specific network-codex-agent live wrapper.
