{
  layer = "SMS";
  traceId = "FS-670-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-670-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-670-HDS-010-SDS-010-SMS-010-tenant-access-matrix.md";
  titleSlug = "tenant-access-matrix";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-670-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-670-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
