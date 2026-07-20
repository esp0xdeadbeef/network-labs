{
  layer = "SMS";
  traceId = "FS-220-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-220-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-220-HDS-010-SDS-010-SMS-010-public-ingress-uniqueness.md";
  titleSlug = "public-ingress-uniqueness";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-220-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-220-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
