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
- FS-166 renderer-input active-lab NixOS selections now install explicit
  trace-tagged no-runtime CPM-shaped host intents for `s-router-clab` and
  `s-router-test-clients` while `s-router-nixos` consumes the selected NixOS
  renderer CPM. The first wrong layer behind the 2026-07-01
  `s-router-clab-render-live.service` failure was the active-lab selector
  handing the NixOS-only `runtime-nixos-cpm.nix` to CLAB, which correctly
  rejected a non-CLAB runtime target without `routingMode`. Local proofs passed:
  `bash tests/test-current-lab-selector.sh`, `bash tests/run-active-lab-mini-smt.sh --source FS-166-HDS-010-SDS-010-SMS-901`,
  `bash tests/run-active-lab-mini-smt.sh FS-166-HDS-010-SDS-010-SMS-901`, and
  `bash tests/test-active-lab-minimal-entrypoints.sh`. Live proof passed on
  2026-07-01 after local `nixos` lock commit `a41d77c4` consumed
  `network-labs@19fa364`: scoped full loop
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010-SMS-901 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, and `bash scripts/fs166-active-lab-renderer-nixos-runtime-check.sh --live`
  proved `s-router-nixos` runs `poc-router` while `s-router-clab` and
  `s-router-test-clients` expose explicit empty no-runtime host artifacts.
- FS-166 renderer-nixos-p2p active-lab selection is current live-validated.
  `network-labs@05813b6` selected
  `FS-166-HDS-010-SDS-010-SMS-902`, `network-codex-agent@f9d58a73` updated the
  p2p verifier to require explicit no-runtime CLAB/test-client host artifacts,
  and local `nixos` lock `75ff6b7d` consumed the propagated lock chain
  (`network-compiler@d70c7e9`, `network-forwarding-model@59cdf3d`,
  `network-control-plane-model@8036b5b`,
  `network-renderer-containerlab-linux-backend@afbe6a5`,
  `network-renderer-nebula@1a1e228`, `network-renderer-nixos@9c00946`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`
  because the local Nix sandbox failed flat NixOS container config outputs; the
  locked model/render inputs and live target scope were unchanged. Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010-SMS-902 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the locked mini-SMT check ran from
  `/nix/store/rvj260vfiyvs80w28x230n6cqhq6mdyw-source`, and
  `bash scripts/fs166-active-lab-renderer-nixos-p2p-runtime-check.sh --live`
  proved `s-router-nixos` runs `edge-a` and `edge-b` while `s-router-clab` and
  `s-router-test-clients` expose explicit empty no-runtime host artifacts.
- FS-166 renderer-nixos-clients active-lab selection is current live-validated.
  `network-labs@188627f` added explicit `routingMode = "static"` to the
  shared FS-166 one-router CPM, and `network-labs@3444699` changed
  `FS-166-HDS-010-SDS-010-SMS-903` so `s-router-clab` receives a trace-matched
  empty no-runtime host artifact while `s-router-nixos` keeps the default
  router CPM and `s-router-test-clients` receives the endpoint CPM.
  `network-codex-agent@08303e69` updated the clients verifier expectation.
  Local `nixos` lock `7dede923` consumed the propagated lock chain
  (`network-compiler@1178ca5`, `network-forwarding-model@f00bbfc`,
  `network-control-plane-model@5949269`,
  `network-renderer-containerlab-linux-backend@9096d60`,
  `network-renderer-nebula@6599704`, `network-renderer-nixos@2ab4d05`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`
  for the same local Nix sandbox reason as the p2p row. Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010-SMS-903 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the locked mini-SMT check ran from
  `/nix/store/ml19x64cv6jhqarx9lghd3h9w2nhdznm-source`, and
  `bash scripts/fs166-active-lab-renderer-nixos-clients-runtime-check.sh --live`
  proved `s-router-test-clients` runs `poc-client` on the client bridge while
  `s-router-nixos` and `s-router-clab` have no endpoint container.
- FS-166 renderer-clab active-lab selection is current live-validated.
  `network-labs@ffce6f7` added explicit `realization.nodes` for the
  `s-router-clab` runtime targets and made the selector export CPM realization
  into `current-lab/inventory-clab.nix`; this fixed the first wrong layer behind
  the renderer rejecting `targetHost = "s-router-clab"` with zero matching
  realization nodes. `network-codex-agent@eb7a40dc`, `14c1b15b`, `918ae992`,
  and `ed6e48c8` updated the verifier, CLAB readiness target derivation, empty
  optional-container handling, and locked mini-SMT working directory.
  Local `nixos` lock `91e5bec5` consumed the propagated lock chain
  (`network-compiler@219a91f`, `network-forwarding-model@56c339c`,
  `network-control-plane-model@b9569da`,
  `network-renderer-containerlab-linux-backend@b9840ea`,
  `network-renderer-nebula@bc2cc88`, `network-renderer-nixos@04b89f9`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010-SMS-904 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=2 lab-emulation=0`,
  and the locked mini-SMT check ran from
  `/nix/store/nb83a5vbdr60l1g5hlpvg3874igksgfi-source`. Follow-up verifier
  `bash scripts/fs166-active-lab-renderer-clab-runtime-check.sh --live` proved
  `s-router-clab` runs `clab-fabric-acme-lab-edge-a` and
  `clab-fabric-acme-lab-edge-b` while `s-router-nixos` and
  `s-router-test-clients` have no CLAB edge runtime.
- FS-166 renderer-wireguard active-lab selection is current live-validated.
  `network-labs@831f2e5` selected `FS-166-HDS-010-SDS-010-SMS-905`, installed
  the WireGuard provider contract on `s-router-nixos`, kept `s-router-clab` and
  `s-router-test-clients` as explicit no-runtime host surfaces, and exposed the
  row-local WireGuard private-key SOPS binding for the NixOS runtime consumer.
  Local `nixos` lock `9535ba34` consumed the propagated lock chain
  (`network-compiler@1b853ca`, `network-forwarding-model@c224c83`,
  `network-control-plane-model@8f78448`,
  `network-renderer-containerlab-linux-backend@bfb4216`,
  `network-renderer-nebula@f630ad4`, `network-renderer-nixos@297125b`,
  `network-renderer-wireguard@a15e550`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010-SMS-905 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported
  `active-targets=0 lab-emulation=0 no-runtime=true`, and the locked mini-SMT
  check ran from `/nix/store/7dinnhz9q1vhpng2ml18kmdrkbvlswzk-source`.
  Follow-up verifier
  `bash scripts/fs166-active-lab-renderer-wireguard-runtime-check.sh --live`
  proved `s-router-nixos` runs the WireGuard row runtime while `s-router-clab`
  and `s-router-test-clients` have no WireGuard row runtime.
- FS-166 renderer-nebula active-lab selection is current live-validated.
  `network-labs@a96d716` selected `FS-166-HDS-010-SDS-010-SMS-906`, installed
  the Nebula renderer-input CPM on `s-router-nixos`, kept `s-router-clab` and
  `s-router-test-clients` as explicit no-runtime host surfaces, and exposed the
  row-local Nebula profile SOPS bindings for the NixOS runtime consumer.
  Local `nixos` lock `d6c167c3` consumed the propagated lock chain
  (`network-compiler@c282eeb`, `network-forwarding-model@58dcefa`,
  `network-control-plane-model@a82199c`,
  `network-renderer-containerlab-linux-backend@37a4d76`,
  `network-renderer-nebula@2442d28`, `network-renderer-nixos@76993cc`,
  `network-renderer-wireguard@a15e550`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010-SMS-906 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported
  `active-targets=0 lab-emulation=0 no-runtime=true`, and the locked mini-SMT
  check ran from `/nix/store/q72hqkcz3dpsb385nbgkzpk73y1gdimm-source`.
  Follow-up verifier
  `bash scripts/fs166-active-lab-renderer-nebula-runtime-check.sh --live`
  proved `s-router-nixos` runs `lab-lighthouse` and `lab-client-nebula` while
  `s-router-clab` and `s-router-test-clients` have no Nebula row runtime.
- FS-370 lane-egress active-lab selection is current live-validated.
  `network-labs@e164e44` selected `FS-370-HDS-010-SDS-010-SMS-050` and
  installed the five-node lane-egress current-lab source across the NixOS,
  CLAB, and test-client surfaces. Local `nixos` lock `d4b7c129` consumed the
  propagated lock chain (`network-compiler@b6e3bea`,
  `network-forwarding-model@75f808a`,
  `network-control-plane-model@9416369`,
  `network-renderer-containerlab-linux-backend@821f698`,
  `network-renderer-nebula@ab32551`, `network-renderer-nixos@c0fa473`,
  `network-renderer-wireguard@a15e550`). The scoped live loop passed on
  2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-370-HDS-010-SDS-010-SMS-050 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=5 lab-emulation=0`,
  and the locked mini-SMT check ran from
  `/nix/store/lxgfsjfg1vw6873i11qfllvj1l82li7k-source`. Follow-up verifier
  `bash scripts/fs370-active-lab-lane-egress-runtime-check.sh --live` proved
  `s-router-nixos` and `s-router-clab` expose trace-matched control-plane
  artifacts with `runtimeTargets=5` and `uplinkLaneHits=1`; it also proved
  `s-router-test-clients` exposes `rendered-host.json` with `routerContainers=0`,
  `hostBridges=5`, and `uplink=testnet`.

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
