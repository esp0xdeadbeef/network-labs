{
  layer = "SMS";
  traceId = "FS-680-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-680-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-680-HDS-010-SDS-010-SMS-030-shared-service-payload.md";
  titleSlug = "shared-service-payload";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-680-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-680-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
