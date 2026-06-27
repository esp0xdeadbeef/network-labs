{
  layer = "SMS";
  traceId = "FS-960-HDS-010-SDS-013-SMS-010";
  parentSds = ../../SDS/FS-960-HDS-010-SDS-013;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-013-SMS-010-marker-wait-ordering.md";
  titleSlug = "marker-wait-ordering";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-960-HDS-010-SDS-013-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-013-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
