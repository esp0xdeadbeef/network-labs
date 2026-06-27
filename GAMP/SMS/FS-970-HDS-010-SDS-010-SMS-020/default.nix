{
  layer = "SMS";
  traceId = "FS-970-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-970-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-010-SMS-020-static-reservation-offset-resolution.md";
  titleSlug = "static-reservation-offset-resolution";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-970-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
