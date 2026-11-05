{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-020-SMS-040";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-040.md";
  titleSlug = "canonical-sms";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-030-SDS-020-SMS-040";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
