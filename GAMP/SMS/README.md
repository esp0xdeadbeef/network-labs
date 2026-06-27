# GAMP SMS Input Templates

This directory maps active-lab mini inputs to SMS-scoped template rows.

Each row directory uses the full SMS trace id only:

```text
GAMP/SMS/FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX/
```

The row `default.nix` records one or more deterministic `sourceInputs`. These
inputs are templates for focused construction/runtime POCs; they are not HAT or
SAT approval evidence.

## Current SMS Template Rows

| SMS Directory | Parent SDS | Mini-SMT ID(s) |
| --- | --- | --- |
| `FS-166-HDS-010-SDS-010-SMS-900` | `FS-166-HDS-010-SDS-010` | `renderer-nixos`, `renderer-nixos-p2p`, `renderer-nixos-clients`, `renderer-clab`, `renderer-wireguard`, `renderer-nebula` |
| `FS-310-HDS-010-SDS-010-SMS-030` | `FS-310-HDS-010-SDS-010` | `policy-router-relation-identity` |
| `FS-370-HDS-010-SDS-010-SMS-050` | `FS-370-HDS-010-SDS-010` | `lane-egress-binding` |
| `FS-380-HDS-020-SDS-010-SMS-050` | `FS-380-HDS-020-SDS-010` | `internet-mode-verification` |
| `FS-500-HDS-010-SDS-010-SMS-010` | `FS-500-HDS-010-SDS-010` | `reachability-decision` |
| `FS-500-HDS-010-SDS-010-SMS-030` | `FS-500-HDS-010-SDS-010` | `decision-reason-diagnostic` |
| `FS-500-HDS-010-SDS-010-SMS-040` | `FS-500-HDS-010-SDS-010` | `p2p-next-hop` |
| `FS-540-HDS-010-SDS-010-SMS-020` | `FS-540-HDS-010-SDS-010` | `dns-resolver-config` |
| `FS-720-HDS-010-SDS-020-SMS-020` | `FS-720-HDS-010-SDS-020` | `endpoint-harness-consumption` |
| `FS-800-HDS-010-SDS-020-SMS-040` | `FS-800-HDS-010-SDS-020` | `provider-access-default-route` |
| `FS-800-HDS-030-SDS-030-SMS-010` | `FS-800-HDS-030-SDS-030` | `pppoe-pairing` |
