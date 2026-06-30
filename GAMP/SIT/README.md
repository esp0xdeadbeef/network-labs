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
it in the focused mini-SMT test. A 2026-06-30 rerun found the remaining same
fixture gap: p2p endpoints also lacked CPM-owned `interfaceClass` and `explicit`
metadata. `network-labs@f9d21d2` adds those fields and extends the focused
mini-SMT test to assert them. These fixture corrections are source-to-artifact
prerequisite evidence only, not live HAT/SAT acceptance.

2026-06-30 live row closure for `FS-166-HDS-010-SDS-010` scoped to
`renderer-nixos`: `network-labs@b077ad6` selected `SMT renderer-nixos`, local
`nixos` lock `56239c47` consumed it, and the three local profiles built:
`s-router-nixos`
`/nix/store/3x94j69vaz05ahhvxw4c3c0ynlc36c24-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/m2y4zy7bkp4rj6bz7n6k252l323m2nfa-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/kw8m11ib6xqkw739qshci20jkdiq503j-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
After shutdown/rebuild of `192.168.1.17`, `192.168.1.19`, and
`192.168.1.18`, the live verifier in `network-codex-agent` passed:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nixos-runtime-check.sh --live
```

The live result proves the one-target renderer-input active-lab row:
`s-router-nixos` has the FS-166 artifact and running `poc-router`, while
`s-router-clab` and `s-router-test-clients` have the FS-166 artifact without
`poc-router` running. This is row-local SMT/SIT runtime evidence only and does
not promote HAT/SAT.

2026-06-30 live row closure for `FS-166-HDS-010-SDS-010` scoped to
`renderer-nixos-p2p`: `network-labs@50850a3` selected `SMT renderer-nixos-p2p`,
`network-labs@f9d21d2` completed the renderer-input CPM fixture, local `nixos`
lock `5f86907b` consumed it, and the three local profiles built:
`s-router-nixos`
`/nix/store/9d37x0mj3kdzz3p3fdpplyd4zxbjmayk-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/sfj8f085hqsqzs5daf9dxiz97yadm7wx-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/x1rb1r0dwv7bqfzkddl41p7bxq3p3b0s-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
After shutdown/rebuild of `192.168.1.17`, `192.168.1.19`, and
`192.168.1.18`, the live verifier in `network-codex-agent` passed:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nixos-p2p-runtime-check.sh --live
```

The live result proves the two-target p2p renderer-input active-lab row:
`s-router-nixos` has the FS-166 p2p artifact, running `edge-a` and `edge-b`,
and the rendered p2p bridge, while `s-router-clab` and `s-router-test-clients`
have the FS-166 p2p artifact without either edge container running. This is
row-local SMT/SIT runtime evidence only and does not promote HAT/SAT.

2026-06-30 live row closure for `FS-166-HDS-010-SDS-010` scoped to
`renderer-nixos-clients`: `network-labs@d494c16` selected
`SMT renderer-nixos-clients`, removed router runtime targets from the
access-endpoint CPM fixture, local `nixos` lock `c75190e5` consumed it, and the
three local profiles built: `s-router-nixos`
`/nix/store/6vvzch7wpwdhszs8d75xri8vbbdkl5ii-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/46zis36qs3r0p19vr8inrmnwa4pkn4n0-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/0b9hns2pz369q36nmhr9f8x8hwhv2aj2-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
After shutdown/rebuild of `192.168.1.17`, `192.168.1.19`, and
`192.168.1.18`, the live verifier in `network-codex-agent` passed:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_ACCESS_ENDPOINT_NIXOS_PATH=/home/deadbeef/github/network-renderer-access-endpoint-nixos \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-nixos-clients-runtime-check.sh --live
```

The live result proves the one-endpoint access renderer active-lab row:
`s-router-test-clients` has the FS-166 clients control-plane artifact,
access-endpoint provenance for `poc-client`, the rendered `client` bridge, and
running `container@poc-client.service`, while `s-router-nixos` and
`s-router-clab` do not run `poc-client`. This is row-local SMT/SIT runtime
evidence only and does not promote HAT/SAT.

2026-06-30 live row closure for `FS-166-HDS-010-SDS-010` scoped to
`renderer-clab`: `network-labs@ba3329c` selected `SMT renderer-clab`, fixed
the `s-router-clab` host-specific intent alias to consume
`GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix`,
local `nixos` lock `91fcc0f9` consumed it, and the three locked profiles built:
`s-router-nixos`
`/nix/store/767yywrwcsi70pladrvgqg4azpazbhk2-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/mzaj8xngpkqaspm9k6020d1kkzm04dlv-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/400s30klvnl0shxxm0hwgamz9bg8xxny-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
After shutdown/rebuild of `192.168.1.17`, `192.168.1.19`, and
`192.168.1.18`, the live verifier in `network-codex-agent` passed:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_CLAB_PATH=/home/deadbeef/github/network-renderer-containerlab-linux-backend \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-clab-runtime-check.sh --live
```

The live result proves the two-node CLAB renderer-input row:
`s-router-clab` has the FS-166 renderer-clab artifact, render-live
complete/success marker, `fabric.clab.yml` with `acme-lab-edge-a` and
`acme-lab-edge-b`, `br-layer-entry`, running Docker containers
`clab-fabric-acme-lab-edge-a` and `clab-fabric-acme-lab-edge-b`, and eth1 p2p
addresses `192.0.2.0/31` and `192.0.2.1/31`, while `s-router-nixos` and
`s-router-test-clients` do not run the CLAB edge runtime. This is row-local
SMT/SIT runtime evidence only and does not promote HAT/SAT.

2026-06-30 live row closure for `FS-166-HDS-010-SDS-010` scoped to
`renderer-wireguard`: `network-renderer-wireguard@fcaa109` fixed hostModule
runtime materialization by binding explicit `/run/secrets` key paths into
generated containers, `network-labs@d74172e` selected `SMT renderer-wireguard`
with one `wireguard-egress` runtime target and row-local SOPS secret, local
`nixos` lock `2b174716` consumed them, and the three locked profiles built:
`s-router-nixos`
`/nix/store/2s4f0k880339g6723kd8873pavq2z45n-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/c3mv5hngzqqi1c3mnh6lr7gqi8kliqjj-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/kb8bb4spfhj2y07l9fj6gps4sdik64p1-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
After shutdown/rebuild of `192.168.1.17`, `192.168.1.19`, and
`192.168.1.18`, the live verifier in `network-codex-agent` passed:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 \
NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
NETWORK_RENDERER_WIREGUARD_PATH=/home/deadbeef/github/network-renderer-wireguard \
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
bash scripts/fs166-active-lab-renderer-wireguard-runtime-check.sh --live
```

The live result proves the one-node WireGuard renderer-input row:
`s-router-nixos` has the FS-166 renderer-wireguard artifact, running
`container@wireguard-egress.service`, row-local
`/run/secrets/wireguard-mini-provider-private-key` present on the host and in
the container, `wg-layer-entry` with `10.66.90.2/32`, and active
`s88-provider-interface-wg-layer-entry-egress.service`, while `s-router-clab`
and `s-router-test-clients` do not run the WireGuard row runtime. This is
row-local SMT/SIT runtime evidence only and does not promote HAT/SAT.

2026-06-28 SAT prerequisite note: the SAT source initially failed the
`s-router-test-clients` dry-run with
`FS-725-HDS-020-SDS-010-SMS-010: MGMT_BRIDGE_ENDPOINT_TRAFFIC` because the
SAT inventory placed `nixos-emulated-sigma` and `clab-emulated-sigma` on the
management bridge without explicitly classifying them as management endpoints.
The owning fix is in `GAMP/SAT/inventory.nix`; the focused source-contract test
now asserts `bridge = "mgmt"`, `tenant = "mgmt"`, and `role = "management"` for
both rows. After the fix, SAT dry-runs passed for `s-router-clab`,
`s-router-nixos`, and `s-router-test-clients` with the active-lab SAT selector.
This remains source-to-artifact prerequisite evidence only.
