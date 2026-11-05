# GAMP SMS Input Templates

This directory maps active-lab mini inputs to SMS-scoped template rows.

Each row directory uses the full SMS trace id only:

```text
GAMP/SMS/FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX/
```

The row `default.nix` records one or more deterministic `sourceInputs`. These
inputs are templates for focused construction/runtime POCs; they are not HAT or
SAT approval evidence.

Every source input declares its `kind`. A repository-file template additionally
declares `sourcePath` (a repository-relative path that must exist) and
`maxRuntimeTargets`; a modeled source (validated canonical bundle, OpenConfig
candidate, controlled validation scheme, controlled-skip implementation set)
declares the kind and its own construction metadata instead, because no single
repository file is its source. Rows never store a runner or test path: the trace
id is the dispatch key and the entrypoint is derived from it
(`GAMP/SMT/mini-smt/README.md`, "Canonical entrypoints").

## Current Active-Runner SMS Template Rows

| SMS Directory | Parent SDS | Mini-SMT ID(s) |
| --- | --- | --- |
| `FS-166-HDS-010-SDS-010-SMS-901` | `FS-166-HDS-010-SDS-010` | `renderer-nixos` |
| `FS-166-HDS-010-SDS-010-SMS-902` | `FS-166-HDS-010-SDS-010` | `renderer-nixos-p2p` |
| `FS-166-HDS-010-SDS-010-SMS-903` | `FS-166-HDS-010-SDS-010` | `renderer-nixos-clients` |
| `FS-166-HDS-010-SDS-010-SMS-904` | `FS-166-HDS-010-SDS-010` | `renderer-clab` |
| `FS-166-HDS-010-SDS-010-SMS-905` | `FS-166-HDS-010-SDS-010` | `renderer-wireguard` |
| `FS-166-HDS-010-SDS-010-SMS-906` | `FS-166-HDS-010-SDS-010` | `renderer-nebula` |
| `FS-370-HDS-010-SDS-010-SMS-050` | `FS-370-HDS-010-SDS-010` | `lane-egress-binding` |
| `FS-380-HDS-020-SDS-010-SMS-050` | `FS-380-HDS-020-SDS-010` | `internet-mode-verification` |
| `FS-500-HDS-010-SDS-010-SMS-010` | `FS-500-HDS-010-SDS-010` | `reachability-decision` |
| `FS-500-HDS-010-SDS-010-SMS-030` | `FS-500-HDS-010-SDS-010` | `decision-reason-diagnostic` |
| `FS-500-HDS-010-SDS-010-SMS-040` | `FS-500-HDS-010-SDS-010` | `p2p-next-hop` |
| `FS-540-HDS-010-SDS-010-SMS-020` | `FS-540-HDS-010-SDS-010` | `dns-resolver-config` |
| `FS-540-HDS-010-SDS-010-SMS-045` | `FS-540-HDS-010-SDS-010` | `prod-like-access-recursive-dns` |
| `FS-800-HDS-030-SDS-030-SMS-010` | `FS-800-HDS-030-SDS-030` | `pppoe-pairing` |

Rows outside that table are source-stub-only or prepared-only unless their own
row says otherwise. Standalone row-local checks outside the active runner:
`FS-310-HDS-010-SDS-010-SMS-030` and
`FS-800-HDS-010-SDS-020-SMS-040`. Construction-only and intentionally not
active-lab runnable: `FS-720-HDS-010-SDS-020-SMS-020`.
