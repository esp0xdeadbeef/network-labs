{
  layer = "SMS";
  traceId = "FS-570-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-570-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-570-HDS-010-SDS-010-SMS-010-namespace-fallback.md";
  titleSlug = "namespace-fallback";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-570-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
