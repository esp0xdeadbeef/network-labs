{
  layer = "SMS";
  traceId = "FS-750-HDS-020-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-750-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-750-HDS-020-SDS-010-SMS-010-receiver-service-surfaces.md";
  titleSlug = "receiver-service-surfaces";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-750-HDS-020-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-750-HDS-020-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
