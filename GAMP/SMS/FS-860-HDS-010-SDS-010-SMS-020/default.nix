{
  layer = "SMS";
  traceId = "FS-860-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-860-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-020-required-state-retention.md";
  titleSlug = "required-state-retention";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-860-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
