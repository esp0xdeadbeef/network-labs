# active-lab mini SMT

This directory contains the deliberately small active-lab SMT runner manifest.
A mini SMT
proves one SMS/SMT atom only. It must not pull in the full active-lab, HAT, SAT,
or a broad `s-router-*` deployment. Runtime SMT evidence still requires a real
runtime run, but that run must use a live mini profile for exactly the targets
in the fixture.

The rule is:

- one trace-chain ID per mini-lab;
- one behavior under test;
- one explicit source entry per runtime mini-lab (`intent-source`,
  `control-plane-input`, or `renderer-input`), or `source = null` with
  `evidenceBoundary = "construction-only"` for rows with no runtime topology;
- one focused script per mini-lab, runnable through
  `tests/run-active-lab-mini-smt.sh <FS-...-SMS-... trace-id>`;
- a declared maximum runtime-target count;
- no implicit dependencies on full `s-router-nixos`, `s-router-clab`, or
  `s-router-test-clients`;
- no aggregate-only evidence for an SMT row;
- seeded negatives must mutate only the atom under test.

`../FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix` is the current
active-lab runtime POC input. It is a network-labs-owned renderer-input CPM
object for one `poc-router` container on `s-router-nixos`. The NixOS runtime
acceptance path is still the real shutdown/rebuild route; the point is that the
active-lab input is small enough to prove only the container-start
materialization surface.

The top-level `../../../active-lab/inventory-nixos.nix` is only a provenance
stub for `FS-166-HDS-010-SDS-010-SMS-901`. It must point at this CPM input, the
focused test, and the mini-SMT runner. It is not a broad active-lab inventory
and it must not be empty. Keep unrelated active-lab host inventories or
placeholder files out of the top level; add row-local sources here instead.

Do not use `vlan2` as test infrastructure. `vlan2` is the runtime
management/reachability network for the VM/host lifecycle, not a mini-SMT DHCP
uplink or dataplane path. If a mini POC needs DHCP uplinks, use `vlan4` or
`vlan5` and make that input explicit. Generated host inventories must keep
the VLAN as the link mode (`mode = "vlan"`) and express DHCP only as the IP
method (`ipv4.method = "dhcp"`).

For SMT/SIT-only internet behavior, do not skip the internet path. Model a
small emulated provider instead, such as an emulated PPPoE server or equivalent
provider-side handoff. That emulated provider may source its upstream only from
`vlan4`/`vlan5` DHCP. This restriction is for SMT/SIT fixtures only; real
environment inventories are governed by their own environment specs.

Mini SMT/SIT rows may use their own `intent.nix` files. Do not rewrite
`../../../active-lab/intent.nix` for each row. Put row-specific SMT sources
under `../FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX/`, declare them in `tests.nix`, and
load them with the active-lab source helper:

```nix
let
  activeLab = import ../../../active-lab;
in
activeLab.mkSource {
  intent = ../FS-500-HDS-010-SDS-010-SMS-040/intent.nix;
}
```

The runner exposes the selected source:

```sh
tests/run-active-lab-mini-smt.sh --source FS-500-HDS-010-SDS-010-SMS-040
```

Current mini-labs:

| ID | Trace ID | Test | Scope |
| --- | --- | --- | --- |
| `FS-800-HDS-030-SDS-030-SMS-010` | `FS-800-HDS-030-SDS-030-SMS-010` | `tests/test-active-lab-mini-smt-pppoe-pairing-only.sh` | Two-target PPPoE provider/customer pairing and fallback rejection. |
| `FS-500-HDS-010-SDS-010-SMS-010` | `FS-500-HDS-010-SDS-010-SMS-010` | `tests/test-active-lab-mini-smt-reachability-decision-only.sh` | Two-target reachability decision result classification. |
| `FS-500-HDS-010-SDS-010-SMS-030` | `FS-500-HDS-010-SDS-010-SMS-030` | `tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh` | Two-target decision reason diagnostics for reachability validation. |
| `FS-500-HDS-010-SDS-010-SMS-040` | `FS-500-HDS-010-SDS-010-SMS-040` | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` | Two-router, one-link p2p next-hop pairing. |
| `FS-370-HDS-010-SDS-010-SMS-050` | `FS-370-HDS-010-SDS-010-SMS-050` | `tests/test-active-lab-mini-smt-lane-egress-binding-only.sh` | Five-target access/downstream-selector/policy/upstream-selector/testnet lane egress binding classification. |
| `FS-540-HDS-010-SDS-010-SMS-020` | `FS-540-HDS-010-SDS-010-SMS-020` | `tests/test-active-lab-mini-smt-dns-resolver-config-only.sh` | Five-target DNS resolver configuration authority. |
| `FS-380-HDS-020-SDS-010-SMS-050` | `FS-380-HDS-020-SDS-010-SMS-050` | `tests/test-active-lab-mini-smt-internet-mode-verification-only.sh` | SMT/SIT-only emulated PPPoE provider with semantic ISP uplinks realized as VLAN4/VLAN5 DHCP in inventory; skips, NAT, and VLAN2 rejected. |
| `FS-800-HDS-010-SDS-020-SMS-040` | `FS-800-HDS-010-SDS-020-SMS-040` | `tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh` | Provider-access default route selection over the smallest canonical policy path plus PPPoE-side core. |
| `FS-166-HDS-010-SDS-010-SMS-900` | `FS-166-HDS-010-SDS-010-SMS-900` | `../network-codex-agent/scripts/smt-live-FS-166-HDS-010-SDS-010-SMS-900.sh` | Construction-only source-map umbrella for renderer-entry child rows `FS-166-HDS-010-SDS-010-SMS-901` through `FS-166-HDS-010-SDS-010-SMS-906`; zero runtime targets. |
| `FS-166-HDS-010-SDS-010-SMS-901` | `FS-166-HDS-010-SDS-010-SMS-901` | `../network-codex-agent/scripts/smt-live-FS-166-HDS-010-SDS-010-SMS-901.sh` | One `poc-router` NixOS runtime container from explicit CPM input through the full-trace live wrapper. |
| `FS-166-HDS-010-SDS-010-SMS-902` | `FS-166-HDS-010-SDS-010-SMS-902` | `tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh` | Two NixOS runtime containers on one p2p bridge from explicit CPM input. |
| `FS-166-HDS-010-SDS-010-SMS-903` | `FS-166-HDS-010-SDS-010-SMS-903` | `tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh` | One endpoint client container from explicit CPM input. |
| `FS-166-HDS-010-SDS-010-SMS-904` | `FS-166-HDS-010-SDS-010-SMS-904` | `tests/test-active-lab-mini-smt-renderer-clab-only.sh` | Minimal two-node Containerlab topology from explicit CPM input. |
| `FS-166-HDS-010-SDS-010-SMS-905` | `FS-166-HDS-010-SDS-010-SMS-905` | `tests/test-active-lab-mini-smt-renderer-wireguard-only.sh` | WireGuard provider runtime module from explicit CPM input. |
| `FS-470-HDS-010-SDS-010-SMS-010` | `FS-470-HDS-010-SDS-010-SMS-010` | `tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh` | WireGuard remote-egress provider runtime imported into one active-lab container from explicit CPM providerContracts. |
| `FS-166-HDS-010-SDS-010-SMS-906` | `FS-166-HDS-010-SDS-010-SMS-906` | `tests/test-active-lab-mini-smt-renderer-nebula-only.sh` | One Nebula overlay with lighthouse/client nodes from explicit CPM input. |
| `FS-162-HDS-010-SDS-040-SMS-010` | `FS-162-HDS-010-SDS-040-SMS-010` | `tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh` | Construction-only direct CPM comparison for the normalized FS-230 posture through OpenConfig; zero runtime targets. |

All tabled mini-SMT rows now have complete SDS, SMS, SIT, and SMT row-directory infrastructure.
See `GAMP/SMT/README.md` for the full inventory table and `GAMP/SDS/README.md`,
`GAMP/SMS/README.md` for the template row indexes.

Current `renderer-nixos` source inspection:

```sh
tests/run-active-lab-mini-smt.sh --source FS-166-HDS-010-SDS-010-SMS-901
```

resolves `GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix`. The focused row test:

```sh
tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-901
```

exited 0 on 2026-06-27 and proved one `poc-router` renderer-input container
from explicit CPM input with VLAN2 management preserved. This remains SMT/SIT
prerequisite evidence only; it is not HAT/SAT runtime approval.

Worked row examples:

- `FS-800-HDS-030-SDS-030-SMS-010` is the preferred small proof for PPPoE
  pairing. It uses a row-local `intent.nix` and proves
  only PPPoE provider/customer pairing, fallback rejection, and transport
  classification. It may start at most `pppoe-client` and `pppoe-server`.
- `FS-500-HDS-010-SDS-010-SMS-040` is the preferred small proof for p2p
  next-hop selection. It uses a row-local `intent.nix` and proves
  only one p2p link, two router endpoints, and one next-hop route atom. It may
  start at most `router-a` and `router-b`.
- `FS-500-HDS-010-SDS-010-SMS-010` is the preferred small proof for reachability
  decision classification. It uses a separate row-local `intent.nix`
  and proves only structured allow/deny reachability decision classification.
  The parent `GAMP/SIT/FS-500-HDS-010-SDS-010/default.nix` intentionally
  declares both this SMS input and the `SMS-040` p2p next-hop input.

When an agent is working one of those rows, inspect the source first and then
run the exact row id:

```sh
tests/run-active-lab-mini-smt.sh --source FS-800-HDS-030-SDS-030-SMS-010
tests/run-active-lab-mini-smt.sh FS-800-HDS-030-SDS-030-SMS-010

tests/run-active-lab-mini-smt.sh --source FS-500-HDS-010-SDS-010-SMS-040
tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-040

tests/run-active-lab-mini-smt.sh --source FS-500-HDS-010-SDS-010-SMS-010
tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-010
```

Do not use `all`, the full active-lab fixture, or
`test-active-lab-layer-entry-renderer-input-poc.sh` as proof for either row.
Those aggregate checks are wiring proof only; they are not row-local SMT
evidence.

The machine-readable manifest is `tests.nix`. Run one row directly:

```sh
tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-904
```

Every manifest entry carries `rowDirectories.SDS` and `rowDirectories.SMS`.
Those point to source-template rows in `../../SDS/` and `../../SMS/`. For
renderer-entry variants, the concrete inputs share
`FS-166-HDS-010-SDS-010-SMS-900` and are split by full trace-ID `sourceInputs`
keys in that SMS row.

`tests/test-active-lab-mini-smt-independent-manifest.sh` enforces that each
manifest entry is independently runnable, capped at five runtime targets or
fewer, and backed by a mini source fixture rather than a full active-lab/HAT/SAT source.
`tests/test-gamp-row-directory-layout.sh` additionally enforces full SMS trace
directories for SMT/SMS rows and SDS-level SDS/SIT directories with explicit
SMS input keys.

List rows or run a small selected set:

```sh
tests/run-active-lab-mini-smt.sh --list
tests/run-active-lab-mini-smt.sh --source FS-800-HDS-030-SDS-030-SMS-010
tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-905 FS-166-HDS-010-SDS-010-SMS-906
```

Aggregate layer-entry scripts can still prove that skip boundaries and renderer
entry points are wired, but they are not mini-SMT evidence. If an agent is
working one FS/SMS row, it should add a mini-lab here or in the owning repo and
keep the runtime target set as small as the atom allows.
