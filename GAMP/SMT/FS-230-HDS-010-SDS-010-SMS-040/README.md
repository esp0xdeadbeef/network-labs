# SMT Construction Candidate: FS-230-HDS-010-SDS-010-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md`

Status: NOT OK - native CPM/NixOS/CLAB construction is green but not yet cold
staged on the isolated three-host lab.

The `s-router-prod` intent tuple and inventory endpoint/protected-source facts
are valid migration input. They are not defects. The row fixture deliberately
keeps policy in `intent.nix` and the provider surface, endpoint address/IID and
protected prefix source in `inventory-router.nix`.

The pushed CPM and renderer candidates now prove equivalent construction for
the exact protected-runtime IPv6 UDP/4242 tuple, routes, no-translation and
stateful return. This is not live evidence: the row remains open until the
consumer pins are cold staged on `s-router-nixos`, `s-router-clab` and
`s-router-test-clients` without a hotpatch. A host-local nftables or
runtime-address compatibility module cannot close it.

Title slug: `native-nebula-ipv6-public-ingress-tuple-materialization`
