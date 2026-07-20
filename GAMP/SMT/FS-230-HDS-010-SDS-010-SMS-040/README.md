# SMT Construction Candidate: FS-230-HDS-010-SDS-010-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md`

Status: NOT OK - retry-4 reached the isolated CLAB deployment but rejected an
unquoted keyword-like nftables interface token before readiness.

The `s-router-prod` intent tuple and inventory endpoint/protected-source facts
are valid migration input. They are not defects. The row fixture deliberately
keeps policy plus the current-schema opaque routed-prefix allocation reference
in `intent.nix`, while `inventory-router.nix` owns the provider surface,
endpoint IID and host/interface realization. The protected prefix value itself
exists only in the SOPS-delivered runtime file.

The CPM and NixOS renderer candidates preserve the exact protected-runtime IPv6
UDP/4242 tuple, routes, no-translation and stateful return. The CLAB renderer
must additionally quote every mapped `iifname` and `oifname` as target-language
string data; retry-4 proved that an unquoted `policy` interface is parsed as an
nftables keyword and fails closed. The row remains open until the focused
keyword-interface negative passes and the pushed consumer pins are cold staged
on `s-router-nixos`, `s-router-clab` and `s-router-test-clients` without a
hotpatch. A host-local nftables or runtime-address compatibility module cannot
close it.

Title slug: `native-nebula-ipv6-public-ingress-tuple-materialization`
