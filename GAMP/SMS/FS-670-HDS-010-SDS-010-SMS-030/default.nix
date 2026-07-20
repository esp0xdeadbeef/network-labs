{
  layer = "SMS";
  traceId = "FS-670-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-670-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-670-HDS-010-SDS-010-SMS-030-tenant-service-policy.md";
  titleSlug = "tenant-service-policy";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-670-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-670-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
