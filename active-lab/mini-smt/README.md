# active-lab mini SMT

This directory contains deliberately small active-lab SMT fixtures. A mini SMT
proves one SMS/SMT atom only. It must not pull in the full active-lab, HAT, SAT,
or a broad `s-router-*` deployment. Runtime SMT evidence still requires a real
runtime run, but that run must use a live mini profile for exactly the targets
in the fixture.

The rule is:

- one trace-chain ID per mini-lab;
- one behavior under test;
- one explicit source entry per mini-lab (`intent-source`, `control-plane-input`,
  or `renderer-input`);
- one focused script per mini-lab, runnable through
  `tests/run-active-lab-mini-smt.sh <id>`;
- a declared maximum runtime-target count;
- no implicit dependencies on full `s-router-nixos`, `s-router-clab`, or
  `s-router-test-clients`;
- no aggregate-only evidence for an SMT row;
- seeded negatives must mutate only the atom under test.

`runtime-nixos-cpm.nix` is the current active-lab runtime POC input. It is a
network-labs-owned renderer-input CPM object for one `poc-router` container on
`s-router-nixos`. The NixOS runtime acceptance path is still the real
shutdown/rebuild route; the point is that the active-lab input is small enough
to prove only the container-start materialization surface.

Do not use `vlan2` as test infrastructure. `vlan2` is the runtime
management/reachability network for the VM/host lifecycle, not a mini-SMT DHCP
uplink or dataplane path. If a mini POC needs DHCP uplinks, use `vlan4` or
`vlan5` and make that input explicit.

Mini SMT/SIT rows may use their own `intent.nix` files. Do not rewrite
`../intent.nix` for each row. Put row-specific intent sources under
`intents/<mini-smt-id>/intent.nix`, declare them in `tests.nix`, and load them
with the active-lab source helper:

```nix
let
  activeLab = import ../.;
in
activeLab.mkSource {
  intent = ./intents/p2p-next-hop/intent.nix;
}
```

The runner exposes the selected source:

```sh
tests/run-active-lab-mini-smt.sh --source p2p-next-hop
```

Current mini-labs:

| ID | Trace ID | Test | Scope |
| --- | --- | --- | --- |
| `pppoe-pairing` | `FS-800-HDS-030-SDS-030-SMS-010` | `tests/test-active-lab-mini-smt-pppoe-pairing-only.sh` | Two-target PPPoE provider/customer pairing and fallback rejection. |
| `p2p-next-hop` | `FS-500-HDS-010-SDS-010-SMS-040` | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` | Two-router, one-link p2p next-hop pairing. |
| `renderer-nixos` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime` | `tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh` | One `poc-router` NixOS runtime container from explicit CPM input. |
| `renderer-nixos-p2p` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p` | `tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh` | Two NixOS runtime containers on one p2p bridge from explicit CPM input. |
| `renderer-nixos-clients` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients` | `tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh` | One endpoint client container from explicit CPM input. |
| `renderer-clab` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab` | `tests/test-active-lab-mini-smt-renderer-clab-only.sh` | Minimal two-node Containerlab topology from explicit CPM input. |
| `renderer-wireguard` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-wireguard` | `tests/test-active-lab-mini-smt-renderer-wireguard-only.sh` | WireGuard provider runtime module from explicit CPM input. |
| `renderer-nebula` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nebula` | `tests/test-active-lab-mini-smt-renderer-nebula-only.sh` | One Nebula overlay with lighthouse/client nodes from explicit CPM input. |

Worked row examples:

- `pppoe-pairing` is the preferred small proof for
  `FS-800-HDS-030-SDS-030-SMS-010`. It uses a row-local `intent.nix` and proves
  only PPPoE provider/customer pairing, fallback rejection, and transport
  classification. It may start at most `pppoe-client` and `pppoe-server`.
- `p2p-next-hop` is the preferred small proof for
  `FS-500-HDS-010-SDS-010-SMS-040`. It uses a row-local `intent.nix` and proves
  only one p2p link, two router endpoints, and one next-hop route atom. It may
  start at most `router-a` and `router-b`.

When an agent is working one of those rows, inspect the source first and then
run the exact row id:

```sh
tests/run-active-lab-mini-smt.sh --source pppoe-pairing
tests/run-active-lab-mini-smt.sh pppoe-pairing

tests/run-active-lab-mini-smt.sh --source p2p-next-hop
tests/run-active-lab-mini-smt.sh p2p-next-hop
```

Do not use `all`, the full active-lab fixture, or
`test-active-lab-layer-entry-renderer-input-poc.sh` as proof for either row.
Those aggregate checks are wiring proof only; they are not row-local SMT
evidence.

The machine-readable manifest is `tests.nix`. Run one row directly:

```sh
tests/run-active-lab-mini-smt.sh renderer-clab
```

`tests/test-active-lab-mini-smt-independent-manifest.sh` enforces that each
manifest entry is independently runnable, capped at two runtime targets, and
backed by a mini source fixture rather than a full active-lab/HAT/SAT source.

List rows or run a small selected set:

```sh
tests/run-active-lab-mini-smt.sh --list
tests/run-active-lab-mini-smt.sh --source pppoe-pairing
tests/run-active-lab-mini-smt.sh renderer-wireguard renderer-nebula
```

Aggregate layer-entry scripts can still prove that skip boundaries and renderer
entry points are wired, but they are not mini-SMT evidence. If an agent is
working one FS/SMS row, it should add a mini-lab here or in the owning repo and
keep the runtime target set as small as the atom allows.
