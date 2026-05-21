# network-labs Regression State

Last updated: 2026-05-16.

This file records current verified state only. `README.md` and `AGENTS.md` are
leading: examples and labs must stay standalone model inputs. Do not solve LOC
failures by introducing helper imports, parent-relative imports, generated JSON
blobs, or shared example fragments.

## Fixed and Locally Verified

- state=fixed-but-only-locally-tested | target=s-sigma-dns-exception-before-mgmt-deny | evidence=2026-05-21 full lab loop reached live allowed-flow validation and failed `nixos-router-access-client -> @10.20.10.1` DNS because rendered nft placed `deny-production-to-mgmt` before `allow-tenants-to-site-dns`; live insertion of only the DNS accepts before that deny immediately made `dig @10.20.10.1 example.com A` return `NOERROR`. `labs/lab-s-sigma/s-router-test-three-site/intent.nix` now gives the NixOS and CLAB tenant-to-site-DNS allow relations priority 9 so the exception is ordered before the broad production-to-mgmt deny. | reason=The DNS exception is semantic policy intent. The renderer correctly materialized the supplied relation order; the lab intent had the exception after the broad deny.

- state=fixed-but-only-locally-tested | target=s-sigma-hetz-dmz-nebula-intent-service | evidence=2026-05-15 live Hetzner validation showed public UDP 4242 was being DNATed toward `10.90.10.100:4242`, but `esp.hetz` intent only defined `trafficType = "nebula"` and the `east-west` overlay termination. It did not define a Hetz `dmz-nebula` service or `allow-wan-to-dmz-nebula` relation. `labs/lab-s-sigma/s-router-test-three-site/intent.nix` now models `dmz-nebula` with provider `hetz-router-lighthouse` and allows WAN `trafficType = "nebula"` to that service; `nix-instantiate --parse intent.nix`, `nix-instantiate --eval --strict getCompilerInput.nix`, and `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-nebula-public-endpoints.sh` pass. | reason=Public Nebula 4242 on the Hetz DMZ/lighthouse path is semantic policy and must be present in network-labs intent, not invented by NixOS runtime glue, renderer inference, or ad hoc nftables hotpatches.

- state=runtime-checks | `s-router-overlay-dns-lane-policy` and the prod-like
  `labs/lab-s-sigma/s-router-test-three-site` now keep the hostile branch
  public-exit default on `b-router-core-nebula` east-west, while removing
  `0.0.0.0/0` and `::/0` from site-C `c-router-nebula-core` east-west. Site-C
  has its own WAN core for public egress; modeling east-west as a public default
  made CPM install a delegated public default back into Nebula and matched the
  live hostile IPv6 loop.
- state=runtime-checks | `tests/test-hostile-exits-east-west-only.sh` now guards both sides of that
  contract: hostile keeps east-west as its public-exit lane, and site-C Nebula
  core must not model east-west as a public default.
- state=runtime-checks | `examples/s-router-test-three-site` was moved to
  `labs/lab-s-sigma/s-router-test-three-site` so the prod-like s-sigma lab is no
  longer presented as a generic reusable example.
- state=runtime-checks | `tests/test-readable-examples-and-labs.sh` rejects `builtins.fromJSON` blobs
  and parent-relative imports in `examples/` and `labs/`. The guard passes after
  converting generated JSON payloads back into Nix attrsets.
- state=runtime-checks | `tests/test-lab-runtime-secret-boundary.sh` rejects public IPv4/GUA IPv6,
  deployment MACs, raw route/firewall/bridge/macvlan glue, and similar runtime
  facts in plain lab files. The guard passes for the current lab state.
- state=runtime-checks | Lab runtime staging entrypoints exist for `getCompilerInput`, `getInventory`,
  `getInventorySops`, and `getResolvedInventory`.
- state=runtime-checks | `getResolvedInventory` now resolves the lab DNS forwarder placeholders from
  `getInventorySops` before compiler/rendering. The runtime contract test fails
  if `runtime-public-dns-*` strings survive into the resolved inventory or if
  the public resolver forwarders are not injected. The resolved inventory
  entrypoint is renderer-selectable so NixOS and CLAB consume the same
  SOPS/runtime resolution boundary.
- state=runtime-checks | `runtimeNodes.*.unsafeRoutes` was removed from the s-sigma lab inventories.
  `tests/test-lab-runtime-secret-boundary.sh` now rejects overlay unsafe route
  policy in plain lab files; route export policy must come from CPM/model
  contracts.
- state=runtime-checks | The stale `nebula-core` runtime node was removed from the s-sigma lab and the
  matching reusable overlay DNS example. The only materialized Nebula runtime
  nodes now correspond to modeled topology nodes or the explicit lighthouse.
  `tests/test-nebula-runtime-node-intent-contract.sh` rejects any future
  `runtimeNodes` entry that is not a topology node or the overlay lighthouse,
  preventing renderers from creating extra unvalidated Nebula containers.
- state=runtime-checks | `examples/ipv6-pd-downstream-delegation` covers a provider /48, a normal
  `client-a` /64 access tenant, and a `client-b` access router that keeps its
  access-link /64 while receiving a named runtime IPv6 routed prefix for a /52
  downstream delegation. Both NixOS and CLAB inventories bind the derived
  `client-b` p2p lanes, and the regression test compiles both inventories
  through CPM.
- state=runtime-checks | `tests/test-s-router-client-bridge-contract.sh` now rejects
  `s-router-test-clients` bridge bindings that have no matching router-side
  access bridge in the NixOS lab inventory. The guard caught the stale local
  site-C endpoint bridges and passes after removing those bindings from the
  NixOS lab inventory.
- state=runtime-checks | Inventory no longer carries synthetic `containers.default` bindings for every
  forwarding node. CPM treats `inventory.realization.nodes.*.containers` as
  realization for containers explicitly declared by the forwarding model, not as
  a runtime name for the node itself. `tests/test-inventory-no-synthetic-default-containers.sh`
  rejects those stale NFM-era bindings so the compiler/CPM path cannot confuse a
  node placement target with a logical container.
- state=runtime-checks | Service provider endpoint realization is explicit for the overlay/DNS examples
  that expose `dmz-nebula`, `site-dns-mgmt`, or `sitec-dns-mgmt`. The missing
  CLAB `c-router-lighthouse` endpoint and reusable example `nebula01` /
  site-DNS endpoint addresses were added to inventory files, then the changed
  inventories were compiled through the current local CPM checkout and checked
  with the CPM policy and DNS report jq contracts.

- state=implemented-but-not-yet-live-validated | target=s-sigma-dns-policy-not-in-inventory | evidence=2026-05-19 `labs/lab-s-sigma/s-router-test-three-site/intent.nix` models DNS services and relations such as `site-dns-mgmt`, `hetz-dns-dmz`, `clab-site-dns`, tenant-to-DNS allows, DNS-to-uplink allows, and tenant-DNS-to-WAN denies. `inventory.nix` no longer carries `services.dns.forwarders`, and `getResolvedInventory.nix` no longer injects `runtime-public-dns-*` placeholders from `getInventorySops.nix`. | reason=DNS policy is intent. Inventory may choose realization technology such as unbound/BIND/vendor DNS feature, host placement, interfaces, bridges, VLANs, MTU, and SOPS/runtime endpoint facts, but it must not decide resolver forwarder policy, tenant DNS behavior, leak prevention, or DNS route preference. NFM should derive access reachability to visible tenant/service DNS paths, preferring other tenant/site paths before core fallback.

## Implemented But Not Yet Live Validated

- state=implemented-but-not-yet-live-validated | target=s-sigma-dmz-broad-public-egress | evidence=2026-05-20 live `s-router-test-clients` showed `nixos-dmzweb01` could ping `1.1.1.1`, and `ip route get 1.1.1.1` selected `via 10.20.30.1 dev eth0`. Source intent contained broad tenant DMZ egress relations: `allow-dmz-to-uplinks`, `allow-hetz-dmz-to-wan`, and CLAB `allow-normal-tenants-to-wan` included `dmz`. The broad DMZ tenant egress relations were removed, stale DMZ policy-upstream uplink inventory bindings were removed, and `NETWORK_REPO_DIRECT_TEST_OK=1 tests/test.sh` passes with `tests/test-lab-sigma-public-egress-intent.sh`. | reason=DMZ may expose explicitly modeled services such as Nebula or DNS, but generic DMZ tenant internet egress is policy intent and must not be allowed by the lab model.

- state=implemented-but-not-yet-live-validated | target=s-sigma-clab-client-public-egress | evidence=2026-05-20 live `s-router-test-clients` showed `clab-client01` and `clab-streaming01` failed to ping `1.1.1.1`. Both containers still had default routes, but the gateways were tenant subnet zero addresses: `clab-client01` used `via 10.50.20.0 dev eth0`; `clab-streaming01` used `via 10.50.50.0 dev eth0`. A NixOS client-harness eval now emits `clab-client01` default gateways `10.50.20.1` / `fd42:dead:feed:20::1` and `clab-streaming01` default gateways `10.50.50.1` / `fd42:dead:feed:50::1` by consuming renderer runtime targets instead of deriving gateways from intent prefixes. | reason=Client and streaming tenants should retain modeled WAN egress, but endpoint clients must use explicit renderer/CPM access router advertisements, not infer gateway addresses from raw tenant prefix network addresses.

## Still Broken

- state=still-broken | target=s-sigma-hetz-nebula-underlay-return-routes | evidence=2026-05-19 `scripts/s-router-full-lab-rebuild-loop.sh` reached live validation after green local builds, Hetzner deploy, CLAB rebuild, and Nebula profile sync, but site-C DNS over overlay still timed out at `dig -b 10.20.70.0 @10.90.10.1 example.com A`. Live Hetzner route lookups showed `hetz-router-policy` table 2001 selected `10.80.0.6 dev downstr-client` for `10.80.0.10 from 10.90.10.100 iif downstream-dmz`; temporary route fixes to `10.80.0.10/31 via 10.80.0.15` and `10.80.0.10/31 via 10.80.0.9` made `hetz-router-nebula-core` ping the lighthouse overlay IP `100.96.10.254`. | reason=The lab intent is now far enough through the pipeline to expose an upstream p2p route specificity bug: NFM/CPM must carry concrete underlay endpoint return routes so policy tables select the east-west lane, instead of relying on ambiguous p2p aggregates or local NixOS route hotpatches.

- state=runtime-checks | The 2026-05-13 fast live refresh
  `/tmp/s-router-fast-enum-20260513T212251Z/summary/fast.tsv` confirmed that
  the then-visible lab was not production-ready: branch/hostile endpoints had
  modeled public route candidates but no working DNS or public egress, regular
  client egress differed by lane, and CLAB was stale/unusable. The source-model
  guard for the first semantic fix now passes:
  `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-hostile-exits-east-west-only.sh`
  confirms hostile keeps east-west as its public-exit lane while site-C Nebula
  core does not model east-west as a public default. Full live rebuild/runtime
  validation is still pending before this can be called production-ready.
- state=runtime-checks | `./tests/test.sh` is currently blocked by its pinned downstream CPM/NFM chain,
  which still rejects removed synthetic `containers.default` bindings during the
  IPv6-PD downstream delegation compile path. This is a lock-chain/upstream
  propagation blocker, not a reason to re-add default containers to
  `network-labs`.
- state=runtime-checks | The prod-like s-sigma lab still uses one shared `inventory-clab.nix` alongside
  the NixOS inventory. That does not give Containerlab its own explicit lab
  target. The next change must add a dedicated CLAB validation input for
  `s-router-clab` while keeping the current NixOS/Hetzner shape for
  `s-router-test`: site-a and site-b remain local `s-router-test` style sites,
  site-c remains the Hetzner/external validation site, and `s-router-clab`
  becomes its own modeled CLAB site/lab inventory instead of sharing hidden
  assumptions with the NixOS inventory.

## Next Concrete Debugging Target

- state=runtime-checks | Add focused `network-labs` tests that compile both prod-like lab targets at
  the same time: the current `s-router-test-three-site` NixOS/Hetzner lab and
  the new dedicated `s-router-clab` CLAB lab. The tests must fail if
  `s-router-clab` is only an alias for the NixOS inventory or if either lab
  drops site-a/site-b/site-c coverage.
- state=runtime-checks | After `network-labs` tests pass, continue down the locked chain in order:
  `network-compiler`, `network-forwarding-model`,
  `network-control-plane-model`, `network-renderer-containerlab-linux-backend`,
  `network-renderer-nixos`, and then the NixOS rebuild loop.
