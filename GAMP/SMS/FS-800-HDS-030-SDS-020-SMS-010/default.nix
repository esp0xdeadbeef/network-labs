{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-record-checks.md";
  titleSlug = "pppoe-customer-side-record-checks";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-030-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
