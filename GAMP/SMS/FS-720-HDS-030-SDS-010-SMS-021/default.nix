{
  layer = "SMS";
  traceId = "FS-720-HDS-030-SDS-010-SMS-021";
  parentSds = ../../SDS/FS-720-HDS-030-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-021-ae-cpm-only-consumption.md";
  titleSlug = "ae-cpm-only-consumption";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-720-HDS-030-SDS-010-SMS-021";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
