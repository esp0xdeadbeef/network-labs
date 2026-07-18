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
The access resolver binds `core-dns` by service/node identity; no core address
or public forwarder is present in the inventory. CPM derives the listener and
forwarder from the provider-side terminal attachment of the selected relation.
The selected path must govern the core resolver's first upstream route decision
for both families; observing the selected table after a failed request is not
sufficient. The live protocol also proves that the resolver process and
authorized listeners remain present and that unchanged dynamic next-hop state
converges without continuous refresh activity.

The selected path is direction-scoped. Under the core resolver's real runtime
UID, upstream destinations must use the selected provider while internal
access/client destinations must retain the modeled return path. A process-wide
UID rule that sends both classes to the provider is a seeded negative, even
when core completes recursion internally.

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
recursion, an identity-correct internal reply route, persistent listeners, and
quiescent route state is also insufficient.
