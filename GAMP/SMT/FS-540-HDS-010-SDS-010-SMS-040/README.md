# FS-540-HDS-010-SDS-010-SMS-040 SMT

Row-local source for Requester Lane Recursive Reachability Module.

**Validation Evidence Boundary:** construction-only — all predicates are provable with construction tests against compile-time output. No live host/runtime surface required.

Construction test: `network-codex-agent/tests/FS-540-HDS-010-SDS-010-SMS-040.sh`

The revised predicate must additionally reject a requester route that reaches
only the core ownership loopback instead of the selected provider-side
relation endpoint.

See SMS spec in network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-040-*.md
