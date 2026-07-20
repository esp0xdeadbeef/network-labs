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
`tests/run-active-lab-mini-smt.sh <FS-...-SMS-... trace-id>` run exactly that row.
Renderer rows must have their own focused script, but the row selector and
source-input key must be the full `FS-...-HDS-...-SDS-...-SMS-...` trace ID; an
aggregate all-renderers script is only a smoke harness.

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
| `FS-800-HDS-030-SDS-030-SMS-010` | `FS-800-HDS-030-SDS-030-SMS-010` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-pppoe-pairing-only.sh` |
| `FS-500-HDS-010-SDS-010-SMS-010` | `FS-500-HDS-010-SDS-010-SMS-010` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-reachability-decision-only.sh` |
| `FS-500-HDS-010-SDS-010-SMS-030` | `FS-500-HDS-010-SDS-010-SMS-030` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh` |
| `FS-500-HDS-010-SDS-010-SMS-040` | `FS-500-HDS-010-SDS-010-SMS-040` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` |
| `FS-370-HDS-010-SDS-010-SMS-050` | `FS-370-HDS-010-SDS-010-SMS-050` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-lane-egress-binding-only.sh` |
| `FS-540-HDS-010-SDS-010-SMS-020` | `FS-540-HDS-010-SDS-010-SMS-020` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-dns-resolver-config-only.sh` |
| `FS-540-HDS-010-SDS-010-SMS-045` | `FS-540-HDS-010-SDS-010-SMS-045` | ✓ | ✓ | ✓ | ✓ | `tests/FS-540-HDS-010-SDS-010-SMS-045-prod-like-access-recursive-dns.sh` |
| `FS-380-HDS-020-SDS-010-SMS-050` | `FS-380-HDS-020-SDS-010-SMS-050` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-internet-mode-verification-only.sh` |
| `FS-800-HDS-010-SDS-020-SMS-040` | `FS-800-HDS-010-SDS-020-SMS-040` | ✓ | ✓ | ✓ | ✓ | `tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh` |
| `FS-166-HDS-010-SDS-010-SMS-900` | `FS-166-HDS-010-SDS-010-SMS-900` | ✓ | ✓ | ✓ | ✓ | `../network-codex-agent/scripts/smt-live-FS-166-HDS-010-SDS-010-SMS-900.sh` |
| `FS-166-HDS-010-SDS-010-SMS-901` | `FS-166-HDS-010-SDS-010-SMS-901` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh` |
| `FS-166-HDS-010-SDS-010-SMS-902` | `FS-166-HDS-010-SDS-010-SMS-902` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh` |
| `FS-166-HDS-010-SDS-010-SMS-903` | `FS-166-HDS-010-SDS-010-SMS-903` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh` |
| `FS-166-HDS-010-SDS-010-SMS-904` | `FS-166-HDS-010-SDS-010-SMS-904` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-clab-only.sh` |
| `FS-166-HDS-010-SDS-010-SMS-905` | `FS-166-HDS-010-SDS-010-SMS-905` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-wireguard-only.sh` |
| `FS-470-HDS-010-SDS-010-SMS-010` | `FS-470-HDS-010-SDS-010-SMS-010` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh` |
| `FS-166-HDS-010-SDS-010-SMS-906` | `FS-166-HDS-010-SDS-010-SMS-906` | ✓ | ✓ | ✓ | ✓ | `tests/test-active-lab-mini-smt-renderer-nebula-only.sh` |
| `FS-162-HDS-010-SDS-040-SMS-010` | `FS-162-HDS-010-SDS-040-SMS-010` | ✓ | ✓ | ✓ | ✓ | `tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh` |

All 18 tabled mini-SMT rows above have complete row-directory infrastructure
(SDS template rows, SMS template rows, SIT integration containers, and SMT
construction stubs). The full generated manifest is
`GAMP/SMT/mini-smt/tests.nix`.

## GAMP SMS Universe Classification

As of 2026-07-03, `tests/test-gamp-canonical-sms-mirror.sh` verifies 512
canonical SMS trace IDs mirrored from `network-codex-agent/GAMP/SMS`, with no
`RDR` matches and no duplicate canonical SMS IDs. `network-labs/GAMP/SMS` and
`network-labs/GAMP/SMT` contain 520 SMS-scoped row directories: the 512
canonical mirrors plus eight lab-local rows (`FS-166-HDS-010-SDS-010-SMS-901`
through `FS-166-HDS-010-SDS-010-SMS-906`,
`FS-720-HDS-010-SDS-020-SMS-040`, and
`FS-800-HDS-030-SDS-030-SMS-040`).

The table above lists the maintained active-lab/live runner subset. It covers
eleven SMS rows: `FS-166-HDS-010-SDS-010-SMS-900`,
`FS-370-HDS-010-SDS-010-SMS-050`,
`FS-380-HDS-020-SDS-010-SMS-050`,
`FS-470-HDS-010-SDS-010-SMS-010`,
`FS-500-HDS-010-SDS-010-SMS-010`,
`FS-500-HDS-010-SDS-010-SMS-030`,
`FS-500-HDS-010-SDS-010-SMS-040`,
`FS-540-HDS-010-SDS-010-SMS-020`,
`FS-540-HDS-010-SDS-010-SMS-045`,
`FS-800-HDS-010-SDS-020-SMS-040`, and
`FS-800-HDS-030-SDS-030-SMS-010`.

Standalone row-local SMT checks outside the active-lab runner include
`FS-310-HDS-010-SDS-010-SMS-030` via
`tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh`.
They are construction/local-build evidence only and are not selected by
`tests/run-active-lab-mini-smt.sh`.

SMS-scoped rows outside the table remain mirror/source rows for documentation
purposes until their own focused command or owning repository proof is
registered and passes.
`FS-720-HDS-010-SDS-020-SMS-020` is the construction-only exception: its
source fixture exists in this repo, the owning proof is
`network-codex-agent@d7f20211`, and it is intentionally not registered in
`GAMP/SMT/mini-smt/tests.nix` because the governing SMS excludes live runtime
evidence from this module scope.

HAT and SAT selection shims are separate from SMT:
`scripts/select-current-lab.sh HAT` selects
`GAMP/HAT/emulated-isp-residential-testnet`, and
`scripts/select-current-lab.sh SAT` selects `GAMP/SAT`. They are runnable source
selectors for later host/site validation; they do not make any SMT/SIT row `OK`.

2026-06-30 classification refresh:

- Guard command: `bash tests/test-active-lab-shim-classification.sh` (PASS).
- Canonical `network-codex-agent/GAMP/SMS` traces: 512, with zero `RDR`
  matches and zero duplicate canonical SMS IDs.
- `network-labs/GAMP/SMS` and `network-labs/GAMP/SMT` trace directories: 520
  each, consisting of the 512 canonical mirrors plus lab-local
  `FS-166-HDS-010-SDS-010-SMS-901` through
  `FS-166-HDS-010-SDS-010-SMS-906`,
  `FS-720-HDS-010-SDS-020-SMS-040`, and
  `FS-800-HDS-030-SDS-030-SMS-040`.
- `network-labs/GAMP/SDS` and `network-labs/GAMP/SIT` trace directories: 176
  each, all mirrored from canonical parent SDS rows.
- SMT defaults explicitly marked `source-stub-only`: 403. SIT defaults
  explicitly marked `source-stub-only`: 116. These row-local defaults remain
  mirror metadata until their manifest row, focused wrapper, and owning proof
  are checked for the selected trace.
- Active mini-SMT selectors in `GAMP/SMT/mini-smt/tests.nix`: 520.
- Selectable active-lab SIT selectors derived from the mini-SMT manifest: 176.
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
all` exited 0 for all mini-SMT entries present in the manifest at that revision.
The dry-run NixOS compile matrix in
`/tmp/network-labs-active-lab-smt-full-20260627T085247Z` passed all three target
attributes (`s-router-clab`, `s-router-nixos`, `s-router-test-clients`) for the
FS trace IDs now represented by `FS-500-HDS-010-SDS-010-SMS-030`,
`FS-540-HDS-010-SDS-010-SMS-020`, `FS-380-HDS-020-SDS-010-SMS-050`,
`FS-370-HDS-010-SDS-010-SMS-050`, `FS-500-HDS-010-SDS-010-SMS-040`,
`FS-800-HDS-030-SDS-030-SMS-010`, `FS-500-HDS-010-SDS-010-SMS-010`,
`FS-166-HDS-010-SDS-010-SMS-904`, `FS-166-HDS-010-SDS-010-SMS-906`,
`FS-166-HDS-010-SDS-010-SMS-901`, `FS-166-HDS-010-SDS-010-SMS-903`, and
`FS-166-HDS-010-SDS-010-SMS-902`.
`/tmp/network-labs-active-lab-smt-wireguard-20260627T092056Z` passed the same
three target attributes for `FS-166-HDS-010-SDS-010-SMS-905`.

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

2026-06-28 active-lab SMT sweep then found `FS-166-HDS-010-SDS-010-SMS-902` failed the
`s-router-nixos` dry-run with diagnostic
`FS-310-HDS-010-SDS-010-SMS-130`: interface `edge-a-b` had NixOS policy-routing
materialization but no CPM `policyRoutingAllocation`. The NixOS renderer was
correct; `runtime-nixos-p2p-cpm.nix` is a renderer-entry CPM fixture that skips
CPM, so the owning fix was to add explicit source=`control-plane-model`
allocation metadata to both p2p endpoint interface records and assert it in
`tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh`. Evidence
commands exited 0:

```bash
bash tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-902
nix build --dry-run --no-link --print-out-paths \
  path:/home/deadbeef/github/nixos#nixosConfigurations.s-router-nixos.config.system.build.nixos-shell \
  --override-input network-labs path:/home/deadbeef/github/network-labs
```

The resumed SMT sweep for `FS-166-HDS-010-SDS-010-SMS-902` and
`FS-166-HDS-010-SDS-010-SMS-905` passed
all three host dry-runs in
`/tmp/network-labs-active-lab-smt-sweep-resume-20260628T124259Z`.

2026-06-30 rerun of `FS-166-HDS-010-SDS-010-SMS-902` found the remaining renderer-input
fixture gap: the same p2p endpoints also lacked CPM-owned `interfaceClass` and
`explicit` metadata. This is not a NixOS renderer bug; the row enters at
`renderer-input` and therefore the fixture must already be CPM-complete. The
fix in `network-labs@f9d21d2` adds that metadata to
`runtime-nixos-p2p-cpm.nix`, and
`tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh` now asserts
both the CPM `policyRoutingAllocation` and p2p interface class fields.

2026-06-30 live `FS-166-HDS-010-SDS-010-SMS-901` row closure: `network-labs@b077ad6` selected
`SMT FS-166-HDS-010-SDS-010-SMS-901`, local `nixos` lock `56239c47` consumed it, and
`network-codex-agent@41f3e451` added the focused runtime verifier
`scripts/fs166-active-lab-renderer-nixos-runtime-check.sh`. Local builds passed
for all three active-lab hosts, then `s-router-nixos` (`192.168.1.17`),
`s-router-clab` (`192.168.1.19`), and `s-router-test-clients`
(`192.168.1.18`) were shut down and returned through the external rebuild path.
The live verifier passed and proved the one-target `poc-router` row is running
only on `s-router-nixos`, while `s-router-clab` and `s-router-test-clients`
expose the FS-166 artifact without running `poc-router`. This closes the
row-local `FS-166-HDS-010-SDS-010-SMS-901` SMT/SIT runtime predicate only; the other FS-166
renderer mini-SMT variants still require their own row-local live runs.

2026-06-30 live `FS-166-HDS-010-SDS-010-SMS-902` row closure: `network-labs@50850a3`
selected `SMT FS-166-HDS-010-SDS-010-SMS-902`, `network-labs@f9d21d2` completed the
renderer-input CPM fixture, local `nixos` lock `5f86907b` consumed it, and
`network-codex-agent@3895ed64` asserted the p2p interface class in
`scripts/fs166-active-lab-renderer-nixos-p2p-runtime-check.sh`. Local builds
passed for `s-router-nixos`
`/nix/store/9d37x0mj3kdzz3p3fdpplyd4zxbjmayk-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/sfj8f085hqsqzs5daf9dxiz97yadm7wx-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/x1rb1r0dwv7bqfzkddl41p7bxq3p3b0s-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
The three hosts were shut down and returned through the external rebuild path.
The live verifier passed and proved the two-target `edge-a`/`edge-b` p2p row
runs only on `s-router-nixos`, with the rendered p2p bridge present there, while
`s-router-clab` and `s-router-test-clients` expose the FS-166 p2p artifact
without running either edge container. This closes the row-local
`FS-166-HDS-010-SDS-010-SMS-902` SMT/SIT runtime predicate only and does not promote HAT/SAT.

2026-06-30 live `FS-166-HDS-010-SDS-010-SMS-903` row closure: `network-labs@d494c16`
selected `SMT FS-166-HDS-010-SDS-010-SMS-903`, removed router runtime targets from the
access-endpoint CPM fixture, local `nixos` lock `c75190e5` consumed it, and
`network-codex-agent@d79b5e17` added
`scripts/fs166-active-lab-renderer-nixos-clients-runtime-check.sh`. Local builds
passed for `s-router-nixos`
`/nix/store/6vvzch7wpwdhszs8d75xri8vbbdkl5ii-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/46zis36qs3r0p19vr8inrmnwa4pkn4n0-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/0b9hns2pz369q36nmhr9f8x8hwhv2aj2-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
The three hosts were shut down and returned through the external rebuild path.
The live verifier passed and proved `poc-client` runs only on
`s-router-test-clients`, with the FS-166 clients control-plane artifact,
access-endpoint provenance, and rendered `client` bridge present there, while
`s-router-nixos` and `s-router-clab` do not run `poc-client`. This closes the
row-local `FS-166-HDS-010-SDS-010-SMS-903` SMT/SIT runtime predicate only and does not
promote HAT/SAT.

2026-06-30 live `FS-166-HDS-010-SDS-010-SMS-904` row closure: `network-labs@ba3329c` selected
`SMT FS-166-HDS-010-SDS-010-SMS-904`, fixed the `s-router-clab` host-specific intent alias to
consume the CLAB CPM fixture instead of the default NixOS runtime CPM, local
`nixos` lock `91fcc0f9` consumed it, and
`network-codex-agent@644a5360` added
`scripts/fs166-active-lab-renderer-clab-runtime-check.sh`. Locked local builds
passed for `s-router-nixos`
`/nix/store/767yywrwcsi70pladrvgqg4azpazbhk2-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/mzaj8xngpkqaspm9k6020d1kkzm04dlv-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/400s30klvnl0shxxm0hwgamz9bg8xxny-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
The three hosts were shut down and returned through the external rebuild path.
The live verifier passed and proved `s-router-clab` rendered and deployed the
two-node Containerlab topology from `minimal-clab-cpm.nix`: render-live marker
complete/success, FS-166 renderer-clab control-plane artifact,
`fabric.clab.yml` with `acme-lab-edge-a` and `acme-lab-edge-b`,
`br-layer-entry`, running Docker containers `clab-fabric-acme-lab-edge-a` and
`clab-fabric-acme-lab-edge-b`, and eth1 p2p addresses `192.0.2.0/31` and
`192.0.2.1/31`. `s-router-nixos` and `s-router-test-clients` did not run the
CLAB edge runtime. This closes the row-local `FS-166-HDS-010-SDS-010-SMS-904` SMT/SIT runtime
predicate only and does not promote HAT/SAT.

2026-06-30 live `FS-166-HDS-010-SDS-010-SMS-905` row closure:
`network-renderer-wireguard@fcaa109` fixed hostModule runtime materialization
by binding explicit `/run/secrets` key paths into generated containers,
`network-labs@d74172e` selected `SMT FS-166-HDS-010-SDS-010-SMS-905` with one
`wireguard-egress` runtime target and row-local SOPS secret,
`network-codex-agent@f864df47` added
`scripts/fs166-active-lab-renderer-wireguard-runtime-check.sh`, and local
`nixos` lock `2b174716` consumed them. Locked local builds passed for
`s-router-nixos`
`/nix/store/2s4f0k880339g6723kd8873pavq2z45n-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/c3mv5hngzqqi1c3mnh6lr7gqi8kliqjj-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/kb8bb4spfhj2y07l9fj6gps4sdik64p1-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
The three hosts were shut down and returned through the external rebuild path.
The live verifier passed and proved `s-router-nixos` materialized the one-node
WireGuard row: FS-166 renderer-wireguard control-plane artifact, running
`container@wireguard-egress.service`, row-local
`/run/secrets/wireguard-mini-provider-private-key` present on the host and in
the container, `wg-layer-entry` with `10.66.90.2/32`, and active
`s88-provider-interface-wg-layer-entry-egress.service`. `s-router-clab` and
`s-router-test-clients` did not run the WireGuard row runtime. This closes the
row-local `FS-166-HDS-010-SDS-010-SMS-905` SMT/SIT runtime predicate only and does not
promote HAT/SAT.

2026-06-30 live `FS-166-HDS-010-SDS-010-SMS-906` row closure:
`network-renderer-nebula@b9f01fb` fixed hostModule runtime materialization by
binding persistent Nebula profile directories into generated containers,
`network-labs@4919505` selected `SMT FS-166-HDS-010-SDS-010-SMS-906` with two runtime targets
(`lab-lighthouse` and `lab-client-nebula`) plus row-local SOPS profile secrets,
`network-codex-agent@808593f3` added
`scripts/fs166-active-lab-renderer-nebula-runtime-check.sh`, and local `nixos`
lock `41f11073` consumed them. Locked local builds passed for `s-router-nixos`
`/nix/store/pbfyzvpzf99br18djxf9ym3cqf1mja7j-nixos-system-s-router-nixos-26.05.20260627.714a5f8`,
`s-router-clab`
`/nix/store/72yj65acvj25958hjlq1kyrqbchp3crh-nixos-system-s-router-clab-26.05.20260627.714a5f8`,
and `s-router-test-clients`
`/nix/store/d2awdxvzabd88g5vlwzgxmm648n30a5i-nixos-system-s-router-test-clients-26.05.20260627.714a5f8`.
The three hosts were shut down and returned through the external rebuild path
with fresh boot times on 2026-06-30 09:03. The live verifier passed and proved
`s-router-nixos` materialized the two-node Nebula row: FS-166 renderer-nebula
control-plane artifact, running `container@lab-lighthouse.service` and
`container@lab-client-nebula.service`, row-local Nebula profile files present on
the host and inside the containers, active `nebula@runtime.service` in both
containers, and client `nebula1` with `100.96.90.2/24`. `s-router-clab` and
`s-router-test-clients` did not run the Nebula row runtime. This closes the
row-local `FS-166-HDS-010-SDS-010-SMS-906` SMT/SIT runtime predicate only and does not promote
HAT/SAT.

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
