{
  layer = "SMS";
  traceId = "FS-720-HDS-020-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-720-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-020-SDS-010-SMS-010-endpoint-inventory-union.md";
  titleSlug = "endpoint-inventory-union";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-720-HDS-020-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-720-HDS-020-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
