{
  layer = "SMS";
  traceId = "FS-200-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-200-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-200-HDS-010-SDS-010-SMS-010-shared-service-exposure-boundary.md";
  titleSlug = "shared-service-exposure-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-200-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-200-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
