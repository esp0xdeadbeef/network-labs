# GAMP SDS Input Templates

This directory maps active-lab mini inputs to SDS-scoped template rows.

Each row directory uses the SDS trace id only:

```text
GAMP/SDS/FS-XXX-HDS-XXX-SDS-XXX/
```

The row `default.nix` must declare the SMS input rows it owns. Concrete source
files stay in the SMS row directories or in the existing mini-SMT renderer input
fixtures; the SDS row records the deterministic grouping so agents can select a
small proof surface without using the full active-lab, HAT, or SAT path.

## Current SDS Template Rows

| SDS Directory | Trace | SMS Inputs |
| --- | --- | --- |
| `FS-166-HDS-010-SDS-010` | Renderer mini-SMT umbrella | `FS-166-SMS-900` |
| `FS-310-HDS-010-SDS-010` | Policy router relation identity | `FS-310-SMS-030` |
| `FS-370-HDS-010-SDS-010` | Lane egress binding | `FS-370-SMS-050` |
| `FS-380-HDS-020-SDS-010` | Internet mode verification | `FS-380-SMS-050` |
| `FS-500-HDS-010-SDS-010` | Reachability + p2p next-hop | `FS-500-SMS-010`, `FS-500-SMS-030`, `FS-500-SMS-040` |
| `FS-540-HDS-010-SDS-010` | DNS resolver config | `FS-540-SMS-020` |
| `FS-720-HDS-010-SDS-020` | Endpoint harness consumption | `FS-720-SMS-020` |
| `FS-800-HDS-010-SDS-020` | Provider access default route | `FS-800-010-020-SMS-040` |
| `FS-800-HDS-030-SDS-030` | PPPoE pairing | `FS-800-SMS-010` |
