# SMT Construction Candidate: FS-230-HDS-010-SDS-010-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md`

Status: NOT OK - retry-6 cold-staged the exact pushed pins and deployed both
substrates without a hotpatch, but the NixOS service endpoint inherited a
default-deny firewall that rejected the modeled UDP datagram after all five
routers had delivered it.

The `s-router-prod` intent tuple and inventory endpoint/protected-source facts
are valid migration input. They are not defects. The row fixture deliberately
keeps policy plus the current-schema opaque routed-prefix allocation reference
in `intent.nix`, while `inventory-router.nix` owns the provider surface,
endpoint IID and host/interface realization. The protected prefix value itself
exists only in the SOPS-delivered runtime file.

The CPM, NixOS renderer and CLAB renderer preserve the exact protected-runtime
IPv6 UDP/4242 tuple, routes, no-translation and stateful return. The focused
CLAB keyword-interface negative and autonomous deploy now pass. Retry-6 then
proved that the allowed datagram crossed `core-lab-wan`, `upstream-selector`,
`policy`, `downstream-selector` and `access-dmz`, and reached the selected
service endpoint. The short-lived listener answered a local probe, but the
endpoint NixOS firewall sent the remote datagram to `nixos-fw-log-refuse`.

The endpoint fixture must therefore be policy-neutral: it shall neither inherit
an independent default-deny verdict nor create a tuple-specific allow. Router
policy remains the only network-policy authority under test. The row remains
open until `network-renderer-access-endpoint-nixos` proves that boundary, all
focused tests pass, the new pin is cold staged on the same three hosts, and the
same positive and negative flow matrix passes for NixOS and CLAB without a
hotpatch. A host-local nftables or runtime-address compatibility module cannot
close it.

Title slug: `native-nebula-ipv6-public-ingress-tuple-materialization`
