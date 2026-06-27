{
  layer = "SMS";
  traceId = "FS-310-HDS-010-SDS-010-SMS-130";
  parentSds = ../../SDS/FS-310-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-010-SDS-010-SMS-130-renderer-no-policy-invention.md";
  titleSlug = "renderer-no-policy-invention";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-010-SDS-010-SMS-130";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-130/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
