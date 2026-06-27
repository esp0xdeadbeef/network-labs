{
  layer = "SMS";
  traceId = "FS-770-HDS-010-SDS-030-SMS-010";
  parentSds = ../../SDS/FS-770-HDS-010-SDS-030;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-030-SMS-010-source-shape-diagnostic.md";
  titleSlug = "source-shape-diagnostic";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-770-HDS-010-SDS-030-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-030-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
