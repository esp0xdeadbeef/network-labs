# network-labs Regression State

Last updated: 2026-05-05.

This file records current verified state only. `README.md` and `AGENTS.md` are
leading: examples and labs must stay standalone model inputs. Do not solve LOC
failures by introducing helper imports, parent-relative imports, generated JSON
blobs, or shared example fragments.

## Fixed and Locally Verified

- `examples/s-router-test-three-site` was moved to
  `labs/lab-s-sigma/s-router-test-three-site` so the prod-like s-sigma lab is no
  longer presented as a generic reusable example.
- `tests/test-readable-examples-and-labs.sh` rejects `builtins.fromJSON` blobs
  and parent-relative imports in `examples/` and `labs/`. The guard passes after
  converting generated JSON payloads back into Nix attrsets.
- `tests/test-lab-runtime-secret-boundary.sh` rejects public IPv4/GUA IPv6,
  deployment MACs, raw route/firewall/bridge/macvlan glue, and similar runtime
  facts in plain lab files. The guard passes for the current lab state.
- Lab runtime staging entrypoints exist for `getCompilerInput`, `getInventory`,
  `getInventorySops`, and `getResolvedInventory`.
- `getResolvedInventory` now resolves the lab DNS forwarder placeholders from
  `getInventorySops` before compiler/rendering. The runtime contract test fails
  if `runtime-public-dns-*` strings survive into the resolved inventory or if
  the public resolver forwarders are not injected.
- `runtimeNodes.*.unsafeRoutes` was removed from the s-sigma lab inventories.
  `tests/test-lab-runtime-secret-boundary.sh` now rejects overlay unsafe route
  policy in plain lab files; route export policy must come from CPM/model
  contracts.
- `examples/ipv6-pd-downstream-delegation` covers a provider /48, a normal
  `client-a` /64 access tenant, and a `client-b` access router that keeps its
  access-link /64 while receiving a named runtime IPv6 routed prefix for a /52
  downstream delegation. Both NixOS and CLAB inventories bind the derived
  `client-b` p2p lanes, and the regression test compiles both inventories
  through CPM.

## Still Broken

- No current `network-labs` test failure is verified after the standalone
  compact Nix conversion. This repo still needs downstream compiler validation
  before the moved lab can be considered production evidence.

## Next Concrete Debugging Target

- After `network-labs` tests pass, continue down the locked chain in order:
  `network-compiler`, `network-forwarding-model`,
  `network-control-plane-model`, `network-renderer-containerlab-linux-backend`,
  `network-renderer-nixos`, and then the NixOS rebuild loop.
