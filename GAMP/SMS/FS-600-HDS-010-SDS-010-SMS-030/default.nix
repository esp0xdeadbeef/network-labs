{
  layer = "SMS";
  traceId = "FS-600-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-600-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-600-HDS-010-SDS-010-SMS-030-discovery-payload-state-matrix.md";
  titleSlug = "discovery-payload-state-matrix";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-600-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-600-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
