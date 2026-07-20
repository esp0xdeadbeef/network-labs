{
  layer = "SMS";
  traceId = "FS-790-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-790-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-790-HDS-010-SDS-010-SMS-020-public-ingress-port-target-binding.md";
  titleSlug = "public-ingress-port-target-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-790-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-790-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
