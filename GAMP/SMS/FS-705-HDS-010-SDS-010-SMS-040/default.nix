{
  layer = "SMS";
  traceId = "FS-705-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-705-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-705-HDS-010-SDS-010-SMS-040-access-client-endpoint-coverage.md";
  titleSlug = "access-client-endpoint-coverage";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-705-HDS-010-SDS-010-SMS-040";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
