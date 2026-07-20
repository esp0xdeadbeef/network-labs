# SMS Mirror: FS-162-HDS-010-SDS-040-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: OK - focused construction proof passed at
`network-renderer-openconfig@9cff098bc2b9`.

The canonical SMS title slug is `s-router-prod-comparable-projection`. The
focused proof shall compile the pinned isolated FS-230 canonical intent with
the same compiler/CPM pins as the NixOS and CLAB paths and pass the OpenConfig
realization's own CPM identity directly to the OpenConfig path. It must prove
an identical normalized IPv6 UDP/4242, no-NAT66, preserve-source,
stateful-return, selected-path, and no-inherited-egress posture without reading
NixOS or CLAB output as input. Realization-specific CPM hashes may differ.
The proof reports CPM portability separately from complete OpenConfig
instance-model coverage; the latter remains false and is not part of this
portable-posture acceptance claim.
