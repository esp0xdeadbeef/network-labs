# SMT: FS-260-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-010-default-site-fabric-chain.md`

Status: NOT OK pending the controlled cold-stage live run.

This row models two isolated access tenants. The source tenant may initiate to
the destination tenant only through the downstream selector, policy point, and
downstream selector. Reply traffic is stateful; the destination tenant may not
initiate a new reverse flow.

The NixOS branch uses lab VLANs 393 and 394. The CLAB branch uses lab VLANs 395
and 396. `s-router-test-clients` hosts one static dual-stack endpoint on each
side of both branches. VLAN2 remains management-only and is not a packet-test
surface.

The live verifier must prove on both substrates:

- the NFM path carries `requiresPolicy = true` and includes policy;
- CPM and emitted runtime policy contain no direct source-access to
  destination-access new-flow shortcut;
- IPv4 and IPv6 source-initiated flows succeed with their replies;
- policy observes the source-initiated connection; and
- a new destination-to-source flow is denied.

No production VLAN, production reservation, or production Nebula endpoint is
used by this row.
