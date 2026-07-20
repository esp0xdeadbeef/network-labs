# FS-030-HDS-010-SDS-030-SMS-010

Layer: SMS

This row-local source keeps the compiler overlay-underlay separation module
addressable from `network-labs`.

The SMS construction handoff is implemented by the `network-compiler` focused
test `tests/FS-030-HDS-010-SDS-030-SMS-010.sh`. The test proves:

- overlay paths carry `overlayIdentity`, `transportKind`, and
  `peerSiteIdentity`;
- overlay underlay/control and overlay payload paths do not share
  `p2pIsolationKey`;
- overlay paths emit `forbidsCoreToCoreP2P = true`;
- seeded negative collapse of underlay/payload keys is detected;
- missing explicit `underlayAccess` fails closed;
- `underlayAccess` without WAN egress fails closed.

Current live evidence, 2026-07-04:

- `scripts/live-FS-030-HDS-010-SDS-030-SMS-010.sh` passed against
  `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.
- `s-router-nixos` emitted six full-trace runtime targets and all six NixOS
  containers were enumerated.
- `s-router-clab` emitted six full-trace runtime targets and all six
  Containerlab containers were enumerated after the render service reached
  ready state.
- `s-router-test-clients` emitted zero runtime targets, as expected for this
  row.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-030-SMS-010`
  skipped offline verification and passed the live wrapper plus pinned
  `s-router-nixos` build.

Evidence paths:

- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051250Z`
- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051319Z`
- `/tmp/active-lab-mini-smt-runs/20260704T051312Z-2891933/FS-030-HDS-010-SDS-030-SMS-010`

This row does not claim HAT, SAT, or production readiness.
