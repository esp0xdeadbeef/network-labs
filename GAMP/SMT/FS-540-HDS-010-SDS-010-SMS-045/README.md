# FS-540-HDS-010-SDS-010-SMS-045 SMT

Status: NOT OK until the new cold-staged live protocol passes.

This isolated acceptance row mirrors the `s-router-prod` DNS roles without
using VLAN2 or any production client/network. It realizes the same six logical
roles on NixOS and CLAB: recursive access, local-only access, downstream
selector, policy, upstream selector, and a named iterative core resolver.

The row uses lab VLANs 413/414 for the NixOS recursive/local clients and
415/416 for their CLAB equivalents. All four probes originate from real
containers on `s-router-test-clients`. Both IPv4 and IPv6, and both UDP and TCP
DNS, are acceptance predicates.

The core exposes two eligible-looking egresses (`isp-primary` and
`overlay-secondary`), while DNS selects only `isp-primary` by modeled identity.
Both provider surfaces remain isolated host bridges during active-lab
selection. The selector must not infer a physical parent such as `eth0` for
either surface; only the separately modeled management VLAN may use that
parent. A selected inventory that converts either provider into a native or
DHCP host uplink is a construction failure before live DNS evidence is run.
The selected emulated provider shall expose a harness-scoped dual-stack
authoritative hierarchy: root, delegated `dns-validation.test.` namespace, and
terminal record. Only that selected provider may complete the hierarchy. The
alternate provider is a deny/decoy surface and cannot accidentally make the
lookup pass.

The access resolver binds `core-dns` by service/node identity; no core address
or public forwarder is present in the inventory. CPM derives the listener and
forwarder from the provider-side terminal attachment of the selected relation.
The selected path must govern the core resolver's first upstream route decision
for both families; observing the selected table after a failed request is not
sufficient. The live protocol also proves that the resolver process and
authorized listeners remain present and that unchanged dynamic next-hop state
converges without continuous refresh activity.

For IPv6, a visible Router Advertisement is not sufficient evidence. The
selected provider must advertise an autonomous SLAAC prefix (A-bit set), and
the core must acquire both its global address and the selected-table default
route during the first cold boot. The selected provider must also be a
functional IPv6 router surface: receipt or logging of a Router Solicitation,
or a syntactically correct authority configuration, is not proof that an RA
crossed the selected provider bridge. Provider forwarding state must permit
the RA to leave that bridge.

Both ends of that bridge are part of the acceptance boundary. On NixOS the
controlled authority and core port must exchange the RS/RA on the selected
bridge. On CLAB, the core `wan0` host veth and the controlled-authority sidecar
veth must both be actual forwarding members of `isp-primary`; a topology label
without runtime L2 membership is insufficient. The same attachment invariant
applies to core `wan1` and `overlay-secondary`, while no authority sidecar is
allowed on that alternate deny/decoy surface. An RA-only provider mode that
omits SLAAC, provider forwarding that suppresses the RA, or a bridge label
whose core endpoint is unattached are independent seeded negatives, even when
solicit/advertise messages are logged and IPv4 DHCP succeeds. These predicates
apply identically to the first cold boot of NixOS and CLAB.

The selected path is direction-scoped. Under the core resolver's real runtime
UID, UDP/TCP destination-port-53 socket lookups must use the selected provider
before packet emission, while internal access/client replies to ephemeral
ports retain the modeled return path. An output-hook-only mark and a
process-wide UID rule are independent seeded negatives, even when the selected
table exists or core completes recursion internally.

The local-only resolver may forward only `lab.` and its modeled reverse zone to
the recursive access resolver. The opposite reachable direction is also
source-scoped `refuse_non_local`: local records work, public recursion and
borrowed/transitive egress do not.

Run the construction contract with:

```bash
tests/run-active-lab-mini-smt.sh --source FS-540-HDS-010-SDS-010-SMS-045
```

After every owning `network-*` revision is pushed, select this row, cold-stage
all three lab guests, verify their new boot/system/source pins, and run the
row-local live protocol from `network-codex-agent`. Previous 2026-07-03
IPv4-only evidence is superseded and cannot promote this revised atom. A
successful launcher or visible route without successful first-attempt
recursion, scoped resolver-identity UDP/TCP port-53 socket rules, an
identity-correct internal reply route, persistent listeners, and quiescent
route state is also insufficient. Public root availability, `example.com`, a
host resolver, or a transparent recursive provider is not a valid test oracle;
missing or external authority fails the row before protocol success is
evaluated.
