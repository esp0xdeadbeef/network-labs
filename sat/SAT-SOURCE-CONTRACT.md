# SAT Source Contract

This directory is the controlled SAT source for the current GAMP network
baseline:

`network-labs/sat`

Examples under `network-labs/examples` are lower-layer fixtures for RaTM, SMT,
SIT, and HAT proof. They are not SAT source evidence by themselves.

This document is not SAT evidence. It is source provenance only. A SAT row is
not proven until locked controlled execution consumes this source and live
evidence passes from the owning harness contexts.

## Why Provider And Upstream Scenarios Are Mandatory

The acceptance claim is "model once, realize anywhere." A Nebula-only
controlled source proves only one provider-rendered path. It does not prove
that the same model contracts can also drive a WireGuard provider renderer, and
it does not prove the different WireGuard provider modes that change address
authority, NAT/NAT66, public ingress, DNS leak prevention, and return routing.

Therefore the controlled SAT source must contain separate source scenarios for:

| Scenario ID | Required source scenario | Current source state |
| --- | --- | --- |
| `SAT-SCEN-PROVIDER-NEBULA-001` | Nebula provider-rendered path with explicit runtime facts and overlay policy. | Source provenance present; SAT live proof not provided by this document. |
| `SAT-SCEN-PROVIDER-WG-128-EGRESS-001` | WireGuard provider host-only `/128` egress/NAT with explicit NAT44/NAT66/SNAT, DNS policy, firewall, and no downstream GUA. | Source provenance present in `intent.nix` under `SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS` for service, traffic, overlay, and policy tuples, and in `inventory.nix` under `SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS` for the provider-profile realization contract; SAT live proof not provided by this document. |
| `SAT-SCEN-PROVIDER-WG-64-ROUTED-001` | WireGuard routed or provider-owned `/64` with explicit prefix authority, return path, no router client GUA, and no NAT66 for routed GUA. | Source provenance present in `intent.nix` under `SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS` for service, traffic, overlay, and policy tuples, and in `inventory.nix` under `SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS` for the provider-profile realization contract; SAT live proof not provided by this document. |
| `SAT-SCEN-PROVIDER-WG-PORTFWD-001` | WireGuard public-ingress or port-forward with explicit listen address, protocol, listen port, target node, target address, target port, route leg, forward rule, return rule, and NAT/NAPT behavior. | Source provenance present in `intent.nix` under `SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS` for service, traffic, overlay, and policy tuples, and in `inventory.nix` under `SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS` for the provider-profile realization contract; SAT live proof not provided by this document. |
| `SAT-SCEN-EMULATED-ISP-NIXOS-001` | NixOS emulated-ISP source scenario for `s-router-test`; the customer core remains inside the default access/downstream-selector/policy/upstream-selector/core fabric, and the customer uplink receives public-facing IPv4 and IPv6 only through PPPoE, not WAN DHCP or SLAAC. Normal site behavior stays in `intent.nix`; provider role, PPPoE address delivery, public-facing prefix/address authority, DNS follow-source behavior consumed by the site resolver or Unbound-equivalent path, firewall/leak-prevention behavior, NAT44/SNAT behavior, no NAT66 for routed GUA, and pass/fail probes live in `provider-access-fixture-table.nix`. Inventory binds only backend, host, per-harness isolated Ethernet handoff bridge, access-concentrator implementation, MTU, and lab-only credential references. Physical PPPoE VLAN handoff requires an explicit exclusive-run guard. | Source provenance present in `provider-access-fixture-table.nix` and in `inventory.nix` under `SAT-SRC-INVENTORY-UPSTREAM-EMULATION`; `intent.nix` shall not carry `upstreamEmulation`; HAT/SAT live proof not provided by this document. |
| `SAT-SCEN-EMULATED-ISP-CLAB-001` | CLAB/Linux emulated-ISP source scenario equivalent to the NixOS provider-side contract; runtime packaging may differ, but the modeled provider-access row, public-facing address behavior, DNS follow-source behavior consumed by the site resolver or Unbound-equivalent path, firewall/leak-prevention behavior, NAT44/SNAT behavior, no NAT66 for routed GUA, and pass/fail probes must stay equivalent unless changed by control. Normal site behavior stays in `intent.nix`; PPPoE fixture detail lives in `provider-access-fixture-table.nix`. Inventory binds only backend, host, per-harness isolated Ethernet handoff bridge, access-concentrator implementation, MTU, and lab-only credential references. Physical PPPoE VLAN handoff requires an explicit exclusive-run guard. | Source provenance present in `provider-access-fixture-table.nix` and in `inventory.nix` under `SAT-SRC-INVENTORY-UPSTREAM-EMULATION`; `intent.nix` shall not carry `upstreamEmulation`; HAT/SAT live proof not provided by this document. |

## Source Authority

| Source marker | File | SAT source meaning |
| --- | --- | --- |
| `SAT-SRC-INTENT-001` | `intent.nix` | Declares this lab intent as the controlled s-router SAT behavior source. |
| `SAT-SRC-INTENT-NIXOS-COMMS` | `intent.nix` | NixOS site DNS, public exposure, internet policy, hostile overlay egress, and leak prevention behavior. |
| `SAT-SRC-INTENT-NIXOS-OWNERSHIP` | `intent.nix` | NixOS site tenants, services, endpoint ownership, routed prefixes, and address authority. |
| `SAT-SRC-INTENT-NIXOS-TRANSPORT` | `intent.nix` | NixOS site overlay membership, underlay access, and hostile path traversal. |
| `SAT-SRC-INTENT-NIXOS-UPSTREAM-EMULATION` | retired from `intent.nix` | Retired source slot. NixOS emulated-ISP fixture detail moved to `provider-access-fixture-table.nix`; normal NixOS site behavior remains in `intent.nix` without an `upstreamEmulation` side channel. |
| `SAT-SRC-INTENT-HETZ-COMMS` | `intent.nix` | Hetzner hosted edge DNS, public ingress, east-west return paths, internet policy, and leak prevention behavior. |
| `SAT-SRC-INTENT-HETZ-OWNERSHIP` | `intent.nix` | Hetzner hosted edge tenants, services, public-entry targets, routed prefixes, and provider edge address authority. |
| `SAT-SRC-INTENT-HETZ-TRANSPORT` | `intent.nix` | Hetzner hosted edge overlay membership, lighthouse placement, and east-west transport behavior. |
| `SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS` | `intent.nix` | Hetzner WireGuard provider service, traffic, overlay, and policy tuple authority. This marker authorizes the behavior and path shape; it does not carry provider-profile realization facts such as prefix authority, NAT, generated peer files, public endpoint, public-ingress or port-forward realization, or return-route bindings. |
| `SAT-SRC-INTENT-CLAB-COMMS` | `intent.nix` | CLAB site DNS, hostile overlay egress, normal client public service exposure, internet policy, and leak prevention behavior. |
| `SAT-SRC-INTENT-CLAB-OWNERSHIP` | `intent.nix` | CLAB site tenants, services, endpoint ownership, routed prefixes, and hostile/client address authority. |
| `SAT-SRC-INTENT-CLAB-TRANSPORT` | `intent.nix` | CLAB site overlay membership, underlay access, and hostile path traversal. |
| `SAT-SRC-INTENT-CLAB-UPSTREAM-EMULATION` | retired from `intent.nix` | Retired source slot. CLAB emulated-ISP fixture detail moved to `provider-access-fixture-table.nix`; normal CLAB site behavior remains in `intent.nix` without an `upstreamEmulation` side channel. |
| `SAT-SRC-MGMT-CORE-HOST-AUTHORITY` | `management-core-host-authority.nix` | Source-side management-plane and core-boundary host exception authority tuples: source scope, target host or role, protocol, port, authentication boundary, recovery mode, target address, attachment surface, traffic class, and explicit denial of forwarding/service side effects. |
| `SAT-SRC-INVENTORY-001` | `inventory.nix` | Declares this lab inventory as the controlled s-router SAT realization source. |
| `SAT-SRC-INVENTORY-CLAB-ROLES` | `inventory.nix` | Containerlab role mapping for the s-router CLAB mirror. |
| `SAT-SRC-INVENTORY-CONTROL-PLANE` | `inventory.nix` | Renderer control-plane facts, overlays, runtime nodes, provider bindings, and routing-service choices. |
| `SAT-SRC-INVENTORY-DEPLOYMENT` | `inventory.nix` | Harness hosts, bridge networks, VLAN attachments, management boundaries, and runtime placement. |
| `SAT-SRC-INVENTORY-ENDPOINTS` | `inventory.nix` | Endpoint/client placement and client validation contexts. |
| `SAT-SRC-INVENTORY-MTU` | `inventory.nix` | Explicit MTU realization fact used to prove inventory MTU acceptance and renderer MTU projection without role/name inference. |
| `SAT-SRC-INVENTORY-PROVIDER-BOOTSTRAP-DNS` | `inventory.nix` | Provider-bootstrap resolver facts for overlay startup; these facts are separate from customer, tenant, hostile, and Unbound resolver policy. |
| `SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS` | `inventory.nix` | WireGuard provider-profile realization authority for the controlled host-only `/128`, provider-owned `/64`, and public-ingress/port-forward scenarios. These inventory facts bind prefix authority, generated peer addresses and secret paths, public endpoint, NAT/NAT66 behavior, provider-owned prefixes, public-ingress/port-forward realization, runtime paths, and return routes to the WireGuard provider profiles without creating service, traffic, overlay, or policy tuple authority. |
| `SAT-SRC-INVENTORY-STATIC-RESERVATION` | `inventory.nix` | Static DHCP and DHCPv6 client reservation facts for a controlled NixOS client access scope, including client identity, MAC address, DHCPv6 service pool, host offsets, namespace owner, and fail-closed conflict behavior. |
| `SAT-SRC-INVENTORY-UPSTREAM-EMULATION` | `inventory.nix` | NixOS and CLAB emulated-ISP realization bindings for the provider-access fixture rows: backend, host, fake-provider upstream VLAN `4`, distinct isolated Ethernet PPPoE handoff bridges with `physical = false`, provider runtime node, customer runtime node, paired handoff link/interface, provider-side access concentrator, server/client PPPoE service placement, MTU, and lab-only credential references. |
| `SAT-SRC-INVENTORY-SECRET-DECLARATIONS` | `inventory.nix` | FS-810 source construction records for controlled SAT secret declarations. These records identify credential/runtime-fact class, site, tenant when applicable, host, consumer, purpose, lifecycle, and mandatory classification without plaintext material, source selection, or network policy authority. |
| `SAT-SRC-INVENTORY-SECRET-SOURCE-BINDINGS` | `inventory.nix` | FS-820 source construction records for controlled SAT declaration-to-source bindings. These records bind each declaration to one provider-neutral allowed source class such as protected inventory, runtime fact, or deployment-platform secret reference without making route, firewall, DNS, public-ingress, reachability, or trust-boundary policy. |
| `SAT-SRC-INVENTORY-OPERATIONAL-PRIVACY` | `inventory.nix` | FS-910 source construction records for controlled operational metadata privacy. These records classify DNS query, client identity, service discovery, flow summary, lease state, provider state, and validation-failure detail metadata, attach retention/access/redaction expectations, and require explicit scoped detail-mode selection. |
| `SAT-SRC-INVENTORY-FAILURE-HANDLING` | `inventory.nix` | FS-920 source construction records for modeled failure handling. These records declare provider loss, overlay loss, DNS failure, route withdrawal, route leak, address conflict, state loss, ingress conflict, NAT exhaustion, NAT66 exhaustion, and secret expiry classes, bind one controlled response per class, and preserve deny-by-default/no-unmodeled-fallback authority. |
| `SAT-SRC-INVENTORY-FAILURE-DIAGNOSTICS` | `inventory.nix` | FS-930 source construction records for deterministic diagnostics. These records declare required diagnostic fields, input-state and value-class taxonomy, protected-value redaction, and repair routing back to the owning source layer with no renderer-local, script-local, or lower-layer heuristic repair authority. |
| `SAT-SRC-INVENTORY-REALIZATION` | `inventory.nix` | Concrete nodes, ports, services, secrets, DHCP/RA, DNS service placement, and provider runtime facts. |

## GAMP Requirement Link

- `URS-170`: Controlled tests prove production-relevant behavior.
- `URS-170-FS-010`: SAT evidence without test shortcuts.
- `URS-170-FS-020`: SAT evidence bound to the current network baseline.
- `URS-180`: Evidence uses the correct context.
- `URS-180-FS-010`: Correct evidence context.
- `URS-190`: Examples and SAT sources are separate.
- `URS-190-FS-010`: Examples and SAT source separation.

## URS SAT Obligation Matrix

Every URS row must be proven by live SAT evidence for this controlled source.
No partial source marker, examples sweep, or parser check promotes a SAT row.

| URS ID | SAT proof obligation |
| --- | --- |
| `URS-010` | Prove NixOS, CLAB/Linux, Nebula, WireGuard `/128`, WireGuard `/64`, and WireGuard public-ingress source scenarios realize the same model where supported. WireGuard source provenance is present, but live SAT proof is still required. |
| `URS-020` | Prove intent carries behavior, inventory/runtime facts carry realization, and no runtime or renderer glue changes network semantics. |
| `URS-030` | Prove deterministic scoped outputs and provenance from the locked source set. |
| `URS-040` | Prove missing required behavior, realization, provider, or runtime facts fail at the owning layer before renderer/runtime guessing. |
| `URS-050` | Prove least-privilege policy ownership, explicit allow/deny behavior, and no renderer/runtime policy invention. |
| `URS-060` | Prove deterministic client identity and address recalculation from modeled identity and prefix facts. |
| `URS-070` | Prove IPv4 no-internet, private NAT, routed public IPv4, host-only upstream, and DNS leak-policy behavior from controlled endpoints. |
| `URS-080` | Prove IPv6 no-internet, ULA+NAT66, routed client GUA, hostile routed GUA over overlay, no raw ULA to WAN, and no NAT66 for routed GUA. |
| `URS-090` | Prove modeled client address reachability and separate host management reachability from the correct client and management contexts. |
| `URS-100` | Prove prefix availability, non-delegating `/128`, WAN/test `/64`, routed prefix authority, deterministic child prefixes, and return routing. WireGuard and fake-provider source provenance is present, but live SAT proof is still required. |
| `URS-110` | Prove client/delegated GUA appears only on clients, not intermediate router hops. |
| `URS-120` | Prove modeled resolver success, resolver loopback, resolver-service egress, and direct public-DNS denial separately. |
| `URS-130` | Prove static, BGP, mixed, and scoped routing-style selections through artifacts and live services where applicable. |
| `URS-140` | Prove hostile overlay egress, DNS service path, direct-DNS denial, route legs, return paths, and firewall counters from hostile contexts. |
| `URS-150` | Prove controlled secret materialization, runtime secret scope/freshness, and cleanup behavior for overlay/provider/runtime consumers. |
| `URS-160` | Prove selected persistence, operational records, or explicit ephemeral behavior for DHCP, DHCPv6, DNS, resolver, and related stateful services. |
| `URS-170` | Prove production-relevant shapes including Nebula, WireGuard `/128`, WireGuard `/64`, WireGuard public ingress, NixOS fake-provider, and CLAB fake-provider; controlled source provenance is present, but live SAT proof is still required. |
| `URS-180` | Prove each SAT acceptance row records exact source, command, context, artifact, and aggregate validator result. |
| `URS-190` | Prove this controlled SAT source, not examples-only fixtures, is the source for the locked SAT execution. |

## Validation Rule

SAT evidence is valid only when locked controlled execution consumes this
source and the live runtime evidence passes from the owning harnesses. Passing
examples or examples-only compile sweeps cannot promote SAT rows.
