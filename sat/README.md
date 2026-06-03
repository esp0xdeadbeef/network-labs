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
That contract is not live SAT evidence. It also records source gaps for the
missing WireGuard provider scenarios and records the NixOS/CLAB emulated-ISP
PPPoE source scenarios. The PPPoE behavior is intent-owned, while inventory
binds the harness realization facts. Those PPPoE realization facts use
per-harness isolated Ethernet bridges by default so NixOS and CLAB runs do not
share physical VLAN handoffs. HAT/SAT runtime proof is still required before
full SAT promotion is possible.

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
