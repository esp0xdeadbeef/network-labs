# SMT Construction Row: FS-162-HDS-010-SDS-040-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md`

Status: NOT OK - focused construction proof not executed.

This row requires `network-renderer-openconfig` to consume its own CPM artifact
compiled from the canonical isolated
`FS-230-HDS-010-SDS-010-SMS-040` intent and the same compiler/CPM pins used by
the NixOS and CLAB construction paths. Acceptance proves that all three
realizations have an identical normalized IPv6 UDP/4242, no-NAT66,
preserve-source, stateful-return, selected-path, and no-inherited-egress
posture. Full CPM hashes may differ because the realization inventories are
explicitly different. OpenConfig model completeness is reported separately
and shall remain NOT OK when a required model mapping is absent.

The owning focused command is:

```bash
bash tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh
```

No live OpenConfig device, production VLAN, production address, or production
secret is in scope.

Title slug: `s-router-prod-comparable-projection`
