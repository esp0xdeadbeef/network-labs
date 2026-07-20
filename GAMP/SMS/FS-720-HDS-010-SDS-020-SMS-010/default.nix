{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-020-SMS-010-endpoint-inventory-source.md";
  titleSlug = "endpoint-inventory-source";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-720-HDS-010-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
