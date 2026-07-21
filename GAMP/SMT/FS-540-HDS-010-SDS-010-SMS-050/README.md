# FS-540-HDS-010-SDS-010-SMS-050 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-050-openconfig-dns-peer-posture.md`

Status: OK.

The deterministic validation scheme compiles and realizes the controlled
`FS-540-HDS-010-SDS-010-SMS-045` DNS source once. NixOS, CLAB, and OpenConfig
then validate the same canonical bundle identity. OpenConfig projects the
named core resolver, explicit egress choice, dual-stack transport coverage,
iterative recursion, disabled public fallback, and local-only lateral policy
without consuming peer-renderer output.

The focused construction test checks the valid projection, the explicit
pinned-model limitation, and all ten seeded negative cases with exact
diagnostics, exit status `2`, and recovery to the unchanged valid input.
