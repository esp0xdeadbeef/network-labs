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
| `FS-166-HDS-010-SDS-010` | Renderer mini-SMT umbrella | `FS-166-HDS-010-SDS-010-SMS-900` (`renderer-nixos`, `renderer-nixos-p2p`, `renderer-nixos-clients`, `renderer-clab`, `renderer-wireguard`, `renderer-nebula`) |
| `FS-370-HDS-010-SDS-010` | Lane egress binding | `FS-370-HDS-010-SDS-010-SMS-050` |
| `FS-380-HDS-020-SDS-010` | Internet mode verification | `FS-380-HDS-020-SDS-010-SMS-050` |
| `FS-500-HDS-010-SDS-010` | Reachability + diagnostics + p2p | `FS-500-HDS-010-SDS-010-SMS-010`, `FS-500-HDS-010-SDS-010-SMS-030`, `FS-500-HDS-010-SDS-010-SMS-040` |
| `FS-540-HDS-010-SDS-010` | DNS resolver config | `FS-540-HDS-010-SDS-010-SMS-020` |
| `FS-800-HDS-030-SDS-030` | PPPoE pairing | `FS-800-HDS-030-SDS-030-SMS-010` |

This inventory intentionally follows the live manifest in
`GAMP/SMT/mini-smt/tests.nix`. Historical or prepared SIT directories that are
not in that manifest are not current mini-SMT evidence until the manifest
registers them again and their focused command passes.

Standalone row-local checks outside the active-lab runner may have SIT rows, but
they are not current active-lab SIT shims. Current examples are
`FS-310-HDS-010-SDS-010` and `FS-800-HDS-010-SDS-020`.
`FS-720-HDS-010-SDS-020` is prepared source only and remains `NOT OK` until an
executable focused runner is added.

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

Current SIT/HAT/SAT source-to-artifact prerequisite evidence was re-checked on
2026-06-27 with:

```bash
nix build --dry-run ".#nixosConfigurations.${attr}.config.system.build.toplevel" \
  --override-input network-labs path:/home/deadbeef/github/network-labs \
  --override-input network-renderer-nixos path:/home/deadbeef/github/network-renderer-nixos
```

The matrix log is `/tmp/network-labs-active-lab-sit-hat-sat-20260627T092319Z`.
It passed all three target attributes (`s-router-clab`, `s-router-nixos`,
`s-router-test-clients`) for SIT selectors `FS-166-HDS-010-SDS-010`,
`FS-370-HDS-010-SDS-010`, `FS-380-HDS-020-SDS-010`,
`FS-500-HDS-010-SDS-010`, `FS-540-HDS-010-SDS-010`, and
`FS-800-HDS-030-SDS-030`, plus `HAT emulated-isp-residential-testnet` and
`SAT`. This is source-to-artifact compile evidence only; it does not claim live
host HAT/SAT acceptance or production readiness.

2026-06-28 pre-HAT current-lab preflight supersedes the stale
`s-router-test-clients` part of that matrix until downstream locks consume the
fix. The failing trace was `FS-720-HDS-030-SDS-010-SMS-021`: the
access-endpoint renderer rejected the `FS-166-HDS-010-SDS-010-SMS-900`
renderer-entry profile even though that profile legitimately has zero endpoint
fixtures. Owning fix: `network-renderer-access-endpoint-nixos` commit
`c29b128` (`Allow no-endpoint CPM profiles`). Evidence commands exited 0:

```bash
bash tests/FS-720-HDS-030-SDS-010-SMS-021.sh
bash tests/run.sh
nix build --dry-run --no-link --print-out-paths \
  .#nixosConfigurations.s-router-{clab,nixos,test-clients}.config.system.build.nixos-shell \
  --override-input network-labs path:/home/deadbeef/github/network-labs \
  --override-input network-renderer-access-endpoint-nixos path:/home/deadbeef/github/network-renderer-access-endpoint-nixos
```

This remains source-to-artifact prerequisite evidence. HAT/SAT still require the
live host/site checks after the published renderer revision is selected by the
consumer lock.

2026-06-28 SIT prerequisite note for `FS-166-HDS-010-SDS-010`: the
`renderer-nixos-p2p` source fixture initially failed the `s-router-nixos`
dry-run with `FS-310-HDS-010-SDS-010-SMS-130` because its renderer-entry CPM
input lacked `policyRoutingAllocation` for interface `edge-a-b`. The fix adds
explicit CPM-owned allocation metadata in
`GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix` and covers
it in the focused mini-SMT test. The row remains source-to-artifact prerequisite
evidence only, not live HAT/SAT acceptance.
