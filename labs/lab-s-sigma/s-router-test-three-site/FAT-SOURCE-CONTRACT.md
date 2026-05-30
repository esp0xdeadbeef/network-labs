# s-router FAT Source Contract

This directory is the controlled disposable FAT source for the s-router model:

`network-labs/labs/lab-s-sigma/s-router-test-three-site`

Examples under `network-labs/examples` are lower-layer fixtures for RaTM, SMT,
SIT, and HAT proof. They are not FAT source evidence by themselves.

This document is not FAT evidence. It is source provenance only. A FAT row is
not proven until the locked full lab execution consumes this source and live
evidence passes from the owning harness contexts.

## Why Provider And Upstream Scenarios Are Mandatory

The FAT claim is "model once, realize anywhere." A Nebula-only controlled
source proves only one provider-rendered path. It does not prove that the same
model contracts can also drive a WireGuard provider renderer, and it does not
prove the different WireGuard provider modes that change address authority,
NAT/NAT66, public ingress, DNS leak prevention, and return routing.

Therefore the controlled FAT source must contain separate source scenarios for:

| Scenario ID | Required source scenario | Current source state |
| --- | --- | --- |
| `FAT-SCEN-PROVIDER-NEBULA-001` | Nebula provider-rendered path with explicit runtime facts and overlay policy. | Source provenance present; FAT live proof not provided by this document. |
| `FAT-SCEN-PROVIDER-WG-128-EGRESS-001` | WireGuard provider host-only `/128` egress/NAT with explicit NAT44/NAT66/SNAT, DNS policy, firewall, and no downstream GUA. | `FAT-SRC-GAP-WIREGUARD-128-001`: source gap; FAT blocked. |
| `FAT-SCEN-PROVIDER-WG-64-ROUTED-001` | WireGuard routed or provider-owned `/64` with explicit prefix authority, return path, no router client GUA, and no NAT66 for routed GUA. | `FAT-SRC-GAP-WIREGUARD-64-001`: source gap; FAT blocked. |
| `FAT-SCEN-PROVIDER-WG-PORTFWD-001` | WireGuard public-ingress or port-forward with explicit listen address, protocol, listen port, target node, target address, target port, route leg, forward rule, return rule, and NAT/NAPT behavior. | `FAT-SRC-GAP-WIREGUARD-PUBLIC-001`: source gap; FAT blocked. |
| `FAT-SCEN-EMULATED-ISP-NIXOS-001` | NixOS fake-provider or PPPoE-like upstream-emulation source scenario for `s-router-test`; local substrate uses VLAN `4` as fake-provider upstream/WAN side and VLAN `11` as provider-to-core handoff. | `FAT-SRC-GAP-PPPOE-NIXOS-001`: source gap; FAT blocked. |
| `FAT-SCEN-EMULATED-ISP-CLAB-001` | CLAB/Linux fake-provider or PPPoE-like upstream-emulation source scenario equivalent to the NixOS scenario; local substrate uses VLAN `4` as fake-provider upstream/WAN side and VLAN `11` as provider-to-core handoff. | `FAT-SRC-GAP-PPPOE-CLAB-001`: source gap; FAT blocked. |

## Source Authority

| Source marker | File | FAT source meaning |
| --- | --- | --- |
| `FAT-SRC-INTENT-001` | `intent.nix` | Declares this lab intent as the controlled s-router FAT behavior source. |
| `FAT-SRC-INTENT-NIXOS-COMMS` | `intent.nix` | NixOS site DNS, public exposure, internet policy, hostile overlay egress, and leak prevention behavior. |
| `FAT-SRC-INTENT-NIXOS-OWNERSHIP` | `intent.nix` | NixOS site tenants, services, endpoint ownership, routed prefixes, and address authority. |
| `FAT-SRC-INTENT-NIXOS-TRANSPORT` | `intent.nix` | NixOS site overlay membership, underlay access, and hostile path traversal. |
| `FAT-SRC-INTENT-HETZ-COMMS` | `intent.nix` | Hetzner hosted edge DNS, public ingress, east-west return paths, internet policy, and leak prevention behavior. |
| `FAT-SRC-INTENT-HETZ-OWNERSHIP` | `intent.nix` | Hetzner hosted edge tenants, services, public-entry targets, routed prefixes, and provider edge address authority. |
| `FAT-SRC-INTENT-HETZ-TRANSPORT` | `intent.nix` | Hetzner hosted edge overlay membership, lighthouse placement, and east-west transport behavior. |
| `FAT-SRC-INTENT-CLAB-COMMS` | `intent.nix` | CLAB site DNS, hostile overlay egress, normal client public service exposure, internet policy, and leak prevention behavior. |
| `FAT-SRC-INTENT-CLAB-OWNERSHIP` | `intent.nix` | CLAB site tenants, services, endpoint ownership, routed prefixes, and hostile/client address authority. |
| `FAT-SRC-INTENT-CLAB-TRANSPORT` | `intent.nix` | CLAB site overlay membership, underlay access, and hostile path traversal. |
| `FAT-SRC-INVENTORY-001` | `inventory.nix` | Declares this lab inventory as the controlled s-router FAT realization source. |
| `FAT-SRC-INVENTORY-CLAB-ROLES` | `inventory.nix` | Containerlab role mapping for the s-router CLAB mirror. |
| `FAT-SRC-INVENTORY-CONTROL-PLANE` | `inventory.nix` | Renderer control-plane facts, overlays, runtime nodes, provider bindings, and routing-service choices. |
| `FAT-SRC-INVENTORY-DEPLOYMENT` | `inventory.nix` | Harness hosts, bridge networks, VLAN attachments, management boundaries, and runtime placement. |
| `FAT-SRC-INVENTORY-ENDPOINTS` | `inventory.nix` | Endpoint/client placement and client validation contexts. |
| `FAT-SRC-INVENTORY-MTU` | `inventory.nix` | Explicit MTU realization fact used to prove inventory MTU acceptance and renderer MTU projection without role/name inference. |
| `FAT-SRC-INVENTORY-PROVIDER-BOOTSTRAP-DNS` | `inventory.nix` | Provider-bootstrap resolver facts for overlay startup; these facts are separate from customer, tenant, hostile, and Unbound resolver policy. |
| `FAT-SRC-INVENTORY-REALIZATION` | `inventory.nix` | Concrete nodes, ports, services, secrets, DHCP/RA, DNS service placement, and provider runtime facts. |

## GAMP Requirement Link

- `USR-VALID-002`: Examples and FAT lab sources are separate.
- `FS-FN-024`: Example and FAT source governance function.
- `HDS-INF-030`: FAT lab source and example fixture boundary.
- `SDS-SW-029`: Example fixture and FAT lab source governance architecture.
- `SMS-MOD-018`: Example fixture and FAT source governance module.
- `CMC-MOD-018`: FAT source governance construction module.
- `FAT-SOURCE-GOVERNANCE-001`: Review/test module for this source contract.

## USR FAT Obligation Matrix

Every USR row must be proven by live FAT evidence for this controlled source.
No partial source marker, examples sweep, or parser check promotes a FAT row.

| USR ID | FAT proof obligation |
| --- | --- |
| `USR-MODEL-001` | Prove NixOS, CLAB/Linux, Nebula, WireGuard `/128`, WireGuard `/64`, and WireGuard public-ingress source scenarios realize the same model where supported. Current WireGuard source gaps block this row. |
| `USR-MODEL-002` | Prove intent carries behavior, inventory/runtime facts carry realization, and no runtime or renderer glue changes network semantics. |
| `USR-MODEL-003` | Prove deterministic scoped outputs and provenance from the locked source set. |
| `USR-MODEL-004` | Prove missing required behavior, realization, provider, or runtime facts fail at the owning layer before renderer/runtime guessing. |
| `USR-INET-001` | Prove IPv4 no-internet, private NAT, routed public IPv4, host-only upstream, and DNS leak-policy behavior from controlled endpoints. |
| `USR-INET-002` | Prove IPv6 no-internet, ULA+NAT66, routed client GUA, hostile routed GUA over overlay, no raw ULA to WAN, and no NAT66 for routed GUA. |
| `USR-REACH-001` | Prove modeled client address reachability and separate host management reachability from the correct client and management contexts. |
| `USR-PREFIX-001` | Prove prefix availability, non-delegating `/128`, WAN/test `/64`, routed prefix authority, deterministic child prefixes, and return routing. Current WireGuard `/64` and fake-provider source gaps block full proof. |
| `USR-PREFIX-002` | Prove client/delegated GUA appears only on clients, not intermediate router hops. |
| `USR-DNS-001` | Prove modeled resolver success, resolver loopback, resolver-service egress, and direct public-DNS denial separately. |
| `USR-ROUTING-001` | Prove static, BGP, mixed, and scoped routing-style selections through artifacts and live services where applicable. |
| `USR-OVERLAY-001` | Prove hostile overlay egress, DNS service path, direct-DNS denial, route legs, return paths, and firewall counters from hostile contexts. |
| `USR-SECRET-001` | Prove disposable-lab secret materialization, runtime secret scope/freshness, and cleanup behavior for overlay/provider/runtime consumers. |
| `USR-STATE-001` | Prove selected persistence, operational records, or explicit ephemeral behavior for DHCP, DHCPv6, DNS, resolver, and related stateful services. |
| `USR-PROD-001` | Prove production-relevant shapes including Nebula, WireGuard `/128`, WireGuard `/64`, WireGuard public ingress, NixOS fake-provider, and CLAB fake-provider; current source gaps block this row. |
| `USR-VALID-001` | Prove each FAT acceptance row records exact source, command, context, artifact, and aggregate validator result. |
| `USR-VALID-002` | Prove this controlled lab source, not examples-only fixtures, is the source for the locked FAT execution. |

## Validation Rule

FAT evidence is valid only when a locked full lab execution consumes this
controlled source and the live runtime evidence passes from the owning
harnesses. Passing examples or examples-only compile sweeps cannot promote FAT
rows.
