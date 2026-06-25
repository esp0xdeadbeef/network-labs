# active-lab mini SMT

This directory contains deliberately small active-lab SMT fixtures. A mini SMT
proves one SMS/SMT atom only. It must not pull in the full active-lab, HAT, SAT,
or a broad `s-router-*` deployment. Runtime SMT evidence still requires a real
runtime run, but that run must use a live mini profile for exactly the targets
in the fixture.

The rule is:

- one trace-chain ID per mini-lab;
- one behavior under test;
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

Current mini-labs:

| ID | Trace ID | Test | Scope |
| --- | --- | --- | --- |
| `pppoe-pairing` | `FS-166-HDS-010-SDS-010-SMS-900__mini-pppoe-pairing` | `tests/test-active-lab-mini-smt-pppoe-pairing-only.sh` | Two-target PPPoE provider/customer pairing and fallback rejection. |
| `p2p-next-hop` | `FS-166-HDS-010-SDS-010-SMS-900__mini-p2p-next-hop` | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` | Two-router, one-link p2p next-hop pairing. |
| `renderer-nixos` | `FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime` | `tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh` | One `poc-router` NixOS runtime container from explicit CPM input. |
| `renderer-nixos-clients` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients` | `tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh` | One endpoint client container from explicit CPM input. |
| `renderer-clab` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab` | `tests/test-active-lab-mini-smt-renderer-clab-only.sh` | Minimal two-node Containerlab topology from explicit CPM input. |
| `renderer-wireguard` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-wireguard` | `tests/test-active-lab-mini-smt-renderer-wireguard-only.sh` | WireGuard provider runtime module from explicit CPM input. |
| `renderer-nebula` | `FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nebula` | `tests/test-active-lab-mini-smt-renderer-nebula-only.sh` | One Nebula overlay with lighthouse/client nodes from explicit CPM input. |

The machine-readable manifest is `tests.nix`. Run one row directly:

```sh
tests/run-active-lab-mini-smt.sh renderer-clab
```

List rows or run a small selected set:

```sh
tests/run-active-lab-mini-smt.sh --list
tests/run-active-lab-mini-smt.sh renderer-wireguard renderer-nebula
```

Aggregate layer-entry scripts can still prove that skip boundaries and renderer
entry points are wired, but they are not mini-SMT evidence. If an agent is
working one FS/SMS row, it should add a mini-lab here or in the owning repo and
keep the runtime target set as small as the atom allows.
