{
  layer = "SMS";
  traceId = "FS-560-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-560-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-560-HDS-010-SDS-020-SMS-010-local-namespace-sharing-normalization.md";
  titleSlug = "local-namespace-sharing-normalization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-560-HDS-010-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-560-HDS-010-SDS-020-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
