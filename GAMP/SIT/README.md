# GAMP SIT Workspace

This directory is the controlled System Integration Testing workspace for
`network-labs` GAMP validation work.

Use this directory for SIT stubs, row notes, and locked source-to-artifact
integration evidence. A SIT row must name the source path, artifact path,
command, and observed result. It is not HAT or SAT evidence unless the owning
runtime harness also records live evidence.

## Hardware-Related SIT Evidence

Hardware-related SIT must integrate the controlled source with a real
execution surface. It must not stop at dry-running config generation.

Use the controlled source root:

```text
/home/deadbeef/github/network-labs/GAMP/*
```

Put the `network-labs` integration test under `../../tests/`. If the SMS is
implemented in another repository, keep the owning repo test there and add a
`network-labs/tests/` SIT-oriented test or harness that consumes the GAMP source
and checks the integrated behavior.

For NixOS-renderer or host-network SIT, prefer the smallest real path that can
exercise the artifact:

- build and boot a minimal VM from the GAMP source;
- run the smallest relevant `s-router-*` harness such as `s-router-nixos`,
  `s-router-clab`, or `s-router-test-clients`;
- collect route, interface, lease, service, firewall, or reachability probes
  from inside the VM or harness context.

A SIT row may cite dry-run, parse, or render checks as prerequisites, but the
row remains blocked until the real VM/harness command and observed result are
recorded.

## Row Directory Layout

SIT row directories are SDS-scoped:

```text
GAMP/SIT/FS-XXX-HDS-XXX-SDS-XXX/
```

Each row `default.nix` must define one or more SMS inputs with full SMS trace
ids:

```nix
{
  layer = "SIT";
  traceId = "FS-500-HDS-010-SDS-010";
  smsInputs = {
    "FS-500-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix";
    };
    "FS-500-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix";
    };
  };
}
```

This mirrors the current validation model: many SIT rows are SDS-level
integration rows, while some SIT evidence must explicitly test one or more
SMS-level inputs.

## Mini-SMT Row-Level Integration

SIT rows may consume one or more SMS inputs from the mini-SMT system.
Each mini-SMT entry in `GAMP/SMT/mini-smt/tests.nix` has a corresponding
SIT row at the SDS-scoped level. The current SIT row inventory:

| SIT Directory | Trace | SMS Inputs |
| --- | --- | --- |
| `FS-166-HDS-010-SDS-010` | Renderer mini-SMT umbrella | `FS-166-SMS-900` |
| `FS-310-HDS-010-SDS-010` | Policy router relation identity | `FS-310-SMS-030` |
| `FS-370-HDS-010-SDS-010` | Lane egress binding | `FS-370-SMS-050` |
| `FS-380-HDS-020-SDS-010` | Internet mode verification | `FS-380-SMS-050` |
| `FS-500-HDS-010-SDS-010` | Reachability + p2p | `FS-500-SMS-010`, `FS-500-SMS-040` |
| `FS-540-HDS-010-SDS-010` | DNS resolver config | `FS-540-SMS-020` |
| `FS-720-HDS-010-SDS-020` | Endpoint harness consumption | `FS-720-SMS-020` |
| `FS-800-HDS-010-SDS-020` | Provider access default route | `FS-800-010-020-SMS-040` |
| `FS-800-HDS-030-SDS-030` | PPPoE pairing | `FS-800-SMS-010` |

## On-Prem Host Adapter

Any SIT stub that needs an on-prem host attachment must use or reference:

```text
GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix
```

The template provides only the required VLAN2 management uplink: bridge
`vlan2`, parent `eth0`, VLAN ID `2`, IPv4 DHCP enabled, and IPv6 disabled.

VLAN2 missing from examples is allowed. VLAN2 missing from controlled `GAMP/**`
validation surfaces is not allowed.

## Status

No SIT rows are promoted by this directory yet. Add executable integration
evidence before changing any row to `OK`.
