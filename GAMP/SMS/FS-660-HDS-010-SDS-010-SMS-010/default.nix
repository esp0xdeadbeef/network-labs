{
  layer = "SMS";
  traceId = "FS-660-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-660-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-660-HDS-010-SDS-010-SMS-010-access-space-declaration.md";
  titleSlug = "access-space-declaration";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-660-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-660-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
