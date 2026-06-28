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
`../../tests/`. Shared files such as `mini-smt/default.nix`,
`mini-smt/tests.nix`, and `active-lab/intent.nix` are runner and shim
infrastructure only; SMT/SIT source inputs must live under trace-named row
directories.

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
`GAMP/SMT/FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX/`, declare the maximum runtime target count, and run
the real target lifecycle for that mini profile.

For `s-router-nixos`, runtime evidence means the real shutdown/rebuild route for
the mini profile, not `nixos-rebuild --target-host` and not a dry-run as the
final result. Aggregate layer-entry scripts may prove skip-boundary wiring, but
they are not row-level mini-SMT evidence.

SMT/SIT-only internet rows must still test internet behavior. Use a bounded
emulated provider, such as a PPPoE server or equivalent provider-side handoff,
and source that provider only from `vlan4`/`vlan5` DHCP. Do not turn internet
coverage into a skip. This is a fixture restriction for SMT/SIT rows, not a
real-environment inventory rule.

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
| `decision-reason-diagnostic` | `FS-500-HDS-010-SDS-010-SMS-030` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh` |
| `p2p-next-hop` | `FS-500-HDS-010-SDS-010-SMS-040` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` |
| `lane-egress-binding` | `FS-370-HDS-010-SDS-010-SMS-050` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-lane-egress-binding-only.sh` |
| `dns-resolver-config` | `FS-540-HDS-010-SDS-010-SMS-020` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-dns-resolver-config-only.sh` |
| `internet-mode-verification` | `FS-380-HDS-020-SDS-010-SMS-050` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-internet-mode-verification-only.sh` |
| `renderer-nixos` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh` |
| `renderer-nixos-p2p` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh` |
| `renderer-nixos-clients` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh` |
| `renderer-clab` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-clab-only.sh` |
| `renderer-wireguard` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-wireguard` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-wireguard-only.sh` |
| `renderer-nebula` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nebula` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-nebula-only.sh` |

All 13 manifest mini-SMT entries now have complete row-directory infrastructure
(SDS template rows, SMS template rows, SIT integration containers, and
SMT construction stubs). The authoritative manifest is
`GAMP/SMT/mini-smt/tests.nix`.

## GAMP SMS Universe Classification

As of 2026-06-27, `tests/test-gamp-canonical-sms-mirror.sh` verifies 509
canonical SMS trace IDs mirrored from `network-codex-agent/GAMP/SMS`, with no
`RDR` matches and no duplicate canonical SMS IDs. `network-labs/GAMP/SMS` and
`network-labs/GAMP/SMT` contain 512 SMS-scoped row directories: the 509
canonical mirrors plus three lab-local rows
(`FS-166-HDS-010-SDS-010-SMS-900`,
`FS-720-HDS-010-SDS-020-SMS-040`,
`FS-800-HDS-030-SDS-030-SMS-040`).

Current active-lab runnable SMT shims are exactly the 13 IDs in
`GAMP/SMT/mini-smt/tests.nix`, listed in the table above. They cover eight SMS
rows: `FS-166-HDS-010-SDS-010-SMS-900`,
`FS-370-HDS-010-SDS-010-SMS-050`,
`FS-380-HDS-020-SDS-010-SMS-050`,
`FS-500-HDS-010-SDS-010-SMS-010`,
`FS-500-HDS-010-SDS-010-SMS-030`,
`FS-500-HDS-010-SDS-010-SMS-040`,
`FS-540-HDS-010-SDS-010-SMS-020`, and
`FS-800-HDS-030-SDS-030-SMS-010`.

Standalone row-local SMT checks outside the active-lab runner are
`FS-310-HDS-010-SDS-010-SMS-030` via
`tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh`
and `FS-800-HDS-010-SDS-020-SMS-040` via
`tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh`.
They are construction/local-build evidence only and are not selected by
`tests/run-active-lab-mini-smt.sh`.

All remaining SMS-scoped rows are source-stub-only or prepared-only until a
focused command is registered and passes. `FS-720-HDS-010-SDS-020-SMS-020` is
explicitly `NOT OK`: its source fixture exists, but
`endpoint-harness-consumption` is not registered in
`GAMP/SMT/mini-smt/tests.nix` and no executable focused mini-SMT script exists.

HAT and SAT selection shims are separate from SMT:
`scripts/select-current-lab.sh HAT` selects
`GAMP/HAT/emulated-isp-residential-testnet`, and
`scripts/select-current-lab.sh SAT` selects `GAMP/SAT`. They are runnable source
selectors for later host/site validation; they do not make any SMT/SIT row `OK`.

2026-06-28 classification refresh:

- Canonical `network-codex-agent/GAMP/SMS` traces: 509.
- `network-labs/GAMP/SMS` and `network-labs/GAMP/SMT` trace directories: 512
  each, consisting of the 509 canonical mirrors plus lab-local
  `FS-166-HDS-010-SDS-010-SMS-900`,
  `FS-720-HDS-010-SDS-020-SMS-040`, and
  `FS-800-HDS-030-SDS-030-SMS-040`.
- Generated canonical source-stub SMT defaults: 411. These are not runnable
  mini-SMT evidence until a focused runner or owning repository proof is
  registered.
- Active mini-SMT selectors in `GAMP/SMT/mini-smt/tests.nix`: 13.
- Selectable SIT directories: 176. Of those, 109 are explicit canonical
  source-stub-only rows with no evidence command, and 17 `default.nix` rows
  currently record a non-null `evidence.command`.
- HAT/SAT source selectors: one HAT source
  `GAMP/HAT/emulated-isp-residential-testnet` and one SAT source `GAMP/SAT`.

## Status

The manifest entries above are current source-local SMT/SIT prerequisite
evidence, not HAT/SAT approval. Current active-lab SMT evidence was re-checked
on 2026-06-27 with:

```bash
NETWORK_FORWARDING_MODEL_ROOT=/home/deadbeef/github/network-forwarding-model bash tests/test-current-lab-selector.sh
bash tests/run-active-lab-mini-smt.sh all
nix build --dry-run ".#nixosConfigurations.${attr}.config.system.build.toplevel" \
  --override-input network-labs path:/home/deadbeef/github/network-labs \
  --override-input network-renderer-nixos path:/home/deadbeef/github/network-renderer-nixos
```

`tests/test-current-lab-selector.sh` exited 0. `tests/run-active-lab-mini-smt.sh
all` exited 0 for all 13 mini-SMT entries. The dry-run NixOS compile matrix in
`/tmp/network-labs-active-lab-smt-full-20260627T085247Z` passed all three target
attributes (`s-router-clab`, `s-router-nixos`, `s-router-test-clients`) for
`decision-reason-diagnostic`, `dns-resolver-config`,
`internet-mode-verification`, `lane-egress-binding`, `p2p-next-hop`,
`pppoe-pairing`, `reachability-decision`, `renderer-clab`, `renderer-nebula`,
`renderer-nixos`, `renderer-nixos-clients`, and `renderer-nixos-p2p`.
`/tmp/network-labs-active-lab-smt-wireguard-20260627T092056Z` passed the same
three target attributes for `renderer-wireguard`.

Focused ownership proof for `internet-mode-verification`: the source fixture
passed `s-router-clab` and `s-router-test-clients`, then failed
`s-router-nixos` in `network-renderer-nixos` on multi-lane tenant endpoint
resolution. After the renderer fix, the focused matrix in
`/tmp/network-labs-active-lab-smt-focused8-20260627T084959Z` passed all three
target attributes, and
`network-renderer-nixos/tests/test-policy-endpoint-multilane-tenant-resolution.sh`
exited 0. Do not promote rows outside this manifest from this inventory; add
executable evidence before changing any unrelated row to `OK`.

2026-06-28 pre-HAT current-lab preflight found the prior matrix stale for
`s-router-test-clients`: with `network-renderer-access-endpoint-nixos` at
`e4a8457`, the dry-run target
`.#nixosConfigurations.s-router-test-clients.config.system.build.nixos-shell`
failed on `FS-720-HDS-030-SDS-010-SMS-021` because the access-endpoint renderer
treated a valid no-endpoint CPM renderer-entry profile as a missing CPM contract.
Owning fix: `network-renderer-access-endpoint-nixos` commit `c29b128`
(`Allow no-endpoint CPM profiles`). Evidence commands exited 0:

```bash
bash tests/FS-720-HDS-030-SDS-010-SMS-021.sh
bash tests/run.sh
nix build --dry-run --no-link --print-out-paths \
  .#nixosConfigurations.s-router-test-clients.config.system.build.nixos-shell \
  --override-input network-labs path:/home/deadbeef/github/network-labs \
  --override-input network-renderer-access-endpoint-nixos path:/home/deadbeef/github/network-renderer-access-endpoint-nixos
```

The same local-override preflight also exited 0 for
`s-router-clab` and `s-router-nixos`. This is SMT/SIT prerequisite compile
evidence only; it is not HAT/SAT runtime acceptance.

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
