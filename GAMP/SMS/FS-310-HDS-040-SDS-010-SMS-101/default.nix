{
  layer = "SMS";
  traceId = "FS-310-HDS-040-SDS-010-SMS-101";
  parentSds = ../../SDS/FS-310-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-101-nixos-cpm-only-consumption.md";
  titleSlug = "nixos-cpm-only-consumption";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-040-SDS-010-SMS-101";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-101/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
