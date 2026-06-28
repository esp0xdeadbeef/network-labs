# Controlled SAT Intent Policy Notes

This lab models one enterprise, `esp`, with three peer sites:

- `esp.nixos`: the normal home/server network rendered for NixOS.
- `esp.hetz`: the hosted edge site with WAN, DMZ, client access, and public
  service entry points.
- `esp.clab`: the Containerlab mirror used to exercise the same segmentation
  shape plus a hostile egress test tenant.

This document describes `intent.nix`. Inventory files should realize addresses,
hosts, and renderer details, but should not invent policy meaning that is absent
from the intent.

This directory is the controlled SAT source. Examples under
`network-labs/examples` are lower-layer fixtures for RaTM, SMT, SIT, and HAT
proof; they are not SAT source evidence by themselves. `SAT-SOURCE-CONTRACT.md`
maps the major intent and inventory sections used for SAT provenance.
That contract is not live SAT evidence. It records the WireGuard provider
source scenarios and the NixOS/CLAB emulated-ISP PPPoE source scenarios.
WireGuard service, traffic, overlay, and policy tuples stay in `intent.nix`;
the WireGuard provider-profile realization contract stays in `inventory.nix`,
including prefix authority, NAT, public endpoint, public-ingress or
port-forward, runtime paths, and return routes. PPPoE distribution and probe
metadata live in the provider-access fixture table, while normal site behavior
remains in `intent.nix` and inventory binds the harness realization facts.
Those PPPoE realization facts use per-harness isolated Ethernet bridges by
default so NixOS and CLAB runs do not share physical VLAN handoffs. HAT/SAT
runtime proof is still required before full SAT promotion is possible.

## Current Source-To-Artifact Status

2026-06-28 pre-HAT SAT prerequisite check found that
`s-router-test-clients` rejected the SAT source with
`FS-725-HDS-020-SDS-010-SMS-010: MGMT_BRIDGE_ENDPOINT_TRAFFIC`. The first wrong
layer was the SAT inventory: `nixos-emulated-sigma` and
`clab-emulated-sigma` attach to the management bridge, but the source contract
did not explicitly classify them as management endpoints. The inventory now
sets `role = "management"` for both rows, and
`tests/test-s-sigma-sat-source-contract-comments.sh` asserts that bridge,
tenant, and role remain coherent.

Evidence commands exited 0:

```bash
bash tests/test-s-sigma-sat-source-contract-comments.sh
nix build --dry-run --no-link --print-out-paths \
  path:/home/deadbeef/github/nixos#nixosConfigurations.s-router-{clab,nixos,test-clients}.config.system.build.nixos-shell \
  --override-input network-labs path:/home/deadbeef/github/network-labs
```

This is source-to-artifact prerequisite evidence only. It does not claim live
SAT acceptance.

## Policy Model

The target is a realistic segmented network, not a flat routed LAN.

- `mgmt` is an infrastructure control-plane zone. It should model access to
  router, switch, hypervisor, iDRAC, or PiKVM-style management surfaces, not
  generic internet-capable production traffic.
- `admin` is an administrative client zone. It may reach management services
  only through explicit policy.
- `client` is the normal user/client network. It has internet access and
  approved service access, but no implicit lateral trust.
- `streaming` is the media/device zone. Clients may discover and control media
  devices through named Cast-style services; streaming must not initiate into
  clients.
- `dmz` is for exposed or edge services such as DNS and Nebula/lighthouse
  components.
- `hostile` is intentionally retained as a test tenant. It is not the normal
  client model. It exists to validate overlay-routed egress and public inbound
  service handling.
- `east-west` is transport only. It does not grant trust by itself, and overlays
  must traverse policy.

DNS is service-mediated. Tenants use DNS service objects instead of raw WAN DNS
egress. Broad WAN access appears only after the DNS-specific denies.

## Static and BGP Uplink Policy

SAT SHALL include both static and BGP uplink testing. Uplink type is a
parameter within the intent, not a separate fixture directory.

### Static Uplink

The intent SHALL declare `uplink.type = "static"` with `static.nextHop`
and `static.prefix` fields. The CPM SHALL emit static route records with
the declared next-hop. Runtime evidence at SAT SHALL verify the static
default route is installed and end-to-end reachability works through the
static path.

### BGP Uplink

The intent SHALL declare `uplink.type = "bgp"` with `bgp.localAsn`,
`bgp.peerAddress`, and `bgp.peerAsn` fields. The CPM SHALL emit
BGP-derived forwarding records including AS-path, next-hop, and prefix
advertisement scope. Runtime evidence at SAT SHALL verify BGP session
establishment, route acceptance, and end-to-end reachability through the
BGP-learned path.

Existing SAT fixtures use static and DHCP uplinks by default. BGP uplink
SHALL be added as an alternative uplink type on at least one WAN interface,
with the eBGP peer simulated by the emulated ISP testnet infrastructure.

## Service-Mediated Flows

The intent uses services for named destinations instead of direct tenant-to-
tenant trust:

- Site DNS: `site-dns-mgmt`, `clab-site-dns`, `hetz-dns-dmz`.
- Nebula edge service: `dmz-nebula`.
- Cast/media device access: `cast-discovery` and `cast-control`.
- Public service entries:
  - `nixos-hostile-4444` reaches `nixos-hostile01`.
  - `clab-client-4445` reaches `clab-client01`.
  - `hetz-client-4446` reaches `hetz-client01`.

Cast discovery and control are intentionally separated:

- `cast-discovery`: UDP `5353` for mDNS and UDP `1900` for SSDP.
- `cast-control`: TCP `8008` and `8009` for Google Cast control/status traffic.

This keeps the discovery policy readable while still allowing the control path a
real Cast receiver commonly needs.

## Hostile Test Behavior

The hostile tenant is constrained differently from the normal client network:

- It cannot use local WAN uplinks directly.
- It cannot initiate to local production or management tenants.
- It may egress through `east-west`, so a rented Hetzner-hosted workload can be
  tested with traffic exiting through the Hetz edge/core.
- Hetz exposes the public entry service for NixOS hostile on port `4444`.

CLAB also keeps a hostile tenant for overlay-egress testing, but the CLAB public
port-forward target is deliberately the normal `client` tenant on port `4445`.
That keeps the hostile test separate from the normal client-access test.

## Public Entry Ports

The visible ports are intentionally distinct:

- `4444`: Hetz WAN to `esp.nixos` hostile client service.
- `4445`: Hetz WAN to `esp.clab` client service.
- `4446`: Hetz WAN to `esp.hetz` local client access service.

Each corresponding tenant prefix carries a runtime IPv6 routed-prefix request
with a readable postfix marker matching the service port.

## Naming

All sites live under the same enterprise namespace, `esp`.

Topology node names include the site name and use readable selector names:

- `nixos-router-upstream` / `nixos-router-downstream`
- `hetz-router-upstream` / `hetz-router-downstream`
- `clab-router-upstream` / `clab-router-downstream`

The role values remain semantic (`upstream-selector`,
`downstream-selector`) because renderers may depend on those role names.
