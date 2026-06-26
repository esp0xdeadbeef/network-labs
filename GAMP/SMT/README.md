# GAMP SMT Workspace

This directory is the controlled Software Module Testing workspace for
`network-labs` GAMP validation work.

Use this directory for source-local SMT stubs, row notes, and focused module
evidence that belongs inside the controlled GAMP tree. Examples-only SMT rows
are indexed in `../../tests/SMT.md`; those rows may reference `../examples/`
fixtures, but they are not live acceptance evidence.

## Hardware-Related SMT Evidence

Hardware-related SMT is not a dry-run bucket. If an SMS concerns host adapters,
bridges, VLANs, VM interfaces, NixOS renderer output, CLAB host attachment, or
an `s-router-*` harness, the SMT evidence must include a real executable test
that uses the controlled source under:

```text
/home/deadbeef/github/network-labs/GAMP/*
```

Put the `network-labs` side of that test under `../../tests/`. If the SMS is
owned by another repository, add the focused implementation test there too, but
keep a `network-labs/tests/` test or harness that proves the controlled GAMP
source still exercises the behavior.

## Row-Local Files Only — No Shared Registries

Row-local mini-SMT fixtures live under `GAMP/SMT/<trace>/`. Each trace
creates its own `intent.nix`, `default.nix`, and a focused test under
`../../tests/`. **Do NOT edit shared files** — `mini-smt/default.nix`,
`mini-smt/tests.nix`, `GAMP/SMT/mini-smt/`, `active-lab/intent.nix`,
or any central registry. Row-local files only. No registration needed.

## Acceptable Hardware-Related SMT Evidence

- booting a minimal VM with the rendered adapter or route surface;
- running the smallest relevant `s-router-*` harness path;
- checking a live CLAB or NixOS fixture after it starts;
- recording bounded runtime probes from the VM or harness.

Static parsing, `nix-instantiate --parse`, renderer-only JSON inspection, and
`nix build --dry-run` can be prerequisites, but they must not be the final
evidence for hardware-related SMT.

## Mini Runtime SMT Rule

Runtime SMT must be small by construction. If an SMS only asks for one runtime
surface, such as "a renderer-input can start one NixOS container" or "one p2p
next-hop pair is valid", the test must not deploy the full active-lab, HAT, SAT,
or every `s-router-*` router. Put the row input under
`GAMP/SMT/mini-smt/`, declare the maximum runtime target count, and run
the real target lifecycle for that mini profile.

For `s-router-nixos`, runtime evidence means the real shutdown/rebuild route for
the mini profile, not `nixos-rebuild --target-host` and not a dry-run as the
final result. Aggregate layer-entry scripts may prove skip-boundary wiring, but
they are not row-level mini-SMT evidence.

Every mini SMT row must be independently runnable. Put row-local SMT inputs
under the full SMS trace directory:

```text
GAMP/SMT/FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX/
```

Declare the row in `GAMP/SMT/mini-smt/tests.nix` and make
`tests/run-active-lab-mini-smt.sh <mini-smt-id>` run exactly that row.
Renderer rows must have their own focused script, for example
`renderer-nixos-clients`, `renderer-clab`, `renderer-wireguard`, or
`renderer-nebula`; an aggregate all-renderers script is only a smoke harness.

Rows that start at intent-source must use a row-specific intent file, for
example `GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix`, declared in the
mini-SMT manifest. Use `active-lab.mkSource { intent = ...; }` in tests so
SMT/SIT evidence can select the row input without replacing the global
`active-lab/intent.nix`.

Every manifest input must also map to source template rows:

```text
GAMP/SDS/FS-XXX-HDS-XXX-SDS-XXX/
GAMP/SMS/FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX/
```

SDS/SMS rows are templates for future focused POC tests. SMT/SIT rows remain
the construction and integration evidence surfaces.

SIT rows are SDS-scoped integration containers:

```text
GAMP/SIT/FS-XXX-HDS-XXX-SDS-XXX/
```

Their `default.nix` must define one or more `smsInputs` keyed by full SMS trace
ids. This allows one SIT row to integrate multiple SMS atoms without losing the
SMS-level input provenance.

## On-Prem Host Adapter

Any SMT stub that needs an on-prem host attachment must use or reference:

```text
GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix
```

The template provides only the required VLAN2 management uplink: bridge
`vlan2`, parent `eth0`, VLAN ID `2`, IPv4 DHCP enabled, and IPv6 disabled.

VLAN2 missing from examples is allowed. VLAN2 missing from controlled `GAMP/**`
validation surfaces is not allowed.

## Current Mini-SMT Row Inventory

| Mini-SMT ID | Trace ID | SMT Dir | SDS Dir | SMS Dir | SIT Dir | Test Script |
| --- | --- | --- | --- | --- | --- | --- |
| `pppoe-pairing` | `FS-800-HDS-030-SDS-030-SMS-010` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-pppoe-pairing-only.sh` |
| `reachability-decision` | `FS-500-HDS-010-SDS-010-SMS-010` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-reachability-decision-only.sh` |
| `p2p-next-hop` | `FS-500-HDS-010-SDS-010-SMS-040` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` |
| `policy-router-relation-identity` | `FS-310-HDS-010-SDS-010-SMS-030` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-policy-router-relation-identity.sh` |
| `lane-egress-binding` | `FS-370-HDS-010-SDS-010-SMS-050` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-lane-egress-binding-only.sh` |
| `provider-access-default-route` | `FS-800-HDS-010-SDS-020-SMS-040` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-provider-access-default-route.sh` |
| `decision-reason-diagnostic` | `FS-500-HDS-010-SDS-010-SMS-030` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh` |
| `dns-resolver-config` | `FS-540-HDS-010-SDS-010-SMS-020` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-dns-resolver-config-only.sh` |
| `endpoint-harness-consumption` | `FS-720-HDS-010-SDS-020-SMS-020` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-endpoint-harness-consumption-only.sh` |
| `internet-mode-verification` | `FS-380-HDS-020-SDS-010-SMS-050` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-internet-mode-verification-only.sh` |
| `renderer-nixos` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime` | renderer-input | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh` |
| `renderer-nixos-p2p` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p` | renderer-input | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh` |
| `renderer-nixos-clients` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients` | renderer-input | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh` |
| `renderer-clab` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab` | renderer-input | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-clab-only.sh` |
| `renderer-wireguard` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-wireguard` | renderer-input | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-wireguard-only.sh` |
| `renderer-nebula` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nebula` | renderer-input | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-nebula-only.sh` |

All 16 mini-SMT entries now have complete row-directory infrastructure
(SDS template rows, SMS template rows, SIT integration containers, and
SMT construction stubs). The authoritative manifest is
`GAMP/SMT/mini-smt/tests.nix`.

## Status

No SMT rows are promoted by this directory yet. Add executable evidence before
changing any row to `OK`.

## Shared-File Policy (Anti-Contention)

**SMS workers must NOT edit `GAMP/SMT/mini-smt/default.nix` or
`GAMP/SMT/mini-smt/tests.nix`.** These are shared infrastructure files
maintained by the manager/infrastructure role. Batch editing by multiple
concurrent SMS workers causes lock contention and corrupts the manifest.

SMS workers are limited to:
- Their own row-local directory: `GAMP/SMT/<their-full-trace-ID>/`
  (`default.nix`, `intent.nix`, `README.md`)
- Their controlled SMS markdown file in `network-codex-agent/GAMP/SMS/`

Focused test scripts under `network-labs/tests/` that need lab/validator
entries in `mini-smt/default.nix` must route that infrastructure work to
the manager. The SMS worker records the row-local intent fixture and
reports the missing manifest entry as `manager_required`.
