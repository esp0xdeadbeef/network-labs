{
  layer = "SMS";
  traceId = "FS-310-HDS-040-SDS-010-SMS-102";
  parentSds = ../../SDS/FS-310-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-102-clab-cpm-only-consumption.md";
  titleSlug = "clab-cpm-only-consumption";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-040-SDS-010-SMS-102";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-102/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
