{
  layer = "SMS";
  traceId = "FS-740-HDS-040-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-740-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-740-HDS-040-SDS-010-SMS-010-printer-denied-probe-surfaces.md";
  titleSlug = "printer-denied-probe-surfaces";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-740-HDS-040-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-740-HDS-040-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
