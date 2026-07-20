{
  layer = "SMS";
  traceId = "FS-970-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-970-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-010-SMS-030-static-reservation-duplicate-service-target-rejection.md";
  titleSlug = "static-reservation-duplicate-service-target-rejection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-970-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
