{
  layer = "SMS";
  traceId = "FS-800-HDS-020-SDS-021-SMS-010";
  parentSds = ../../SDS/FS-800-HDS-020-SDS-021;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.md";
  titleSlug = "hat-emulated-test-secret-materialization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-020-SDS-021-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
