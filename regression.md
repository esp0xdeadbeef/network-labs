# network-labs Regression State

Last updated: 2026-05-14.

This file records current verified state only. `README.md` and `AGENTS.md` are
leading: examples and labs must stay standalone model inputs. Do not solve LOC
failures by introducing helper imports, parent-relative imports, generated JSON
blobs, or shared example fragments.

## Fixed and Locally Verified

- `s-router-overlay-dns-lane-policy` and the prod-like
  `labs/lab-s-sigma/s-router-test-three-site` now keep the hostile branch
  public-exit default on `b-router-core-nebula` east-west, while removing
  `0.0.0.0/0` and `::/0` from site-C `c-router-nebula-core` east-west. Site-C
  has its own WAN core for public egress; modeling east-west as a public default
  made CPM install a delegated public default back into Nebula and matched the
  live hostile IPv6 loop.
- `tests/test-hostile-exits-east-west-only.sh` now guards both sides of that
  contract: hostile keeps east-west as its public-exit lane, and site-C Nebula
  core must not model east-west as a public default.
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
  the public resolver forwarders are not injected. The resolved inventory
  entrypoint is renderer-selectable so NixOS and CLAB consume the same
  SOPS/runtime resolution boundary.
- `runtimeNodes.*.unsafeRoutes` was removed from the s-sigma lab inventories.
  `tests/test-lab-runtime-secret-boundary.sh` now rejects overlay unsafe route
  policy in plain lab files; route export policy must come from CPM/model
  contracts.
- The stale `nebula-core` runtime node was removed from the s-sigma lab and the
  matching reusable overlay DNS example. The only materialized Nebula runtime
  nodes now correspond to modeled topology nodes or the explicit lighthouse.
  `tests/test-nebula-runtime-node-intent-contract.sh` rejects any future
  `runtimeNodes` entry that is not a topology node or the overlay lighthouse,
  preventing renderers from creating extra unvalidated Nebula containers.
- `examples/ipv6-pd-downstream-delegation` covers a provider /48, a normal
  `client-a` /64 access tenant, and a `client-b` access router that keeps its
  access-link /64 while receiving a named runtime IPv6 routed prefix for a /52
  downstream delegation. Both NixOS and CLAB inventories bind the derived
  `client-b` p2p lanes, and the regression test compiles both inventories
  through CPM.
- `tests/test-s-router-client-bridge-contract.sh` now rejects
  `s-router-test-clients` bridge bindings that have no matching router-side
  access bridge in the NixOS lab inventory. The guard caught the stale local
  site-C endpoint bridges and passes after removing those bindings from the
  NixOS lab inventory.
- Inventory no longer carries synthetic `containers.default` bindings for every
  forwarding node. CPM treats `inventory.realization.nodes.*.containers` as
  realization for containers explicitly declared by the forwarding model, not as
  a runtime name for the node itself. `tests/test-inventory-no-synthetic-default-containers.sh`
  rejects those stale NFM-era bindings so the compiler/CPM path cannot confuse a
  node placement target with a logical container.
- Service provider endpoint realization is explicit for the overlay/DNS examples
  that expose `dmz-nebula`, `site-dns-mgmt`, or `sitec-dns-mgmt`. The missing
  CLAB `c-router-lighthouse` endpoint and reusable example `nebula01` /
  site-DNS endpoint addresses were added to inventory files, then the changed
  inventories were compiled through the current local CPM checkout and checked
  with the CPM policy and DNS report jq contracts.
- FS-820/SMS-050 secret-source ownership is now guarded at CMC level. Lab-owned
  encrypted payloads were moved out of `active-lab/secrets` and into owning
  HAT/SMT fixture directories; host account/default-login keys such as
  `deadbeef-passwd` and arbitrary host-owned names such as `qqqqabc` are
  rejected in lab SOPS/source bindings. Focused proofs passed:
  `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-820-HDS-010-SDS-010-SMS-050.sh`,
  `bash tests/test-active-lab-minimal-entrypoints.sh`,
  `bash tests/test-hat-sops-runtime-fact-bindings.sh`,
  `bash tests/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.sh`,
  and `bash tests/test-current-lab-selector.sh`.

## Still Broken

- The prod-like s-sigma lab models Chromecast-like streaming internet access:
  `allow-nixos-streaming-to-uplinks` allows tenant `streaming` to `isp-a` /
  `isp-b` with `trafficType = "any"`. Live evidence from
  `s-router-test-clients:streaming-test` on 2026-05-14 still failed
  `ping 1.1.1.1` with 2 transmitted and 0 received. This is a production
  policy requirement for Chromecast-style clients, not an optional probe; the
  runtime checker must keep asserting streaming tenant internet egress when the
  policy allows it.
- The prod-like s-sigma lab expects DHCP/DNS hostname resolution for endpoint
  names such as `client2-test.lan`, like an OPNsense-style LAN resolver. Live
  evidence from `s-router-test-clients:client-test` on 2026-05-14 showed
  `dig client2-test @10.20.20.1` and `dig client2-test.lan @10.20.20.1`
  returning NXDOMAIN. Do not solve this with hardcoded lab records; the
  runtime DNS/DHCP path should publish or resolve learned client hostnames.
- The prod-like s-sigma lab has modeled public service ingress for
  `dmz-nebula` on port 4242, but it does not currently model a Hetzner-to-
  hostile-client or VLAN5 fake-WAN port-forward. That means live validation can
  only honestly assert the existing public service ingress today. If hostile or
  VLAN5 ingress is required, add it as explicit intent/service/provider data
  first, then validate it by resolving the current WAN DHCP address at runtime
  and sending a fake outside request from a separate core/WAN context.
- The 2026-05-13 fast live refresh
  `/tmp/s-router-fast-enum-20260513T212251Z/summary/fast.tsv` confirms the
  currently visible lab is still not production-ready: branch/hostile endpoints
  have modeled public route candidates but no working DNS or public egress,
  regular client egress differs by lane, and CLAB is stale/unusable. The first
  semantic fix remains keeping site-C Nebula east-west from being modeled as a
  public default while preserving the hostile branch public-exit lane.
- `./tests/test.sh` is currently blocked by its pinned downstream CPM/NFM chain,
  which still rejects removed synthetic `containers.default` bindings during the
  IPv6-PD downstream delegation compile path. This is a lock-chain/upstream
  propagation blocker, not a reason to re-add default containers to
  `network-labs`.
- The prod-like s-sigma lab still uses one shared `inventory-clab.nix` alongside
  the NixOS inventory. That does not give Containerlab its own explicit lab
  target. The next change must add a dedicated CLAB validation input for
  `s-router-clab` while keeping the current NixOS/Hetzner shape for
  `s-router-test`: site-a and site-b remain local `s-router-test` style sites,
  site-c remains the Hetzner/external validation site, and `s-router-clab`
  becomes its own modeled CLAB site/lab inventory instead of sharing hidden
  assumptions with the NixOS inventory.

## Next Concrete Debugging Target

- Add focused `network-labs` tests that compile both prod-like lab targets at
  the same time: the current `s-router-test-three-site` NixOS/Hetzner lab and
  the new dedicated `s-router-clab` CLAB lab. The tests must fail if
  `s-router-clab` is only an alias for the NixOS inventory or if either lab
  drops site-a/site-b/site-c coverage.
- After `network-labs` tests pass, continue down the locked chain in order:
  `network-compiler`, `network-forwarding-model`,
  `network-control-plane-model`, `network-renderer-containerlab-linux-backend`,
  `network-renderer-nixos`, and then the NixOS rebuild loop.
