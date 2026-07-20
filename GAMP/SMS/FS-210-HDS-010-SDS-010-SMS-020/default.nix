{
  layer = "SMS";
  traceId = "FS-210-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-210-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-210-HDS-010-SDS-010-SMS-020-public-ingress-tuple-binding.md";
  titleSlug = "public-ingress-tuple-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-210-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-210-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
