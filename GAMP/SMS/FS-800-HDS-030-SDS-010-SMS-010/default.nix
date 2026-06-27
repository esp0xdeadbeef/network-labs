{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side.md";
  titleSlug = "pppoe-provider-side";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-030-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
