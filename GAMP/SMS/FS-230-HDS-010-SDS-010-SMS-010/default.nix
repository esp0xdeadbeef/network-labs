{
  layer = "SMS";
  traceId = "FS-230-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-230-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-010-public-ingress-return-translation.md";
  titleSlug = "public-ingress-return-translation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-230-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
