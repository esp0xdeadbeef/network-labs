# active-lab mini SMT

This directory contains deliberately small active-lab SMT fixtures. A mini SMT
proves one SMS/SMT atom only. It must not pull in the full active-lab, HAT, SAT,
or a broad `s-router-*` deployment. Runtime SMT evidence still requires a real
runtime run, but that run must use a live mini profile for exactly the targets
in the fixture.

The rule is:

- one trace-chain ID per mini-lab;
- one behavior under test;
- a declared maximum runtime-target count;
- no implicit dependencies on full `s-router-nixos`, `s-router-clab`, or
  `s-router-test-clients`;
- seeded negatives must mutate only the atom under test.

`runtime-nixos-cpm.nix` is the current active-lab runtime POC input. It is a
network-labs-owned renderer-input CPM object for one `poc-router` container on
`s-router-nixos`. The NixOS runtime acceptance path is still the real
shutdown/rebuild route; the point is that the active-lab input is small enough
to prove only the container-start materialization surface.

Current mini-labs:

| Trace ID | Test | Scope |
| --- | --- | --- |
| `FS-800-HDS-030-SDS-030-SMS-010` | `tests/test-active-lab-mini-smt-pppoe-pairing-only.sh` | Two-target PPPoE provider/customer pairing and fallback rejection. |
| `FS-500-HDS-010-SDS-010-SMS-040` | `tests/test-active-lab-mini-smt-p2p-next-hop-only.sh` | Two-router, one-link p2p next-hop pairing. |

Aggregate layer-entry scripts can still prove that skip boundaries and renderer
entry points are wired, but they are not mini-SMT evidence. If an agent is
working one FS/SMS row, it should add a mini-lab here or in the owning repo and
keep the runtime target set as small as the atom allows.
