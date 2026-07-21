# s-router-prod migration to model-owned behavior

This note describes the minimum migration. It is not production activation
approval. The canonical `github/nixos` checkout stays clean at `origin/main`.
Local consumer compilation uses only
`github/.worktrees/nixos-s-router-prod-reservations/`. Runtime evidence uses the
isolated `s-router-{nixos,clab,test-clients}` hosts and never a production VLAN,
address, resolver, or secret.

## Locked source set

Every active s-router-prod network input in `flake.nix` follows its repository's
canonical `main` branch without an embedded commit. `nix flake update` is the
only mechanism that selects revisions; the resulting `flake.lock` is the only
revision-pinning surface. Separately named legacy fallback inputs are outside
the migrated profile and must not be consumed by it. The controlled root lock
includes:

| Input | Migrated responsibility |
| --- | --- |
| `network-labs` | scenarios, expected evidence, SOPS delivery, and deterministic validation scheme |
| `network-compiler` | preserves explicit intent without inventing egress |
| `network-forwarding-model` | separates path, return, translation, and egress authority |
| `network-control-plane-model` | canonical reservations, DNS selection, local publication, and IPv6 ingress semantics |
| `network-realization-schema` | canonical bundle and normalized platform-binding-bundle validation |
| `network-realization-model` | one canonical renderer input with identity, provenance, scope, and validation release |
| `network-renderer-nixos` | native Kea, Unbound, routes, policy routing, firewall, and lifecycle output |
| `network-renderer-containerlab-linux-backend` | equivalent CLAB topology and Linux runtime output |
| `network-renderer-access-endpoint-nixos` | policy-neutral real test clients and selected protected input delivery |
| `network-renderer-nebula` / `network-renderer-wireguard` | overlay realization without additional policy, DNS, or egress authority |
| `network-renderer-openconfig` | independent OpenConfig projection from the same canonical bundle used by NixOS and CLAB |

These inputs replace host-local reservation parsers, DNS projection scripts,
IPv6/Nebula route patches, policy-routing patches, and post-render firewall
edits. A remaining compatibility module means the migration is incomplete.

## Consumer configuration versus pipeline defects

`prod-network/s-router-prod/intent.nix` must declare policy authority: explicit
allows and denies, protocol/family/port, translation, stateful return, DNS
service relations, and the rule that lateral access never inherits recursion
or egress. `inventory.nix` must declare site facts: hosts, interfaces, provider
bindings, served scopes, protected source references, local DNS namespaces, and
PPPoE/DHCPv6-PD identifiers. Adding a missing authority or site fact there is a
normal migration change, not a network-pipeline defect.

A pipeline defect exists when a downstream repository loses declared meaning,
invents authority, silently chooses one of several egresses, exposes protected
values, or requires consumer-local code to materialize supported behavior.
Multi-egress DNS must resolve to one reproducible, family-complete core and
egress binding. A missing or ambiguous selection emits an address-free
diagnostic such as `DNS_EGRESS_SELECTION_MISSING`,
`DNS_EGRESS_SELECTION_AMBIGUOUS`, `DNS_CORE_ENDPOINT_PATH_MISMATCH`, or
`DNS_CORE_FAMILY_INCOMPLETE`; it must not select a path by ordering or a local
default.

## Protected reservation migration

1. Boot a disposable test client on an isolated access scope. Record the MAC
   and stable, non-temporary IPv6 interface identifier from the same interface.
   Record DUID and IAID when the DHCPv6 mode requires them. Reboot once and
   reject unstable identifiers.
2. Store one complete protected record in SOPS: private hostname, requested
   IPv4 and IPv6, MAC, IID, DUID, and IAID. A hostname containing a serial is a
   secret. No value may enter plain inventory, evaluation output, diagnostics,
   logs, or the Nix store.
3. Declare only the protected schema, ownership, `/run/secrets/...` reference,
   and publication policy. Deliver the decrypted source read-only with mode
   `0400` to the selected runtime.
4. Let the same runtime record generate Kea reservations and local
   A/AAAA/PTR data. Unknown names in an authoritative local namespace terminate
   locally and never fall through to public recursion.
5. Cold-stage from pushed network repositories and the updated consumer lock.
   Shut down all three lab hosts together, prove they are offline, then prove
   new boot IDs, closures, source identities, bundle identities, binding
   identities, and zero failed units. Runtime hotpatches are not evidence.
6. From real isolated clients, prove predictable IPv4 from the MAC and
   predictable IPv6 from the stable IID/DUID/IAID record after reboot. Repeat
   the router posture on NixOS and CLAB.

## Required evidence

- `FS-970-HDS-010-SDS-020-SMS-040` and its SIT prove protected SOPS-to-runtime
  reservation delivery and predictable IPv4/IPv6 on real isolated clients.
- `FS-270-HDS-010-SDS-010-SMS-020` proves state ownership, stateful return,
  reverse-new denial, and no borrowed egress.
- `FS-540-HDS-010-SDS-010-SMS-045` proves IPv4/IPv6 UDP/TCP DNS through one
  model-selected core egress, local-only sharing, lateral `REFUSED`, blocked
  VLAN3-to-core access, and zero DNS-selection warnings.
- `FS-560-HDS-010-SDS-010-SMS-050` proves protected local A/AAAA/PTR
  publication on NixOS and CLAB.
- `FS-230-HDS-010-SDS-010-SMS-040` proves isolated IPv6 UDP/4242 ingress,
  no NAT66/TCP authority, stateful return, and selected-path scoping on NixOS,
  CLAB, and test clients.
- `FS-162-HDS-010-SDS-{010,020,030,040}` proves exact OpenConfig emission,
  fail-closed diagnostics, locked YANG validation, and equal NixOS/CLAB/
  OpenConfig posture from one canonical bundle. It claims construction only,
  not a live OpenConfig device.
- `FS-166-HDS-010-SDS-010-SMS-{901..906}` proves controlled skip
  acknowledgements, one replacement injection at realization, schema release,
  a single normalized platform-binding bundle, canonical renderer input, and
  fresh row-specific runtime evidence after cold stage.

Remove s-router-prod compatibility overrides only after these row predicates
pass from the pushed root lock. Production activation still requires the URS-
defined HAT/SAT and operator approval boundaries.
