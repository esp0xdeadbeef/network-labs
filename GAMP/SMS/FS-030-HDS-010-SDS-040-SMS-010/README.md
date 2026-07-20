# FS-030-HDS-010-SDS-040-SMS-010

Layer: SMS

This row-local source keeps the compiler platform-independence module
addressable from `network-labs`.

The SMS construction handoff is implemented by the `network-compiler` focused
test `tests/FS-030-HDS-010-SDS-040-SMS-010.sh`. The test proves:

- positive compiler output contains no platform-specific field keys;
- renderer selector fields fail closed with
  `E_PLATFORM_INDEPENDENCE_SOURCE_FIELD`;
- bridge-name fields fail closed with
  `E_PLATFORM_INDEPENDENCE_SOURCE_FIELD`;
- substrate technology selectors fail closed with
  `E_INTENT_SOURCE_BOUNDARY_REALIZATION_TECHNOLOGY`;
- compiler-output renderer leaks fail closed with
  `E_PLATFORM_INDEPENDENCE_OUTPUT_LEAK`;
- compiler-output platform syntax leaks fail closed with
  `E_PLATFORM_INDEPENDENCE_OUTPUT_LEAK`.

Current live evidence, 2026-07-04:

- `scripts/live-FS-030-HDS-010-SDS-040-SMS-010.sh` passed against
  `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.
- `s-router-nixos` emitted five full-trace runtime targets and all five NixOS
  containers were enumerated.
- `s-router-clab` emitted five full-trace runtime targets and all five
  Containerlab containers were enumerated after the render service reached
  ready state.
- `s-router-test-clients` emitted zero runtime targets, as expected for this
  row.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010`
  skipped offline verification and passed the live wrapper plus pinned
  `s-router-nixos` build.

Evidence paths:

- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z`
- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z`
- `/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010`

This row does not claim HAT, SAT, or production readiness.
