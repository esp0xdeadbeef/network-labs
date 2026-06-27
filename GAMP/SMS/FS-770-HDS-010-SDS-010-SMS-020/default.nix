{
  layer = "SMS";
  traceId = "FS-770-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-770-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-010-SMS-020-common-behavior-field-presence.md";
  titleSlug = "common-behavior-field-presence";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-770-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
