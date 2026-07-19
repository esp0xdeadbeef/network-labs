let
  router = import ./inventory-router.nix;
in
{
  meta = {
    traceId = "FS-230-HDS-010-SDS-010-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
    renderer = "nixos";
    scope = "isolated-construction-candidate";
    evidenceBoundary = "construction-only";
  };
  renderer = "nixos";
  realization = router;
}
