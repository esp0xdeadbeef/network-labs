# s-router-prod: minimal migration to model-owned network behavior

This is a short operator migration note, not production activation approval.
The canonical `github/nixos` checkout remains clean at `origin/main`; only
`github/.worktrees/nixos-s-router-prod-reservations/` is used for local builds.
Runtime proof belongs on the isolated `s-router-{nixos,clab,test-clients}`
hosts, never on VLAN2, a production subnet, or a production address.

## Candidate pins and result

The local consumer candidate uses these pushed minimum revisions or a
descendant recorded by the consumer lock file:

| Flake input | Minimum revision | Responsibility |
| --- | --- | --- |
| `network-labs` | `e80069da5ee0` | isolated rows, protected endpoint contract, SOPS delivery, consumer/defect classification, and an FS-230 stage that selects no Hetzner or production host |
| `network-compiler-prod` / `nixos-network-compiler-prod` | `6dea1cd4315d` | preserve explicit ingress-only intent without invented egress |
| `network-forwarding-model-prod` | `a114b33ae555` | separate physical ingress anchors from egress and NAT authority |
| `network-control-plane-model{,-prod}` | `0684468ba982` | protected reservations and names, IPv6 ingress, and explicit egress selection |
| `network-renderer-nixos{,-prod}` | `1761fc229c44` | native NixOS Kea, DNS, routes, firewall, and five-node ingress realization |
| `network-renderer-containerlab-linux-backend` | `124939a93395` | equivalent CLAB materialization, runtime rule validation, capability-scoped Kea lifecycle labels, and declarative direct-host lifecycle prerequisites |
| `network-renderer-access-endpoint-nixos` | `db9abcb9701a` | real policy-neutral isolated clients with runtime-only protected `/128` plus composition of the explicitly selected consumer SOPS module |
| `network-renderer-nebula` / `network-renderer-wireguard` | `0e6ee9367b40` / `a12d75b229ce` | overlay output without additional policy or DNS authority |
| `network-renderer-openconfig` | `9cff098bc2b9` | direct CPM proof for the same normalized FS-230 posture as NixOS and CLAB; incomplete OpenConfig instance-model coverage remains explicit and no OpenConfig device is a runtime target for this stage |

With these revisions or descendants, `s-router-prod` builds without the local
reservation DNS parser, DNS projections, IPv6/Nebula compatibility module, or
VLAN2 policy override. Kea, protected local A/AAAA/PTR publication, DNS paths,
protected IPv6 routes, and exact firewall handoffs originate in CPM and the
renderers. Host DHCPv4, QEMU bridges, NIC ordering, and MAC addresses of
VM-facing host NICs remain ordinary host realization. Client MAC addresses
that identify a reservation remain only in the protected SOPS record set.

## Configuration versus defect

A change to `prod-network/s-router-prod/{intent,inventory}.nix` is not
automatically a bug. Intent owns allows, denies, family, protocol, port, return
behavior, and translation authority. Inventory and site realization own hosts,
interfaces, endpoints, secret paths, and provider bindings. A pipeline defect
exists only when a downstream layer loses explicit input, invents authority,
or requires host-local network code to materialize it. Adding a missing
s-router-prod authority or site fact to these consumer files is normal migration
configuration and shall be documented as such.

| Required consumer input | Owner | Why this is not a pipeline defect |
| --- | --- | --- |
| separate IPv4 NAPT and IPv6 no-translation Nebula relations | `intent.nix` | only operator intent can grant ingress authority |
| VLAN2-to-core DNS, VLAN3 local-only sharing, and explicit denies | `intent.nix` | lateral access must not inherit recursion or egress |
| core DNS provider, access listeners, and provider/uplink binding | `inventory.nix` | these are site and endpoint facts |
| PPPoE DHCPv6-PD mode, IAID/request ID, and reservation publication schema | `inventory.nix` | these are explicit site and protocol inputs, not renderer defaults |
| local DNS zone authority and protected `namePublication` policy | `inventory.nix` | the site selects namespace, record classes, owner/requesters, and local-only fallback |
| host-management DHCP and VM-facing bridge/NIC/MAC | host realization | these describe the physical consumer host |
| selected SOPS delivery module, secret path, key, and mode | host realization / SOPS module | this binds protected runtime input to the selected NixOS host without exposing its value |
| `/etc/hosts` on the direct Containerlab host | CLAB host realization | Containerlab requires this platform file during cleanup/reconfigure; it is not topology or site intent |
| Kea lifecycle label on a CLAB node | CLAB renderer output | emit it only when the node has renderer-owned Kea reconciliation scripts for an explicitly served scope; an unrelated protected bind is not sufficient |
| private hostname, client MAC, IPv4, IPv6/IID, DUID, and IAID | SOPS runtime source | these values must not enter evaluation, logs, or the Nix store |

- The Nebula migration splits IPv4 NAPT from IPv6 no-translation. IPv6 uses
  UDP/4242, `preserve-source`, stateful return, and exactly one existing VLAN3
  provider endpoint; the endpoint's low 64 bits form the stable IID. These are
  valid `intent.nix` and `inventory.nix` changes, not defects by themselves.
- The current consumer schema keeps protected `routedPrefixes`, slots, prefix
  lengths, and the opaque `sourceFile` under `ownership` in `intent.nix`.
  Despite that filename, these are allocation/site inputs rather than egress
  policy. Do not relocate them merely for cosmetic ownership; the prefix value
  remains runtime-only in SOPS.
- Plain inventory `namePublication` contains only namespace, owner/requesters,
  A/AAAA/PTR classes, local-only fallback, and a redacted diagnostic. CPM
  derives `source` and `sourceFamily`. Hostname, MAC, IPv4, IPv6/IID, DUID, and
  IAID stay out of plain inventory and the Nix store.
- Explicit static/local-only forward and reverse zones in inventory are normal
  DNS authority configuration. A missing desired zone is a consumer migration
  error. A declared zone lost between inventory, CPM, and Unbound is a pipeline
  or renderer defect.
- DNS addresses are endpoint realization; intent refers to named services.
  Multi-egress must produce exactly one reproducible, family-complete core and
  egress binding. Otherwise emit address-free warnings:
  `DNS_EGRESS_SELECTION_MISSING`, `DNS_EGRESS_SELECTION_AMBIGUOUS`,
  `DNS_CORE_ENDPOINT_PATH_MISMATCH`, or `DNS_CORE_FAMILY_INCOMPLETE`.
- PPPoE interface, IAID, and DHCPv6-PD request ID are site inputs. Default
  route, PD client, ordering, and reply firewall belong in CPM/renderers.
- Selecting an existing SOPS module for the endpoint renderer is normal host
  realization. A missing or wrong selected path is a consumer error; silently
  ignoring an explicitly received path is a renderer defect. The first FS-230
  cold stage exposed the latter in revision `d2d78859130a`. Revision
  `104e00047240` fixes it generically and construction-evaluates only secret
  metadata, never the secret value.
- The CLAB host must have declarative `/etc/hosts` before `containerlab destroy
  --cleanup` or `deploy --reconfigure`. A thin NixOS profile may disable its
  normal hosts link, but the CLAB renderer owns restoring this platform
  prerequisite whenever it emits the lifecycle service. No topology or
  inventory change is required. The first cold stage exposed this through a
  Containerlab `ERRO`; the fix keeps `ERRO` handling fail-closed and adds no
  runtime hotpatch.
- A protected routed-prefix reference in `intent.nix` or `inventory.nix` does
  not request DHCP. If a CLAB target has that bind but no served DHCP scope, it
  must keep the bind and receive no Kea lifecycle label. Correcting this
  capability classification is a renderer change; no consumer migration is
  required.
- An isolated endpoint fixture must not inherit an independent default-deny
  firewall after the modeled router path. It must remain policy-neutral and
  must not create a tuple-specific allow. Revision `db9abcb9701a` enforces that
  boundary so positive and negative probes measure only upstream router policy;
  no `intent.nix` or `inventory.nix` migration is required.

## Reservation migration

1. Boot a client on an isolated access scope. Record the MAC and stable,
   non-temporary IPv6 IID from the same interface, plus DUID/IAID where needed.
   Reboot and accept only stable identifiers. Do not use a production VLAN or
   production address for this capture.
2. Put one complete record containing the private hostname, desired IPv4/IPv6,
   and identifiers in SOPS. A hostname may contain a serial number and is as
   protected as MAC, IID, DUID, and IAID. Do not print any record field into
   inventory, logs, diagnostics, evaluation output, or the Nix store.
3. Declare only the opaque schema, `sourceClass = "protected"`, the
   `/run/secrets/...` path, and owner-scoped `namePublication`. Deliver the
   decrypted file mode `0400` and read-only to the selected runtime.
4. Let the same protected record set generate Kea reservations and local
   Unbound data only at runtime. The namespace is authoritative/static: an
   unknown local forward or reverse name terminates locally and never falls
   through to public recursion. After reboot, prove the same MAC receives the
   predictable IPv4 reservation and the same IID/prefix binding receives the
   predictable IPv6 `/128`.
5. Remove host-local generators and overrides only after NixOS and CLAB build
   the same row from pushed pins, all three lab hosts were shut down together,
   were observed offline, and returned with new boot IDs/closures plus exact
   source hashes and pins. `switch-to-configuration`, namespace edits, or other
   runtime hotpatches are not stage evidence.

## Evidence boundary

- `FS-970-HDS-010-SDS-020-SMS-040` and SIT
  `FS-970-HDS-010-SDS-020`: real clients prove SOPS-to-runtime and predictable
  IPv4/IPv6 from stable MAC/IID/DUID/IAID on NixOS and CLAB.
- `FS-270-HDS-010-SDS-010-SMS-020` plus SIT: five-node state owner, stateful
  return, reverse-new deny, and no borrowed egress.
- `FS-540-HDS-010-SDS-010-SMS-045` plus SIT: IPv4/IPv6 UDP/TCP DNS through one
  model-selected core egress, local sharing, lateral `REFUSED`, direct
  VLAN3-to-core blocking, and zero selection warnings.
- `FS-560-HDS-010-SDS-010-SMS-050`: native protected A/AAAA/PTR and local-only
  namespace are construction-green; fresh three-host cold-stage and live
  NixOS/CLAB predicates remain `NOT OK`.
- `FS-230-HDS-010-SDS-010-SMS-040`: exact IPv6 UDP/4242, no NAT66/TCP,
  stateful return, and selected-path scoping are construction-green; the real
  isolated NixOS/CLAB/test-client stage remains `NOT OK`.
- `FS-162-HDS-010-SDS-040-SMS-010`: the same normalized FS-230 posture is
  construction-green through direct NixOS, CLAB, and OpenConfig CPM inputs;
  complete OpenConfig instance-document coverage and a live OpenConfig device
  are not claimed.

The local `s-router-prod` build and migration test are compilation evidence.
Production migration still requires both open cold stages and the required
HAT/SAT/operator approval.
