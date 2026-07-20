# network-labs Regression State

Last updated: 2026-05-14.

This file records current verified state only. `README.md` and `AGENTS.md` are
leading: examples and labs must stay standalone model inputs. Do not solve LOC
failures by introducing helper imports, parent-relative imports, generated JSON
blobs, or shared example fragments.

## Fixed and Locally Verified

- FS-540-HDS-010-SDS-010-SMS-045 now declares its supported runtime hosts.
  The selector emits both a no-runtime inventory and a trace-tagged no-runtime
  host intent for unsupported hosts, and active-lab exposes the matching
  `intent-s-router-hetz.nix` entrypoint. Focused construction and minimal
  entrypoint tests pass, `nix flake check --all-systems` passes in
  network-labs, and the consuming NixOS worktree passes the same command when
  its Hetz renderer uses that host-specific entrypoint.
- All reusable example allow relations now carry an explicit recognized
  `returnBehavior`. Ordinary compatibility-fixture flows use `one-way`, while
  relations with an existing public-ingress authority retain their explicit
  nested `stateful-return`. `tests/test-example-explicit-return-behavior.sh`
  guards every `examples/*/intent.nix` input before compiler/NFM/CPM tests can
  discover the omission one fixture at a time. The focused source checks
  `test-example-explicit-return-behavior.sh`,
  `test-readable-examples-and-labs.sh`,
  `test-clab-nat-uplink-examples.sh`, and
  `test-overlay-underlay-service-reachability-examples.sh` pass.
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
  `bash tests/FS-800-HDS-020-SDS-021-SMS-010.sh`,
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
- FS-166 parent SIT active-lab selection is current live-validated for the
  renderer-nixos child path. `network-labs@c8ff5e2` selected
  `FS-166-HDS-010-SDS-010`, which resolves the parent SIT to
  `FS-166-HDS-010-SDS-010-SMS-901`; local `nixos` lock `8e121758` consumed the
  propagated lock chain. `network-codex-agent@1403e2ea` fixed CLAB readiness to
  accept parent-SIT `parent-SMS-*` renderer-input no-runtime artifacts, and
  `network-codex-agent@50aff666` fixed locked SIT verifier dispatch so immutable
  network-labs sources use the local `network-renderer-nixos` checkout for
  nested mini-SMT checks. The scoped full loop passed on 2026-07-01 with
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-166-HDS-010-SDS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`.
  Evidence included locked SIT selection from
  `/nix/store/n0bgrablfg63fm8s4xhq3wgjap7p1mcq-source`, CLAB readiness
  `active-targets=0 lab-emulation=0 no-runtime=true`, locked
  `tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh` PASS, local
  build hash `la5c9dr3fp6baf8awns8p0i008p7si6a`, post-reboot hash
  `kmgdjpilickdfbq1kgmzbx7gaglin85b`, and normalized renderer JSON match.
  Standalone verifier
  `NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/fs166-active-lab-renderer-nixos-runtime-check.sh --live`
  passed and proved `poc-router` only on `s-router-nixos`, with explicit
  no-runtime renderer-nixos artifacts on `s-router-clab` and
  `s-router-test-clients`. This records parent SIT/child SMS-901 runtime proof
  only; it does not claim the other FS-166 sibling renderers or HAT/SAT
  acceptance.
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
  `bash scripts/live-FS-370-HDS-010-SDS-010-SMS-050.sh --live` proved
  `s-router-nixos` and `s-router-clab` expose trace-matched control-plane
  artifacts with `runtimeTargets=5` and `uplinkLaneHits=1`; it also proved
  `s-router-test-clients` exposes `rendered-host.json` with `routerContainers=0`,
  `hostBridges=5`, and `uplink=testnet`.
- FS-370 parent SIT active-lab selection is current live-validated.
  `network-labs@bffb523` selected `FS-370-HDS-010-SDS-010`, which resolves the
  parent SIT to `FS-370-HDS-010-SDS-010-SMS-050`. Local `nixos` lock
  `5c73858e` consumed the propagated lock chain (`network-compiler@6e42982`,
  `network-forwarding-model@6288a4e`, `network-control-plane-model@f557d2b`,
  `network-renderer-access-endpoint-nixos@d5b6770`,
  `network-renderer-containerlab-linux-backend@ab5feeb`,
  `network-renderer-nebula@f2a6cb6`, `network-renderer-nixos@d844c27`,
  `network-renderer-wireguard@15ddeb4`). The scoped full loop passed on
  2026-07-01 with
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-370-HDS-010-SDS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`.
  Evidence included locked SIT selection from
  `/nix/store/w35vqw31pbjj7ckg82k9dqdivmrw6kiv-source`, CLAB readiness
  `active-targets=5 lab-emulation=0`, locked mini-SMT and all three CPM lane
  artifact checks PASS, local build hash `6xrmas7rfyi7py9f721sbq1nsb7nqz81`,
  post-reboot hash `jxy18dv36cl025lz1hfvgghfgq46q1i5`, and normalized renderer
  JSON match. Standalone verifier
  `NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-370-HDS-010-SDS-010-SMS-050.sh --live`
  passed and proved `s-router-nixos` and `s-router-clab` expose
  `runtimeTargets=5` with `uplinkLaneHits=1`, while `s-router-test-clients`
  exposes `rendered-host.json` with `routerContainers=0`, `hostBridges=5`, and
  `uplink=testnet`. This records parent SIT/child SMS-050 runtime proof only;
  it does not claim HAT/SAT acceptance.
- FS-380 internet-mode active-lab selection is current live-validated.
  `network-labs@7fe8e72` selected `FS-380-HDS-020-SDS-010-SMS-050` and
  installed the five-node PPPoE/VLAN4/VLAN5 internet-mode current-lab source
  across the NixOS, CLAB, and test-client surfaces. The first wrong layer found
  during this 2026-07-01 re-run was stale construction-test addressing: CPM
  and CLAB renderer tests still looked for legacy `internet-mode-verification`
  site/node keys while current artifacts are keyed by the full trace ID.
  `network-control-plane-model@c3219c5` and
  `network-renderer-containerlab-linux-backend@8144845` updated those tests.
  Local `nixos` lock `79237a19` consumed the propagated lock chain
  (`network-compiler@4d53c69`, `network-forwarding-model@555a08d`,
  `network-control-plane-model@93d84f6`,
  `network-renderer-containerlab-linux-backend@200502f`,
  `network-renderer-nebula@d510554`, `network-renderer-nixos@300dfef`,
  `network-renderer-wireguard@a15e550`). The scoped live loop passed on
  2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-380-HDS-020-SDS-010-SMS-050 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=5 lab-emulation=1`,
  and the locked mini-SMT check ran from
  `/nix/store/cwf875ckzdr9w9hgs298xr556lf9r94l-source`. Follow-up verifier
  `bash scripts/live-FS-380-HDS-020-SDS-010-SMS-050.sh --live` proved
  `s-router-nixos` and `s-router-clab` expose trace-matched control-plane
  artifacts with `runtimeTargets=5`, `bridgeNetworks=6`, `privateNat44=1`, and
  `uplinks=internet-vlan4,internet-vlan5`; both surfaces successfully pinged
  `1.1.1.1` from `10.20.20.1`. It also proved `s-router-test-clients` exposes
  the VLAN4/VLAN5 host substrate with `runtimeTargets=0`, `bridgeNetworks=0`,
  `privateNat44=0`, and no router fabric containers.
- FS-380 parent SIT active-lab selection is current live-validated.
  `network-labs@0e82550` selected `FS-380-HDS-020-SDS-010`, which resolves the
  parent SIT to `FS-380-HDS-020-SDS-010-SMS-050`. Local `nixos` lock
  `ee4d0ded` consumed the propagated lock chain (`network-compiler@4b7aa32`,
  `network-forwarding-model@66ac337`, `network-control-plane-model@bfef932`,
  `network-renderer-access-endpoint-nixos@a479f7e`,
  `network-renderer-containerlab-linux-backend@2451a43`,
  `network-renderer-nebula@f6b984b`, `network-renderer-nixos@5cde7b9`,
  `network-renderer-wireguard@c09df06`). The scoped full loop passed on
  2026-07-01 with
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-380-HDS-020-SDS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`.
  Evidence included locked SIT selection from
  `/nix/store/psx15jpypdbb8r0ll62d9fnj0hbb4f0z-source`, CLAB readiness
  `active-targets=5 lab-emulation=1`, locked mini-SMT, CPM, NixOS renderer,
  CLAB renderer, current-lab, artifact, no-router, and profile checks PASS,
  local build hash `j4q61zh3wkismy6g7cyzchz309mgmkqq`, post-reboot hash
  `i3i46v0y3nmajxhg8kx3bpi9b5hvqggc`, and normalized renderer JSON match.
  Standalone verifier
  `NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos NETWORK_RENDERER_CLAB_PATH=/home/deadbeef/github/network-renderer-containerlab-linux-backend NIXOS_REPO_PATH=/home/deadbeef/github/nixos S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-380-HDS-020-SDS-010-SMS-050.sh --live`
  passed and proved NixOS/CLAB PPPoE/VLAN4/VLAN5 runtime artifacts with
  `runtimeTargets=5`, `bridgeNetworks=6`, `privateNat44=1`, and successful
  `1.1.1.1` pings; it also proved `s-router-test-clients` exposes the host-only
  VLAN4/VLAN5 artifact with `runtimeTargets=0`, `bridgeNetworks=0`,
  `privateNat44=0`. This records parent SIT/child SMS-050 runtime proof only;
  it does not claim HAT/SAT acceptance.
- FS-470 WireGuard remote-egress active-lab selection is current
  live-validated. `network-labs@39f963b` selected
  `FS-470-HDS-010-SDS-010-SMS-010` and installed the row-local
  renderer-input CPM for the NixOS WireGuard provider runtime while keeping
  explicit empty host intents for CLAB and test-client surfaces. No owning-layer
  implementation fix was needed during this 2026-07-01 re-run; the row-local
  mini-SMT and focused WireGuard renderer SMT already passed. Local `nixos`
  lock `038a4409` consumed the propagated lock chain
  (`network-compiler@e109a88`, `network-forwarding-model@a20716c`,
  `network-control-plane-model@37deff9`,
  `network-renderer-wireguard@526279d`,
  `network-renderer-containerlab-linux-backend@c5de2e4`,
  `network-renderer-nebula@ce6bcc8`, `network-renderer-nixos@36444ec`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-470-HDS-010-SDS-010-SMS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported
  `active-targets=0 lab-emulation=0 no-runtime=true`, and the locked mini-SMT
  check ran from `/nix/store/amncwykxph73bl4sbn9gasszii9c1g3c-source`.
  Follow-up verifier
  `bash scripts/live-FS-470-HDS-010-SDS-010-SMS-010.sh --live`
  proved `s-router-nixos` exposes `/etc/network-artifacts/control-plane.json`
  with `target=wireguard-remote-egress` and `iface=wg-re-egress0`, while
  `s-router-clab` and `s-router-test-clients` have no remote-egress runtime and
  expose trace-matched empty active-lab host intents.
- FS-470 parent SIT active-lab selection is current live-validated.
  `network-labs@60517b8` selected `FS-470-HDS-010-SDS-010`, which resolves the
  parent SIT to `FS-470-HDS-010-SDS-010-SMS-010`. Local `nixos` lock
  `9f9d8697` consumed the propagated lock chain
  (`network-compiler@d4df318`, `network-forwarding-model@381079b`,
  `network-control-plane-model@e13559b`,
  `network-renderer-access-endpoint-nixos@8bc2146`,
  `network-renderer-wireguard@c25f925`,
  `network-renderer-nebula@6d373e1`,
  `network-renderer-containerlab-linux-backend@2e54506`,
  `network-renderer-nixos@07ea5e1`). The parent-scoped full loop passed on
  2026-07-01:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-470-HDS-010-SDS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`.
  Proof: locked active-lab SIT selection came from
  `/nix/store/362nsik639y3fmd7jvrrw77qysp115di-source`; CLAB readiness reported
  `active-targets=0 lab-emulation=0 no-runtime=true`; locked FS-470 WireGuard
  SMT plus network-labs mini-SMT passed; local NixOS build expected system hash
  `smh6z5g8cyv75fi02n5ksbfs5sn6lc6p`, post-reboot host generation was
  `j210fyi5mfsw4bdngc839nvhd6wr4x83`, and normalized renderer JSON matched.
  Standalone verifier
  `NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_RENDERER_WIREGUARD_PATH=/home/deadbeef/github/network-renderer-wireguard S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-470-HDS-010-SDS-010-SMS-010.sh --live`
  passed and proved `s-router-nixos` exposes
  `/etc/network-artifacts/control-plane.json` with
  `target=wireguard-remote-egress` and `iface=wg-re-egress0`, while
  `s-router-clab` and `s-router-test-clients` expose empty active-lab host
  intents and no remote-egress runtime. This records parent SIT/child SMS-010
  runtime proof only; it does not claim HAT/SAT acceptance.
- FS-500 reachability-decision active-lab selection is current live-validated.
  `network-labs@b397221` selected `FS-500-HDS-010-SDS-010-SMS-010` and
  installed the five-node client -> downstream-selector -> policy ->
  upstream-selector -> testnet active-lab source across NixOS and CLAB, with
  no test-client router realization nodes. No owning-layer implementation fix
  was needed during this 2026-07-01 re-run; the row-local mini-SMT, sibling
  FS-500 mini-SMT fixtures, NFM construction fixtures, CPM preservation SIT,
  and network-codex-agent runtime-debugger fixture all passed. Local `nixos`
  lock `a26ba773` consumed the propagated lock chain
  (`network-compiler@fb1ea41`, `network-forwarding-model@a02a932`,
  `network-control-plane-model@6123da2`,
  `network-renderer-wireguard@ed35404`,
  `network-renderer-containerlab-linux-backend@93eed7d`,
  `network-renderer-nebula@492b3ad`, `network-renderer-nixos@2d52135`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-500-HDS-010-SDS-010-SMS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=5 lab-emulation=0`,
  and the locked mini-SMT check ran from
  `/nix/store/s09qn890id6rk47zbnwb5xq5d30xmwg0-source`. Follow-up verifier
  `bash scripts/live-FS-500-HDS-010-SDS-010-SMS-010.sh --live` proved
  `s-router-nixos` and `s-router-clab` expose `/etc/network-artifacts/control-plane.json`
  with `runtimeTargets=5`, `validPathCount=1`, `invalidPathCount=0`, and
  `relationHits=1`; it also proved `s-router-test-clients` has
  `routerContainers=0` and `dockerContainers=0` for this trace.
- FS-500 decision-reason active-lab selection is current live-validated.
  `network-labs@ac8593a` selected `FS-500-HDS-010-SDS-010-SMS-030` and
  installed the five-node decision-reason diagnostic active-lab source across
  NixOS and CLAB, with no test-client router realization nodes. No owning-layer
  implementation fix was needed during this 2026-07-01 re-run; the row-local
  mini-SMT, CPM current-lab artifacts, and NFM decision-reason construction
  fixture all passed. Local `nixos` lock `fd14f63c` consumed the propagated
  lock chain (`network-compiler@026f941`,
  `network-forwarding-model@7945411`,
  `network-control-plane-model@e91df9e`,
  `network-renderer-wireguard@4d931e2`,
  `network-renderer-containerlab-linux-backend@af7ac0a`,
  `network-renderer-nebula@b167685`, `network-renderer-nixos@6cb7702`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-500-HDS-010-SDS-010-SMS-030 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=5 lab-emulation=0`,
  and the locked mini-SMT check ran from
  `/nix/store/63mvyf062ffcnzhav16hhpmv1wxh1bfr-source`. Follow-up verifier
  `bash scripts/live-FS-500-HDS-010-SDS-010-SMS-030.sh --live`
  proved `s-router-nixos` and `s-router-clab` expose
  `/etc/network-artifacts/control-plane.json` with `runtimeTargets=5`,
  `validPathCount=1`, `invalidPathCount=0`, and `relationHits=1`; it also
  proved `s-router-test-clients` has `routerContainers=0` and
  `dockerContainers=0` for this trace.
- FS-500 p2p next-hop active-lab selection is current live-validated.
  `network-labs@3083c4b` selected `FS-500-HDS-010-SDS-010-SMS-040` and
  installed the five-node router-a -> downstream-selector -> policy ->
  upstream-selector -> router-b active-lab source across NixOS and CLAB, with
  no test-client router realization nodes. No owning-layer implementation fix
  was needed during this 2026-07-01 re-run; the row-local mini-SMT, CPM
  current-lab artifacts, and network-codex-agent p2p runtime-debugger fixture
  all passed. Local `nixos` lock `30fb7d3a` consumed the propagated lock chain
  (`network-compiler@f8e41c9`, `network-forwarding-model@6f776b8`,
  `network-control-plane-model@c20c541`,
  `network-renderer-wireguard@45e4451`,
  `network-renderer-containerlab-linux-backend@1339f9e`,
  `network-renderer-nebula@44c87c4`, `network-renderer-nixos@53db156`).
  The scoped live loop passed on 2026-07-01 with
  `S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false'`.
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-500-HDS-010-SDS-010-SMS-040 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=5 lab-emulation=0`,
  and the locked mini-SMT check ran from
  `/nix/store/yp8cjm3ba8fgdyhyrlp76nm180gyqd01-source`. Follow-up verifier
  `bash scripts/live-FS-500-HDS-010-SDS-010-SMS-040.sh --live` proved
  `s-router-nixos` and `s-router-clab` expose
  `/etc/network-artifacts/control-plane.json` with `runtimeTargets=5`,
  `validPathCount=1`, `invalidPathCount=0`, and `relationHits=1`; it also
  proved `s-router-test-clients` has `routerContainers=0` and
  `dockerContainers=0` for this trace.
- FS-500 parent SIT active-lab selection is current live-validated.
  `network-labs@8854bcd` selected `FS-500-HDS-010-SDS-010`, whose active
  parent selector resolves to the `FS-500-HDS-010-SDS-010-SMS-010`
  reachability runtime path. Local `nixos` lock `b177a23a` consumed the
  propagated lock chain (`network-compiler@b908e49`,
  `network-forwarding-model@7424e48`,
  `network-control-plane-model@83e55ba`,
  `network-renderer-access-endpoint-nixos@eefa8e6`,
  `network-renderer-wireguard@9c22c10`,
  `network-renderer-nebula@2718c77`,
  `network-renderer-containerlab-linux-backend@05cdd76`,
  `network-renderer-nixos@1a2318e`). The parent-scoped full loop passed on
  2026-07-01:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-500-HDS-010-SDS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`.
  Proof: locked active-lab SIT selection came from
  `/nix/store/hcy8kis8l5cnws22rfwi4jgyyzhs4kdr-source`; CLAB readiness reported
  `active-targets=5 lab-emulation=0`; locked mini-SMT checks passed for
  `FS-500-HDS-010-SDS-010-SMS-010`, `SMS-030`, and `SMS-040`; local NixOS
  build expected system hash `bv44ws6fcg1n8k41m2isb6hjprqk92p4`, post-reboot
  host generation was `rncd29433m7m6yla2d64ch8w91saxqhf`, and normalized
  renderer JSON matched. Standalone verifier
  `NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_NFM_PATH=/home/deadbeef/github/network-forwarding-model NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-500-HDS-010-SDS-010-SMS-010.sh --live`
  passed and proved `s-router-nixos` and `s-router-clab` expose
  `/etc/network-artifacts/control-plane.json` with `runtimeTargets=5`,
  `validPathCount=1`, `invalidPathCount=0`, and `relationHits=1`; it also
  proved `s-router-test-clients` has no reachability router containers. This
  records parent SIT/active SMS-010 runtime proof; separate child entries remain
  the live selector proof for `SMS-030` and `SMS-040`. It does not claim
  HAT/SAT acceptance.
- FS-540 DNS resolver active-lab SIT selection is current live-validated.
  `network-labs@c2ea1b5` selected `FS-540-HDS-010-SDS-010`, consuming the
  row-local `FS-540-HDS-010-SDS-010-SMS-020` DNS resolver source for the
  five-node access-dns -> downstream-selector -> policy -> upstream-selector ->
  resolver-node path and the test-client endpoint-only source. The 2026-07-01
  rerun exposed an owning construction-test input bug: the
  `network-renderer-access-endpoint-nixos` FS-540 test still compiled locked
  `network-labs/current-lab`, so downstream locks could silently test the
  previous selector. Owning fix
  `network-renderer-access-endpoint-nixos@ec8c4ad` switched the test to the
  row-local
  `GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/{intent-test-clients.nix,inventory-test-clients.nix}`
  source, and the final propagated access-renderer lock is
  `network-renderer-access-endpoint-nixos@6234a11`. Focused proof
  `bash tests/FS-540-HDS-010-SDS-010-SMS-020.sh`,
  `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs bash tests/FS-540-HDS-010-SDS-010-SMS-020.sh`,
  and `bash tests/run.sh` all passed. Local `nixos` lock `b04141b2` consumed
  the propagated lock chain (`network-compiler@5be5672`,
  `network-forwarding-model@b3012dd`,
  `network-control-plane-model@c1137cd`,
  `network-renderer-access-endpoint-nixos@6234a11`,
  `network-renderer-wireguard@ac35f7f`,
  `network-renderer-containerlab-linux-backend@716266f`,
  `network-renderer-nebula@e2c3619`, `network-renderer-nixos@4c15e11`).
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-540-HDS-010-SDS-010 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed after the owning fix, the CLAB readiness gate reported
  `active-targets=5 lab-emulation=1`, locked checks ran from
  `/nix/store/0aqa0v6cmpcmjyrzjj8qc1rsybygxmml-source`, and normalized renderer
  JSON matched the post-reboot generation. Follow-up verifier
  `NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos NETWORK_RENDERER_ACCESS_ENDPOINT_NIXOS_PATH=/home/deadbeef/github/network-renderer-access-endpoint-nixos NETWORK_RENDERER_CLAB_PATH=/home/deadbeef/github/network-renderer-containerlab-linux-backend S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-540-HDS-010-SDS-010-SMS-020.sh --live`
  proved both router artifacts expose trace-matched
  `/etc/network-artifacts/control-plane.json` with `runtimeTargets=5` and
  resolver-source counts `local-recursive=1`, `upstream-forwarder=0`,
  `dhcp-provided=1`, `none=9`, and `public-fallback=0`;
  `s-router-test-clients` has the `dns-resolver-config-access-dns` bridge active
  on `br-mini--baff8b`; CLAB fake-provider runtime has gateway, NAT44, and
  upstream reachability; NixOS and CLAB resolver-node paths have IPv4 upstream
  routes; CLAB `upstream-selector` selects `p1` for the runtime-origin policy
  route; both NixOS and CLAB `access-dns` resolved `cache.nixos.org`; and the
  CLAB resolver-node did not inherit Docker or host public resolver fallback.
- FS-800 provider default-route active-lab SIT selection is current
  live-validated. `network-labs@0a72554` selected
  `FS-800-HDS-010-SDS-020`, consuming the row-local
  `FS-800-HDS-010-SDS-020-SMS-040` provider-handoff default-route source for
  the six-node provider-handoff -> downstream-selector -> policy ->
  upstream-selector -> fabric-core/pppoe-core path. During live validation,
  `network-codex-agent@5a199592` fixed the CLAB readiness harness for
  renderer-scoped over-length Containerlab names, and `network-labs@7aafaa02`
  fixed this row's live SIT probe to resolve CLAB containers from deployed
  control-plane and topology artifacts instead of stale
  `mini-smt-provider-access-default-route-*` aliases. Local `nixos` lock
  `7f179048` consumed the propagated lock chain (`network-compiler@fb25dc07`,
  `network-forwarding-model@de241c07`,
  `network-control-plane-model@d3466d6b`,
  `network-renderer-containerlab-linux-backend@384744d3`,
  `network-renderer-nebula@1db0ffe6`, `network-renderer-nixos@33d99142`).
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-800-HDS-010-SDS-020 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=6 lab-emulation=0`,
  and locked checks ran from
  `/nix/store/cnz1s6i9y7cf5alff6c821s5v6ym90cc-source`. Follow-up verifier
  `bash scripts/live-FS-800-HDS-010-SDS-020-SMS-040.sh --live`
  proved NixOS and CLAB `provider-handoff-access-a` own
  `203.0.113.1` and route default/public egress via fabric gateway
  `10.80.255.2` on `p0` with no PPP leak; NixOS and CLAB `pppoe-core` keep
  their default route on uplink `u0`; and `s-router-test-clients` has
  `renderedContainers=0`, `providerDefaultRouteUnits=0`, and
  `providerHandoffUnits=0`.
- FS-800 PPPoE pairing active-lab SIT selection is current live-validated.
  `network-labs@a0dc780` selected `FS-800-HDS-030-SDS-030`, consuming the
  row-local `FS-800-HDS-030-SDS-030-SMS-010` source for the five-node
  pppoe-client -> downstream-selector -> policy -> upstream-selector ->
  pppoe-provider path. No owning-layer implementation fix was needed during
  this 2026-07-01 rerun; the row-local pairing/fallback test, PPPoE-only
  mini-SMT wrapper, current-lab selector regression, minimal entrypoint guard,
  and small runtime verifier all passed before deployment. Local `nixos` lock
  `570c4d02` consumed the propagated lock chain (`network-compiler@a47f5c7`,
  `network-forwarding-model@c1febbb`,
  `network-control-plane-model@6917686`,
  `network-renderer-containerlab-linux-backend@938215c`,
  `network-renderer-nebula@44c6775`, `network-renderer-nixos@b4b88fd`).
  Evidence:
  `NETWORK_REPO_DIRECT_TEST_OK=1 SKIP_NIXOS_LOCK_BUMP=1 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-800-HDS-030-SDS-030 S_ROUTER_NIX_BUILD_PREFIX='sudo -n' S_ROUTER_NIX_BUILD_FLAGS='--option sandbox false' bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos`
  passed, the CLAB readiness gate reported `active-targets=5 lab-emulation=0`,
  and locked checks ran from
  `/nix/store/7wgrbwnb2zzvy5n1f66w4l4zf0h0yn4g-source`. Follow-up verifier
  `bash scripts/live-FS-800-HDS-030-SDS-030-SMS-010.sh --live` proved
  NixOS and CLAB expose trace-matched control-plane artifacts with the five
  expected runtime targets, `validPathCount=1`, `invalidPathCount=0`, and the
  `FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider` allow
  relation; NixOS runs exactly the five expected machines; CLAB runs exactly
  the five expected containers; and `s-router-test-clients` renders/runs no
  PPPoE pairing router containers. This is pairing/fallback and runtime-shape
  SIT evidence only; it does not claim live PPPoE session establishment, HAT,
  or SAT acceptance.

## Still Broken

- The canonical NixOS Hetz consumer still compiles `active-lab/intent.nix`
  rather than the host-specific `active-lab/intent-s-router-hetz.nix` now
  provided by network-labs. Repository rights did not permit changing or
  pushing canonical NixOS; the one-line consumer correction was validated only
  in the authorized `nixos-s-router-prod-reservations` worktree.

- FS-540-HDS-010-SDS-010-SMS-045 cold restage14 on 2026-07-18 proved the
  resolver's scoped pre-socket UDP/TCP port-53 rules emit traffic on the
  selected NixOS provider, but the row still queried external root authority.
  Provider-side refusal/rate-limit/filter state therefore decided the result.
  This is not reproducible multi-egress evidence. The row remains NOT OK until
  `network-labs` stages a harness-scoped dual-stack authoritative hierarchy on
  only the selected emulated provider and the live protocol derives its target
  and validation material from the staged artifact without public or host DNS.
  The row source now supplies that identical root/delegation/terminal
  realization to both substrates and makes both provider candidates isolated
  from host/public uplinks. CPM and both renderers still have to consume it,
  and the cold live row still has to pass before this entry can be closed.

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
