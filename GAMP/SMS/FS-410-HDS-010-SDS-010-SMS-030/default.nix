{
  layer = "SMS";
  traceId = "FS-410-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-410-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-410-HDS-010-SDS-010-SMS-030-host128-tenant-nat66-requirement.md";
  titleSlug = "host128-tenant-nat66-requirement";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-410-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-410-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
