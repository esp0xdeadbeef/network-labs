# network-labs Regression State

Last updated: 2026-05-16.

This file records current verified state only. `README.md` and `AGENTS.md` are
leading: examples and labs must stay standalone model inputs. Do not solve LOC
failures by introducing helper imports, parent-relative imports, generated JSON
blobs, or shared example fragments.

## Fixed and Locally Verified

- state=fixed-but-only-locally-tested | target=tri-site-example-derived-dns-service-egress-contract | evidence=2026-05-28 the live s-sigma SAT DNS blocker proved that an access resolver can have final derived public forwarders from service-to-WAN DNS intent while the core firewall intent is resolved too early to see those final DNS service facts. Upstream `network-*` tests must not pin to mutable `labs/lab-s-sigma`, so `examples/tri-site-s-router-overlay-egress` now makes the hosted edge DMZ resolver representative: inventory still realizes router-self DNS advertisement and placement, but no longer hardcodes public resolver forwarders for `esp-edge-example-router-access-dmz`. The public recursion authority is the intent relation `allow-edge-dns-service-to-wan`; CPM must synthesize the resolver forwarders and source-scoped core DNS-service egress rule from model semantics. | reason=Examples must carry reusable semantic regression coverage. Inventory may realize DNS service placement and advertised router-self listeners, but it must not be the only place that grants public recursive forwarders when intent already declares DNS service egress.

- state=fixed-but-only-locally-tested | target=s-sigma-overlay-core-payload-adjacency-vs-underlay-access | evidence=2026-05-25 live `nixos-router-core-nebula` had only a dynamic `client` interface and could ping `1.1.1.1`, proving daemon underlay/control could use the client DHCP/SLAAC path. The same shape left no upstream-side `core-nebula` interface on `nixos-router-upstream`; live `nft list ruleset` on upstream had no `pol-hostile-ew -> core-nebula` accept and only the stale same-interface `pol-hostile-ew -> pol-hostile-ew` 4444 rules. Per the compiler and lab READMEs, `underlayAccess = client` selects daemon bootstrap only; hostile payload still needs `access-hostile -> downstream -> policy -> upstream -> core-nebula -> overlay`. Current intent restores the `core-nebula <-> upstream` payload topology links for NixOS, Hetzner, and CLAB while keeping access-client <-> core-nebula p2p underlay forbidden. | reason=The previous lab regression conflated underlay/control with payload ingress. The lab must forbid hidden underlay p2p to access-client, but require the normal canonical payload adjacency into the overlay core.

- state=fixed-but-only-locally-tested | target=s-sigma-nebula-runtime-interface-matches-overlay-firewall | evidence=2026-05-24 live manual `s-router-nebula-render-node.service` on `nixos-router-core-nebula` produced a working Nebula TUN named `nebula1`, but the rendered NixOS firewall accepted the explicit overlay interface name instead. Adding only temporary `nft insert rule inet router input iifname "nebula1" accept` and matching forward accepts on both core Nebula containers made overlay pings pass both directions, proving the provider TUN name and modeled overlay firewall interface were split. The s-sigma inventory now realizes routed core Nebula runtime services on `overlay-west`, the shortened overlay interface name consumed by the NixOS firewall, and `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-runtime-contract.sh` rejects `nebula1` on those routed core runtime nodes. | reason=Inventory owns the concrete runtime interface binding. NixOS must not add a special `nebula1` firewall exception, and the Nebula provider must not default routed core nodes to a different TUN name than the explicit overlay interface the model exposes to downstream firewall rendering.

- state=fixed-but-only-locally-tested | target=s-sigma-clab-site-dns-service-wan-egress | evidence=2026-05-21 live `s-router-clab` showed `clab-client01 ping 1.1.1.1` passing while `dig google.com` returned `SERVFAIL`; direct probing showed `clab-router-access-client` forwarded DNS to `10.50.10.1`, and `clab-router-access-mgmt` had an empty `/tmp/clabgen-dns-proxy.json.forwarders` list. CPM was correct to avoid inventing public recursion: CLAB intent allowed normal tenants to `clab-site-dns` and denied tenant DNS to WAN, but did not allow the `clab-site-dns` service itself to use WAN DNS. The lab now declares `allow-clab-site-dns-service-to-wan` before the tenant DNS-to-WAN deny and realizes the matching CLAB mgmt policy/upstream WAN lane. `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-runtime-contract.sh` guards both the intent relation and inventory lane. | reason=Public recursive DNS for a modeled site DNS service is semantic intent. CPM and renderers must not repair a missing service-to-WAN DNS relation by inventing forwarders from names or from local resolver behavior.

- state=fixed-but-only-locally-tested | target=s-sigma-hetz-nebula-runtime-underlay-port | evidence=2026-05-21 full rebuild-loop allowed-flow validation still timed out on `nixos-hostile-node01 -> @10.90.10.1` DNS. Live tracing showed the DNS packet reached `nixos-router-core-nebula nebula1`, while Nebula handshakes to `hetz-router-nebula-core` timed out. `nixos-router-core-nebula` sent UDP to the explicit public runtime endpoint, `nixos-router-core-isp-a` forwarded UDP/4243, and `s-router-test` emitted it on `eth0.5`, but Hetzner never saw UDP/4243 from that lab-underlay path. The same source path to UDP/443 arrived at Hetzner. The s-sigma lab now models `nebula-runtime` as UDP/443 and realizes `hetz-router-nebula-core.service.port` plus `service.publicEndpoints[].port` as 443. Verified locally with `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-nebula-public-endpoints.sh`, `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-nebula-relay-realization-contract.sh`, and `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-runtime-contract.sh`. | reason=The public Nebula relay runtime port is a lab realization fact with matching intent firewall semantics. Renderers must consume the explicit CPM/provider endpoint and must not compensate for an unreachable lab-underlay port by inventing a different static map or firewall lane.

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

- state=fixed-but-only-locally-tested | target=s-sigma-nebula-underlay-dedicated-access | evidence=2026-05-24 live `s-router-test` rendered `nixos-router-core-nebula` with `access-client@if69 10.10.0.3/31` plus `upstream@if68 10.10.0.18/31`; `ip route get 1.1.1.1` selected `via 10.10.0.2 dev access-client src 10.19.0.8`. The durable model chain now treats the overlay underlay access selection as a host-like client tenant attachment: `network-compiler` models the underlay access as a virtual daemon/control edge, `network-forwarding-model` routes across that graph-only edge without emitting access-client <-> core-nebula p2p underlay, and this lab inventory realizes the core Nebula node on the `client` tenant bridge through `logicalInterface = "tenant-client"`. `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-nebula-underlay-access.sh` and `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-runtime-contract.sh` pass locally. | reason=The underlay/bootstrap side of a Nebula core must be a host-like client attachment on the selected access tenant, with IPv4 learned by DHCP and IPv6 by SLAAC/RA. It must not be a generated `/31` p2p topology link to `access-client`. The separate `core-nebula -> upstream` adjacency is valid only for modeled overlay payload ingress and must not be used as daemon underlay.

- state=fixed-but-only-locally-tested | target=s-sigma-hetz-underlay-access-egress-intent | evidence=2026-05-23 full rebuild-loop network-* sweep failed in `network-compiler` with `E_OVERLAY_UNDERLAY_ACCESS_WAN_EGRESS_REQUIRED`: overlay `east-west` underlayAccess tenant `iot` had no allowed egress relation to the underlay target external at `transport.overlays.east-west.underlayAccess` for `esp.hetz`. Current checked-out `labs/lab-s-sigma/s-router-test-three-site/intent.nix` selects `underlayAccess = { kind = "tenant"; name = "client"; }` for `esp.nixos`, `esp.hetz`, and `esp.clab`, and `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-nebula-underlay-access.sh` is the focused guard. If the compiler still reports `iot`, debug the locked input first with `nix flake metadata --json /home/deadbeef/github/network-compiler | jq '.locks.nodes."network-labs".locked.rev'` and then inspect the locked source's `labs/lab-s-sigma/s-router-test-three-site/intent.nix`; the likely fix is lock propagation into `network-compiler/flake.lock`, not a local renderer or NixOS patch. | reason=The compiler is correctly refusing an underlay access tenant that cannot reach the external underlay. The lab intent must select a tenant/access path with modeled WAN egress for the overlay daemon underlay; downstream repos must consume a lock that contains that intent rather than compiling a stale `iot` copy.

- state=still-broken | target=s-sigma-clab-client-ipv6-public-egress | evidence=2026-05-21 live `s-router-clab` showed `clab-router-access-client` and `clab-client01` had IPv6 defaults toward `clab-router-downstream`, but the downstream/policy/upstream path missed the client IPv6 WAN policy defaults and returned `Destination unreachable: No route`. A narrow live hotpatch adding only those client IPv6 policy defaults on downstream -> policy -> upstream made `clab-client01 ping -6 2606:4700:4700::1111` pass. Trying to realize a client east-west p2p lane in inventory failed correctly because NFM did not derive such a lane from intent. | reason=The lab intent already models normal client WAN egress and explicit NAT66 for the simulated ISP source prefixes, including client ULA. CPM route classification currently drops the client IPv6 WAN default because the tenant also owns a runtime routed prefix; that is too broad. Runtime routed-prefix tenants must avoid NAT66 only when the selected egress lane is routed/overlay, not when the selected explicit simulated-ISP WAN uplink has modeled NAT66 source scope.

- state=fixed-but-only-locally-tested | target=s-sigma-core-nebula-underlay-attachment-shape | evidence=2026-05-24 the focused regression rejects the stale underlay inventory shape: any `underlay-*core-nebula` / `underlay-access-client` port, any `p2p-*-access-client-*-core-nebula` link binding, and any matching access-client/core-nebula stale bridge on the NixOS, Hetzner, or CLAB host inventories. The current inventory realizes each Nebula core through a `tenant-client` port on the `client` bridge with `logicalInterface = "tenant-client"` and separately requires a core-nebula/upstream payload link. `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-nebula-underlay-access.sh` is the focused guard. | reason=Removing the hidden WAN bridge was not enough. The access-side underlay must be an ordinary tenant/client LAN attachment, not another p2p router adjacency. The payload-side upstream adjacency is a different leg and must remain explicit for hostile/client traffic that enters the overlay.

- state=still-broken | target=s-sigma-core-nebula-local-dns-and-underlay-leak-scope | evidence=2026-05-25 live `nixos-router-core-nebula dig google.com` timed out against `127.0.0.1#53` even though `ping 1.1.1.1` from the same core worked over the client underlay. The expected behavior is local-only resolver service for core daemon/control needs: loopback recursion may reach the underlay internet path, but DNS must not be reachable from p2p/fabric interfaces and must not open direct public DNS leakage. | reason=This is DNS service materialization/leak-prevention validation, not a reason to add a broad firewall accept. The owning layer is the CPM-to-NixOS DNS/firewall output once live proof identifies whether Unbound listener, outgoing-interface, nft output, or policy route selection is blocking loopback recursion.

- state=still-broken | target=s-sigma-normal-tenant-ipv6-public-egress | evidence=2026-05-25 live `nixos-client01 dig google.com` returned an A record through the local stub, but `nixos-client01 ping -6 google.com` and `nixos-router-core-nebula ping 2a00:1450:400e:804::200e` both lost 100%. This is consistent with the existing simulated ISP NAT66 exception not being fully validated for normal tenants after the underlay/core changes. | reason=IPv6 public dataplane failure is separate from DNS record resolution. The lab/model must either explicitly provide the simulated-ISP NAT66 exception for normal tenants or prove routed IPv6; it must not be hidden by DNS checks that only validate AAAA lookup.

- state=still-broken | target=s-sigma-streaming-public-egress-live-validation | evidence=2026-05-25 live `nixos-streaming-test` has DHCP address `10.20.50.100/24` and default route via `10.20.50.1`, but `ping -4 1.1.1.1` lost 2/2. Live nft/routing checks show the modeled streaming path exists through access/downstream/policy/upstream: `tenant-streami -> transit`, downstream table 2005 to `policy-stream`, policy to `up-stream-a`/`up-stream-b`, and upstream nft accepts `pol-stream-a -> core-a` and `pol-stream-b -> core-b`; core ISP routers have `upstream -> eth0` accept and NAT masquerade. | reason=Streaming is included in `allow-user-tenants-to-uplinks`, so this should work. The next proof must use live tcpdump/conntrack at the core/host boundary to determine whether packets are lost at core NAT, host egress, or return path; do not remove streaming from intent or add a local endpoint workaround.

- state=still-broken | target=s-sigma-hostile-overlay-egress-missing-upstream-core-nebula-leg | evidence=2026-05-25 live `nixos-router-upstream nft list ruleset` had no `pol-hostile-ew -> core-nebula` accept and no live upstream-side `core-nebula` interface; hostile overlay egress cannot traverse the README path `access-hostile -> downstream -> policy -> upstream -> core-nebula -> overlay`. The visible rules only had stale `pol-hostile-ew -> pol-hostile-ew` 4444 accepts and ordinary ISP core lanes. | reason=This is the runtime symptom of the payload adjacency being removed while repairing the daemon underlay. The durable fix belongs in the lab/compiler model shape and then downstream CPM/renderer materialization; adding an nft accept alone is invalid until there is an explicit modeled output interface.

- state=still-broken | target=s-sigma-simulated-isp-nat66-intent | evidence=2026-05-21 live `s-router-test-clients` showed normal NixOS clients resolve A and AAAA through the modeled site DNS path, but `nixos-client01 ping -6 google.com` fails while IPv4 public egress works. The NixOS simulated ISP cores `isp-a` and `isp-b` model `::/0` uplinks backed by host VLAN egress that only supplies an external /64, so tenant ULA public IPv6 egress needs explicit NAT66 for those simulated ISP uplinks. | reason=NAT66 is undesirable and must be loud, explicit model intent, not a default. This lab needs an intentional simulated-ISP exception for normal access tenants only; hostile must not use NAT66 because hostile IPv6 is routed GUA over the modeled east-west/Hetzner path with ULA-only transit hops.

- state=still-broken | target=s-sigma-dmz-dns-recursion-scope | evidence=2026-05-21 live `nixos-dmzweb01` cannot ping or direct-query public `1.1.1.1`, but `dig google.com` succeeds through `127.0.0.53 -> 10.20.30.1 -> site-dns-mgmt -> public forwarders`. This is not a direct public DNS nft leak; current intent allows DMZ tenant DNS to the site DNS service and allows that service to recurse to `isp-a`/`isp-b`. | reason=DMZ should resolve internal/access/service names but must not obtain public recursive DNS. The intent/model needs split DNS semantics or a DMZ-local/internal-only resolver path; access/core resolvers must not accept traversal that lets DMZ external-recursive queries leak through another tenant.

- state=still-broken | target=s-sigma-hostile-ipv4-egress-lost | evidence=2026-05-21 live `nixos-hostile-node01 ping 1.1.1.1` has 100% loss, while `ping 2a00:1450:400e:80b::200e` returns over IPv6 GUA at least intermittently. | reason=Hostile IPv4 public egress is model feedback, not a node-specific hack. The hostile IPv4 egress/NAT path must remain explicit through the modeled hostile east-west/Hetzner lane; renderer or runtime glue must not recover it with local routes.

- state=fixed-locally | target=s-sigma-hostile-traceroute-icmp-visibility | evidence=2026-05-21 live `nixos-hostile-node01 traceroute -n 1.1.1.1` first showed hop 1 `10.20.70.1`, hops 2-4 as `*`, then hop 5 `10.10.0.16`, hop 6 `100.96.10.3`, and hop 7 `10.80.0.11`. Direct pings from the hostile endpoint to transit p2p addresses timed out, and downstream/policy/upstream route lookups for `10.20.70.100` sourced from their p2p addresses returned `RTNETLINK answers: Network is unreachable`. Live route hotpatches adding the explicit hostile return prefix to the affected main tables made UDP and ICMP traceroute show hops 2-4 as `10.10.0.7`, `10.10.0.25`, and `10.10.0.39`. | reason=The lab intent already has an allowed routed hostile lane and CPM provides explicit non-default route facts. The first-bad layer for this symptom is NixOS renderer materialization: router-originated ICMP diagnostics do not enter with an `iif`, so safe non-default policy-lane return routes must also be present in `main`. Full rebuild-loop validation is still required before marking this solved.

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

- state=fixed-but-only-locally-tested | target=s-sigma-nebula-underlay-access-inventory-realization | evidence=2026-05-24 the previous "fixed-locally" inventory realization was the live bug: `nixos-router-core-nebula` came up with `access-client@if69 10.10.0.3/31`, while `nixos-router-access-client` had reciprocal `core-nebula@if76 10.10.0.2/31` plus the real tenant LAN `tenant-client@if77 10.20.20.1/24`. The lab inventory now removes those reciprocal p2p ports and stale bridges for NixOS, Hetzner, and CLAB, and realizes core-nebula on the selected client tenant bridge. `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-lab-sigma-nebula-underlay-access.sh` checks the resolved inventory shape. | reason=Inventory may bind bridges, interface names, MACs, MTU, VLANs, and DHCP/SLAAC realization facts, but it must not turn an overlay daemon underlay access selection into a p2p fabric link. The live lab must still be rebuilt before this can move out of local-test state.
- state=runtime-checks | Add focused `network-labs` tests that compile both prod-like lab targets at
  the same time: the current `s-router-test-three-site` NixOS/Hetzner lab and
  the new dedicated `s-router-clab` CLAB lab. The tests must fail if
  `s-router-clab` is only an alias for the NixOS inventory or if either lab
  drops site-a/site-b/site-c coverage.
- state=runtime-checks | After `network-labs` tests pass, continue down the locked chain in order:
  `network-compiler`, `network-forwarding-model`,
  `network-control-plane-model`, `network-renderer-containerlab-linux-backend`,
  `network-renderer-nixos`, and then the NixOS rebuild loop.
